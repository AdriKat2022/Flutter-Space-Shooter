import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flutter_space_shooter/components/damageable_component.dart';
import 'package:flutter_space_shooter/components/enemy.dart';
import 'package:flutter_space_shooter/components/weapons/straight_gun.dart';
import 'package:flutter_space_shooter/components/weapons/weapon.dart';
import 'package:flutter_space_shooter/data/audio_manager.dart';
import 'package:flutter_space_shooter/effects/sprite_color_flash.dart';
import 'package:flutter_space_shooter/main.dart';
import 'package:flutter_space_shooter/utils/log_debug.dart';

class Player extends SpriteAnimationComponent with HasGameReference<SpaceShooterGame>, CollisionCallbacks, DamageableComponent {

  static const double bulletsPerSecond = 4;
  static const double bulletsBaseDamage = 5;

  int points = 0;

  late final SpriteColorFlash spriteColorFlash;

  // Load weapons.
  bool _canSwitchWeapon = false;
  int _currentWeaponIndex = 0;
  final _weaponsList = <Weapon>[];
  late Weapon _currentWeapon;

  Player({double maxHP = 3}) : super(
    size: Vector2(100, 150) * 0.8,
    anchor: Anchor.center,
  ){
    setMaxHp(maxHP);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = game.size/2;
    spriteColorFlash = SpriteColorFlash(this, 0, 0.1, 0.5, Color(0xFFFF0000));

    // Load Animation.
    animation = await game.loadSpriteAnimation(
      'ships/player_sheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(32, 48),
      ),
    );
    add(RectangleHitbox(collisionType: CollisionType.active));

    // Load weapons.
    // Those are examples, but we could have multiple classes so we can have different weapons with different bullets.
    _weaponsList.addAll([
      StraightGun(owner: game, positionTarget: this, damage: 2, fireRate: 0.1, offset: Vector2(0, -50)),
      StraightGun(owner: game, positionTarget: this, damage: 10, fireRate: 0.4, offset: Vector2(0, -50), bulletColor: Color(0x88FF0000)),
    ]);

    _currentWeapon = _weaponsList[_currentWeaponIndex];
    for (final weapon in _weaponsList){
      weapon.init();
    }
  }

  void selectTintColor(Color color){
    decorator.removeLast();
    decorator.addLast(PaintDecorator.tint(color));
  }

  void switchWeapon(){
    if (!_canSwitchWeapon) return;
    _currentWeapon.stopShooting();
    _currentWeaponIndex = (_currentWeaponIndex + 1) % _weaponsList.length;
    _currentWeapon = _weaponsList[_currentWeaponIndex];
    _currentWeapon.startShooting();
    LogDebug.printToHUD(game, "Switched to weapon ${_currentWeaponIndex + 1}");
    AudioManager.playSound('weapon_switch');
  }

  void move(Vector2 delta){
    if (isHpZeroOrBelow()) return;
    position.add(delta);
  }

  void startShooting(){
    if (isHpZeroOrBelow()) return;
    LogDebug.printToHUD(game, "Player started shooting.");
    _canSwitchWeapon = true;
    _currentWeapon.startShooting();
  }

  void stopShooting(){
    if (isHpZeroOrBelow()) return;
    _currentWeapon.stopShooting();
  }

  void addScore(int score){
    points += score;
    game.gameUI.scoreComponent.updateScore(points);
  }

  void disablePlayer(){
    _canSwitchWeapon = false;
    _currentWeapon.stopShooting();
    removeFromParent();
    game.gameOver();
  }

  void reset(){
    fullHeal();
    stopShooting();
    _emptyWeapons();
    _currentWeaponIndex = 0;
    _currentWeapon = _weaponsList[_currentWeaponIndex];
    game.gameUI.heartsBar.updateLives(getHp().toInt());
    game.gameUI.scoreComponent.updateScore(0);
    points = 0;
    position = game.size/2;
    _canSwitchWeapon = true;
    removeFromParent();
    game.add(this);
  }

  void damagePlayer(){
    spriteColorFlash.activate();
    takeDamage(1);
    LogDebug.printToHUD(game, "Player took damage. HP: ${getHp()}");
    if (isHpZeroOrBelow()){
      disablePlayer();
    }
    game.gameUI.heartsBar.updateLives(getHp().toInt());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (isHpZeroOrBelow()) return;
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy){
      print("player took damage");
      other.death(false);
      damagePlayer();
    }
  }

  void _emptyWeapons(){
    for (final weapon in _weaponsList){
      weapon.clearAllProjectiles();
    }
  }
}