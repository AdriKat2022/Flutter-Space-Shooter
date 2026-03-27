import 'package:flame/collisions.dart';
import 'package:flutter_space_shooter/main.dart';
import 'package:flame/components.dart';
import 'package:flutter_space_shooter/utils/poolable_object.dart';

class Bullet extends SpriteAnimationComponent with HasGameReference<SpaceShooterGame> implements PoolableObject {

  double _bulletSpeed = 700;
  bool isPooled = true;
  double baseDamage = 10;

  Bullet({
    super.position,
  }) : super(
      size: Vector2.all(16),
      anchor: Anchor.center,
    );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RectangleHitbox(collisionType: CollisionType.passive));

    animation = await game.loadSpriteAnimation(
      'bullets/player_bullet_sheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.05,
        textureSize: Vector2(6, 16),
      ),
    );
  }

  @override
  void update(double dt){
    if (isPooled) return;
    super.update(dt);
    position.y += dt * -_bulletSpeed;

    if (position.y < -height){
      deleteBullet();
    }
  }

  void setDamage(double newDamage){
    baseDamage = newDamage;
  }

  double getDamage(){
    return baseDamage;
  }

  void deleteBullet(){
    removeFromParent();
    pool();
  }
  
  @override
  void pool() {
    isPooled = true;
  }
  
  @override
  void reset() {
  }
  
  @override
  void unpool() {
    isPooled = false;
  }
}