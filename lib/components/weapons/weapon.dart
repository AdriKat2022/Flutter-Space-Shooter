import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flutter_space_shooter/components/bullet.dart';
import 'package:flutter_space_shooter/data/audio_manager.dart';
import 'package:flutter_space_shooter/utils/object_pool.dart';

/// Base class for all weapons.
abstract class Weapon<T extends Bullet> {

  Weapon({
    required owner,
    required positionTarget,
    required damage,
    required fireRate,
    required T Function() createObjectFunction,
    required factoryFunction,
    Vector2? offset,
    Color? bulletColor,
  }) : _fireRate = fireRate, _damage = damage, _factoryFunction = factoryFunction, _owner = owner, _positionTarget = positionTarget, _offset = offset ?? Vector2(0, 0)
  {

    late final createObject;
    if (bulletColor != null) {
      createObject = () {
          final object = createObjectFunction();
          object.decorator.addLast(PaintDecorator.tint(bulletColor));
          return object;
        };
    }
    else {
      createObject = createObjectFunction;
    }

    _bulletPool = ObjectPool<T>(
      maxSize: 30,
      createObjectFunction: createObject,
    );

    _bulletSpawner = SpawnComponent(
      period: _fireRate,
      selfPositioning: true,
      factory: (index) => _getProcessedBullet(index),
      autoStart: false,
    );
  }

  double get damage => _damage;

  double _damage;
  double _fireRate;
  final Component _owner; 
  final PositionComponent _positionTarget;
  final Vector2 _offset;

  /// The function that will modify the bullet before it's spawned.
  final T Function(int, T) _factoryFunction;

  late final ObjectPool<T> _bulletPool;
  late final SpawnComponent _bulletSpawner;

  /// Called at the beginning of the game to initialize the weapon.
  void init(){
    _owner.add(_bulletSpawner);
  }

  /// Called whenever this weapon is selected.
  void startShooting(){
    _bulletSpawner.timer.start();
  }

  /// Called whenever this weapon is deselected.
  void stopShooting(){
    _bulletSpawner.timer.stop();
  }

  /// Called whenever the secondary action is triggered.
  /// 
  /// For example, the secondary action could be a missile or a shield.
  /// [pressed] is true if the action is being pressed, false if it's being released.
  void secondaryAction(bool pressed);

  void clearAllProjectiles(){
    _bulletPool.emptyPool();
  }

  T _getProcessedBullet(int index){
    final bullet = _bulletPool.get();
    if (bullet == null) {
      throw Exception('Bullet pool is overloaded! Too much shooting? Try to increase the pool size is reasonnable.');
    }
    bullet.setDamage(_damage);
    bullet.position = _positionTarget.position + _offset;
    AudioManager.playSound('player_bullet');
    return _factoryFunction(index, bullet);
  }
}