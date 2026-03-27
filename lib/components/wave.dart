import 'package:flame/components.dart';
import 'package:flutter_space_shooter/main.dart';
import 'package:flutter_space_shooter/components/enemy.dart';
import 'package:flutter_space_shooter/utils/log_debug.dart';
import 'package:flutter_space_shooter/utils/object_pool.dart';
import 'package:flutter_space_shooter/data/wave_data.dart';

/// In a wave, enemies are spawned in a sequence, with a delay between each enemy, it should be data driven.
class WaveManager extends Component with HasGameReference<SpaceShooterGame> {
  final ObjectPool<Enemy> enemyPool;
  final List<WaveData> waveDataList;

  double timeSinceWaveStarted = 0;
  double nextEnemyTime = 0;

  int enemyIndex = 0;
  int currentWaveIndex = 0;
  bool isRunActive = false;
  bool isWaveActive = false;
  bool resetFlag = false;

  WaveManager({
    required this.enemyPool,
    required this.waveDataList,
  });

  @override
  void update(double dt) {
    super.update(dt);

    if (!isRunActive) return;

    if (resetFlag) {
      resetFlag = false;
      timeSinceWaveStarted = 0;
    }

    if (currentWaveIndex >= waveDataList.length){
      game.gameWin();
      return; // No more waves.
    }

    final currentWave = waveDataList[currentWaveIndex];

    // Pre-wave delay
    if (!isWaveActive) {
      timeSinceWaveStarted += dt;
      if (timeSinceWaveStarted >= currentWave.prewaveDelay) {
        isWaveActive = true;
        timeSinceWaveStarted = 0;
        nextEnemyTime = 0;
        LogDebug.printToHUD(game, "Wave $currentWaveIndex started.");
      }
      return;
    }

    nextEnemyTime -= dt;

    // Spawn enemies at defined intervals.
    if (nextEnemyTime <= 0) {

      // Check if there are more enemies to spawn.
      if (currentWave.enemies.length > enemyIndex) {
        // Spawn enemies while the next enemy time is less than or equal to 0 (meaning no delay in the wave data).
        while(nextEnemyTime <= 0 && currentWave.enemies.length > enemyIndex) {
          spawnNextEnemy(currentWave, enemyIndex);
          enemyIndex++;
        }
      }
      else {
        // No more enemies, wave is complete.
        LogDebug.printToHUD(game, "Wave $currentWaveIndex complete.");
        isWaveActive = false;
        currentWaveIndex++;
        enemyIndex = 0;
        if (currentWaveIndex < waveDataList.length) {
          LogDebug.printToHUD(game, "Next wave in ${waveDataList[currentWaveIndex].prewaveDelay} seconds.");
        }
        else
        {
          LogDebug.printToHUD(game, "No more waves.");
        }
      }
    }
  }

  /// Spawns the next enemy in the wave and set the delay for the next enemy.
  void spawnNextEnemy(WaveData currentWave, int enemyIndex) async {
    // Spawn the next enemy in the wave.
    final enemyData = currentWave.enemies[enemyIndex];

    // Spawn the enemy using the pool.
    final enemy = enemyPool.get();
    if (enemy != null) {
      print("enemy spawned successfully (identity: " + identityHashCode(enemy).toString() + ")");
      // Get enemy properties
      final enemyProperties = EnemyTypes.getProperties(enemyData.type);
      enemy.position = enemyData.position;
      enemy.speed = enemyProperties['speed'];
      enemy.setMoveStrategy(enemyProperties['move_strategy']);
      enemy.setMaxHp(enemyProperties['health']);
      enemy.setSize(Vector2.all(enemyProperties['size']));
      // We would like to set the sprite here, but we need to load it first so we're not doing it for now.
      enemy.initializeEnemy();
      enemy.reset();
      game.add(enemy);
    }


    nextEnemyTime = enemyData.delay;
  }

  void reset(){
    isRunActive = false;
    resetFlag = true;
    isWaveActive = false;
    timeSinceWaveStarted = 0;
    nextEnemyTime = 0;
    enemyIndex = 0;
    currentWaveIndex = 0;
  }

  void startRun(){
    isRunActive = true;
  }
}
