# flutter_space_shooter
A small Shoot'Em Up! project that aims at demonstrating my capacities to adapt to a new game engine.

# Objectives (TODO LIST)
[x] A hosted working web game on github pages.  
[x] The game has win and lose conditions.  
[x] The game level is replayable.  
[x] The game has placeholder art and audio assets.  
[x] The game should demonstrate a well-thought-out project structure that is scalable.  
    - The ObjectPool<T> for example, or even most of UI elements like ToogleButton and ColorSelector that are highly reusable.  
[x] The game uses Flame effects to modify the properties/appearance of a component (https://docs.flame-engine.org/1.6.0/flame/effects.html).  
    - Lives are shrinking down when lost.  
    - Color effect is applied on enemies and the player when hurt.  
[x] The game has some form of input to change the game state.  
    - The mouse can press button or just move the ship.  
    - The SPACE bar can switch weapons.  
[x] The game has background music and some audio effects (https://docs.flame-engine.org/1.6.0/bridge_packages/flame_audio/audio.html#audio).  
[ ] The game uses some Flame particle effects (https://docs.flame-engine.org/1.6.0/flame/rendering/particles.html#particles).  
[x] The game has at least one spritesheet animation (https://pub.dev/packages/flame_texturepacker).  
    - For the enemies, buttons, and the player.
[X] The game has UI that shows the game state, such as lives or points.  
    - Lives, points and tutorial/begin/end text.  
[x] The game has at least one decorator to change the appearance of a sprite (https://docs.flame-engine.org/1.6.0/flame/rendering/decorators.html#decorators).  
    - Player can switch their skin color with the ColorSelector (bottom right hand corner).  
[ ] The game has at least one custom space transformation (besides those the Flame engine already applies) to change the coordinate system or add an effect of sorts (https://www.brainvoyager.com/bv/doc/UsersGuide/CoordsAndTransforms/SpatialTransformationMatrices.html).  
[ ] The game uses BLOC for state management.  
[x] Apply at least three design patterns:  
[x] Apply the state design pattern for player state (https://refactoring.guru/design-patterns/state).  
    - Used it for the weapon state (although it may resamble more the strategy pattern).  
[x] Apply the strategy design pattern for different strategies, possibly for enemies or projectiles (https://refactoring.guru/design-patterns/strategy).  
    - Used it for the enemy behaviors.  
[x] Apply the object pool design pattern to objects that are spawned in larger amounts, such as enemies or projectiles (https://sourcemaking.com/design_patterns/object_pool).  
    - Used it for the enemies and projectiles. Could be also used for explosions.  
[x] Style you code according to the effective dart style guide.  
    - Made my best to follow at least the most important rules conventions.  

## Main features
- Switchable weapon state.
- Waves of enemies "Data Driven".
- Generic object pool.

## Commands
- [*Mouse*]: Move the ship.
- [*SPACE*]: Start / Switch Weapons

# Credits
- Fonts  
    - [**Fragile Bombers**](https://www.dafont.com/fragile-bombers.font), by Typodermic Fonts.  
    - [**Good Timing**](https://typodermicfonts.com/good-timing/), by Typodermic Fonts.
- Assets
    - [**Space Shooter Asset Pack**](https://gvituri.itch.io/space-shooter), by Gustavo Vituri.