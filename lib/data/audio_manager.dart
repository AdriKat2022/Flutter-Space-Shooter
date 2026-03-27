import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flutter_space_shooter/utils/log_debug.dart';

class AudioManager {
  static late final FlameGame game;

  static String? currentMusicPlaying;

  static final musicFiles = <String, String>{
    'main_theme': 'musics/main_music.wav',
  };

  static final soundFileNames = <String, String>{
    'sounds/click.wav': 'click',
    'sounds/explosion.wav': 'explosion',
    'sounds/player_bullet.wav': 'player_bullet',
    'sounds/enemy_hurt.wav': 'enemy_hurt',
    'sounds/weapon_switch.wav': 'weapon_switch',
    // 'sounds/player_hurt.wav': 'player_hurt',
    // 'sounds/score.wav': 'score',
    // 'sounds/game_over.wav': 'game_over',
    // 'sounds/game_win.wav': 'game_win',
  };

  static var soundFilePools = <String, AudioPool>{};

  static void playMusic(
    String music, {
    double volume = 0.5,
    bool loop = true,
    bool forceRestart = true,
  }) {
    final audioFile = musicFiles[music];
    if (audioFile == null) {
      LogDebug.printToHUD(game, 'Music $music not found!');
      throw ArgumentError('Music $music not found!');
    }
    // If the music is already playing, don't restart it unless forceRestart is true.
    if (!forceRestart && isMusicPlaying(musicName: music)) {
      LogDebug.printToHUD(game, 'Already playing music $music');
      return;
    }
    LogDebug.printToHUD(
      game,
      'Playing music $music${forceRestart ? 'forceRestart=TRUE' : ''}.',
    );
    FlameAudio.bgm.initialize();
    currentMusicPlaying = music;
    FlameAudio.bgm.play(audioFile, volume: volume);
  }

  /// Returns true if music is playing, false otherwise.
  ///
  /// If [musicName] is provided, it will return true if the music with that name is playing.
  static bool isMusicPlaying({String? musicName}) {
    if (musicName != null) {
      return FlameAudio.bgm.isPlaying && musicName == currentMusicPlaying;
    }
    return FlameAudio.bgm.isPlaying;
  }

  static void stopMusic() {
    FlameAudio.bgm.stop();
  }

  static void playSound(String soundName, {double volume = 1.0}) {
    final audioPool = soundFilePools[soundName];
    if (audioPool == null) {
      throw ArgumentError('Sound $soundName not found!');
    }
    audioPool.start(volume: volume);
  }

  static void initialize() async {
    for (final soundFile in soundFileNames.keys) {
      final name = soundFileNames[soundFile];
      if (name == null) {
        throw ArgumentError("Name of sound '$soundFile' not found!");
      }
      await FlameAudio.audioCache.load(soundFile);
      soundFilePools[name] = await FlameAudio.createPool(
        soundFile,
        minPlayers: 1,
        maxPlayers: 2,
      );
    }
    LogDebug.printToHUD(game, 'AudioManager initialized.');
  }
}
