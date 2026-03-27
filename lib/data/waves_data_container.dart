import 'package:flame/game.dart';
import 'package:flutter_space_shooter/data/wave_data.dart';

class WavesDataContainer {

  // Wave Data list.
  static final List<WaveData> wavePattern_1 = [
    WaveData(
      enemies: [
        // Zigzag pattern with increasing delay
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(100, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(200, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(300, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(400, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(500, -50), delay: 0.5),
        // Tanks for a challenge
        EnemyData(type: EnemyTypes.tank, position: Vector2(600, -50), delay: 0),
        EnemyData(type: EnemyTypes.tank, position: Vector2(700, -50), delay: 0),
      ],
      prewaveDelay: 5,
    ),
    WaveData(
      enemies: [
        // Alternating basic and zigzag enemies
        EnemyData(type: EnemyTypes.basic, position: Vector2(150, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(250, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.basic, position: Vector2(350, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(450, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.basic, position: Vector2(550, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(650, -50), delay: 0.5),
        // Strong tank at the end
        EnemyData(type: EnemyTypes.tank, position: Vector2(300, -50), delay: 0),
      ],
      prewaveDelay: 5,
    ),
    WaveData(
      enemies: [
        // Line of basic enemies, faster spawning
        EnemyData(type: EnemyTypes.basic, position: Vector2(100, -50), delay: 0.2),
        EnemyData(type: EnemyTypes.basic, position: Vector2(200, -50), delay: 0.2),
        EnemyData(type: EnemyTypes.basic, position: Vector2(300, -50), delay: 0.2),
        EnemyData(type: EnemyTypes.basic, position: Vector2(400, -50), delay: 0.2),
        EnemyData(type: EnemyTypes.basic, position: Vector2(500, -50), delay: 0.2),
        // Followed by zigzag enemies
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(150, -50), delay: 0.2),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(250, -50), delay: 0.2),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(350, -50), delay: 0.2),
        // Tanks spread out
        EnemyData(type: EnemyTypes.tank, position: Vector2(450, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.tank, position: Vector2(550, -50), delay: 0),
      ],
      prewaveDelay: 5,
    ),
    WaveData(
      enemies: [
        // V-formation attack
        EnemyData(type: EnemyTypes.basic, position: Vector2(200, -50), delay: 0),
        EnemyData(type: EnemyTypes.basic, position: Vector2(300, -50), delay: 0),
        EnemyData(type: EnemyTypes.basic, position: Vector2(400, -50), delay: 0),
        EnemyData(type: EnemyTypes.basic, position: Vector2(500, -50), delay: 1),
        EnemyData(type: EnemyTypes.basic, position: Vector2(300, -50), delay: 0),
        EnemyData(type: EnemyTypes.basic, position: Vector2(400, -50), delay: 1),
        EnemyData(type: EnemyTypes.tank, position: Vector2(350, -50), delay: 0.5),
        // Sneaky zigzag backup
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(250, -50), delay: 0),
        EnemyData(type: EnemyTypes.zigzag, position: Vector2(450, -50), delay: 0),
      ],
      prewaveDelay: 8,
    ),
    WaveData(
      enemies: [
        // Boss-style tank rush
        EnemyData(type: EnemyTypes.tank, position: Vector2(300, -50), delay: 1),
        EnemyData(type: EnemyTypes.tank, position: Vector2(400, -50), delay: 1),
        EnemyData(type: EnemyTypes.tank, position: Vector2(500, -50), delay: 1),
        EnemyData(type: EnemyTypes.tank, position: Vector2(600, -50), delay: 1),
        // Basic enemies as distractions
        EnemyData(type: EnemyTypes.basic, position: Vector2(200, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.basic, position: Vector2(100, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.basic, position: Vector2(300, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.basic, position: Vector2(400, -50), delay: 0.5),
        EnemyData(type: EnemyTypes.basic, position: Vector2(500, -50), delay: 8),
      ],
      prewaveDelay: 10,
    ),
  ];
}