import 'package:flame/components.dart';
import 'package:flutter_space_shooter/utils/poolable_object.dart';

/// Provide a pool pattern for objects of type [T].
///
/// Objects are not removed from the pool, they are just marked as available or not.
/// The pool flag is located in the Object itself since it should be implementing the PoolableObject interface.
class ObjectPool<T extends PoolableObject>{

  ObjectPool({required int maxSize, required T Function() createObjectFunction}) : _createObjectFunction = createObjectFunction, _maxSize = maxSize;

  final int _maxSize;
  final T Function() _createObjectFunction;
  final List<T> _pool = [];

  /// Get an object from the pool (or create one).
  T? get(){

    // Search for an available object in the pool.
    for(var object in _pool){
      if(object.isPooled){
        object.unpool();
        object.reset();
        print(T.toString() + " un-pooled!");
        return object;
      }
    }

    // Create a new object if none is available.
    if (_pool.length < _maxSize){
      final poolableObject = _createObjectFunction();
      _pool.add(poolableObject);
      poolableObject.unpool();
      poolableObject.reset();
      print(T.toString() + " created and un-pooled!");
      return poolableObject;
    }

    print("Pool is all occupied!");
    return null;
  }

  /// Puts an object back into the pool.
  /// Mostly unused in this project since objects sets their flag on their own instead of using this function.
  void putBack(T object){
    if (_pool.contains(object)){
      object.pool();
      print(T.toString() + " re-pooled!");
    }
  }

  void emptyPool(){
    for (final object in _pool){
      if (object is Component){
        final component = object as Component;
        component.removeFromParent();
      }
    }
    _pool.clear();
  }
}