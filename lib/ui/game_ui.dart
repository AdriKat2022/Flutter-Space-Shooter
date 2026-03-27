
import 'package:flame/components.dart';
import 'package:flutter_space_shooter/ui/button_component.dart';
import 'package:flutter_space_shooter/ui/color_selector.dart';
import 'package:flutter_space_shooter/ui/hearts_bar.dart';
import 'package:flutter_space_shooter/ui/score_component.dart';
import 'package:flutter_space_shooter/ui/toogle_button.dart';
import 'package:flutter_space_shooter/data/font_palette.dart';
import 'package:flutter_space_shooter/effects/fade_out_text_notification.dart';
import 'package:flutter_space_shooter/main.dart';
import 'package:flutter_space_shooter/utils/log_debug.dart';

class GameUI extends Component with HasGameReference<SpaceShooterGame>{

  final HeartsBarComponent heartsBar = HeartsBarComponent(lives: SpaceShooterGame.playerMaxHp);
  final ScoreComponent scoreComponent = ScoreComponent();
  final Function _restartGameFunction;

  late final ColorSelector _colorSelector;
  late final ButtonComponent _restartButton;
  late final ButtonComponent _playButton;

  late final FadingNotificationText _beginNotification;
  late final FadingNotificationText _weaponTutorialNotification;
  late final FadingNotificationText _gameOverNotification;
  late final FadingNotificationText _winNotification;

  late final ToogleButton _showDebugButton;

  GameUI({required Function restartGameFunction}) : _restartGameFunction = restartGameFunction;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    final notificationText = FadingNotificationText(text: "Move your ship with [Mouse]", position: Vector2(game.size.x/2, game.size.y/5));
    add(notificationText);
    notificationText.triggerEffect(overrideFadeInDuration: 0.5, overrideHoldDuration: 8, overrideFadeOutDuration: 0.5);

    _beginNotification = FadingNotificationText(text: "Press [SPACE] to begin !", position: Vector2(game.size.x/2, game.size.y/4));
    add(_beginNotification);
    _beginNotification.triggerEffect(overrideFadeInDuration: 0.5, overrideHoldDuration: 8, overrideFadeOutDuration: 0.5);

    _weaponTutorialNotification = FadingNotificationText(text: "Press [SPACE] to switch weapons !", position: Vector2(game.size.x/2, 3*game.size.y/4), defaultHoldDuration: 8);
    _gameOverNotification = FadingNotificationText(text: "Game Over !", position: Vector2(game.size.x/2, game.size.y/4), fontSize: 48);
    _winNotification = FadingNotificationText(text: "You Win !", position: Vector2(game.size.x/2, game.size.y/4), fontSize: 48);

    heartsBar.anchor = Anchor.topLeft;
    heartsBar.position = Vector2(50, 50);
    add(heartsBar);
    scoreComponent.position = Vector2(game.size.x - 50, 50);
    scoreComponent.anchor = Anchor.topRight;
    scoreComponent.scale = Vector2.all(2);
    add(scoreComponent);

    _showDebugButton = ToogleButton(
      position: Vector2(100, game.size.y - 100),
      size: Vector2.all(50),
      text: 'Show Debug',
      fontSize: 25,
      onChange: () {
        if (_showDebugButton.isOn) {
          LogDebug.showDebug = true;
          LogDebug.printToHUD(game, "Debug log mode: [${_showDebugButton.isOn? 'ON' : 'OFF'}]");
        }
        else {
          LogDebug.printToHUD(game, "Debug log mode: [${_showDebugButton.isOn? 'ON' : 'OFF'}]");
          LogDebug.showDebug = false;
        }
      },
      offNormalSprite: await Sprite.load('ui/buttons/toogle_btn.png'),
      offHoverSprite: await Sprite.load('ui/buttons/toogle_btn_hover.png'),
      offPressedSprite: await Sprite.load('ui/buttons/toogle_btn_pressed.png'),
      onNormalSprite: await Sprite.load('ui/buttons/toogle_btn_on.png'),
      onHoverSprite: await Sprite.load('ui/buttons/toogle_btn_on_hover.png'),
      onPressedSprite: await Sprite.load('ui/buttons/toogle_btn_on_pressed.png'),
    );
    add(_showDebugButton);

    _playButton = ButtonComponent(
        text: 'Play',
        onPressed: () {
          game.gameStart();
        },
        normalSprite: await Sprite.load('ui/buttons/play_btn.png'),
        hoverSprite: await Sprite.load('ui/buttons/play_btn_hover.png'),
        pressedSprite: await Sprite.load('ui/buttons/play_btn_pressed.png'),
        position: Vector2(game.size.x/2 , game.size.y/2),
        size: Vector2.all(100)
      );
    _playButton.anchor = Anchor.center;
    add(_playButton);

    _restartButton = ButtonComponent(
        text: 'Restart',
        onPressed: () {
          LogDebug.printToHUD(game, "Game reset!");
          _restartGameFunction();
        },
        normalSprite: await Sprite.load('ui/buttons/return_btn.png'),
        hoverSprite: await Sprite.load('ui/buttons/return_btn_hover.png'),
        pressedSprite: await Sprite.load('ui/buttons/return_btn_pressed.png'),
        position: Vector2(game.size.x/2 , game.size.y - 50),
        size: Vector2.all(50)
      );
    _restartButton.anchor = Anchor.bottomCenter;
    // add(_restartButton);

    _colorSelector = (ColorSelector(
      colors: FontPalette.shipAvailableColors,
      componentsSize: 50,
      spacing: 10,
      onColorSelected: (color) {
        game.player.selectTintColor(color);
      }
    ));
    _colorSelector.position = Vector2(game.size.x - 150, game.size.y - 100);
    _colorSelector.anchor = Anchor.bottomRight;
    add(_colorSelector);

    priority = 10;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    heartsBar.position = Vector2(50, 50);
    scoreComponent.position = Vector2(gameSize.x - 50, 50);
    _restartButton.position = Vector2(gameSize.x/2 , gameSize.y - 50);
    _colorSelector.position = Vector2(gameSize.x - 150, gameSize.y - 50);
    _showDebugButton.position = Vector2(100, gameSize.y - 100);
    _playButton.position = Vector2(gameSize.x/2 , gameSize.y/2);
    _beginNotification.position = Vector2(gameSize.x/2, gameSize.y/4);
    _weaponTutorialNotification.position = Vector2(gameSize.x/2, 3*gameSize.y/4);
    _gameOverNotification.position = Vector2(gameSize.x/2, gameSize.y/4);
    _winNotification.position = Vector2(gameSize.x/2, gameSize.y/4);
  }

  void onGameStart(){
    if(_beginNotification.parent != null){
      _beginNotification.removeFromParent();
    }
    if(_playButton.parent != null){
      _playButton.removeFromParent();
    }
  }

  void onGameReset(){
    // Only add the notification if it's not already added.
    if(_beginNotification.parent == null){
      add(_beginNotification);
      _beginNotification.triggerEffect(overrideFadeInDuration: 0.5, overrideHoldDuration: 8, overrideFadeOutDuration: 0.5);
    }
    if(_playButton.parent == null){
      add(_playButton);
    }
    if(_gameOverNotification.parent != null){
      _gameOverNotification.removeFromParent();
    }
    if(_winNotification.parent != null){
      _winNotification.removeFromParent();
    }
    if(_restartButton.parent != null){
      _restartButton.removeFromParent();
    }
    toogleTutorial(false);
  }

  void onGameOver(){
    if(_gameOverNotification.parent == null){
      add(_gameOverNotification);
    }
    if(_restartButton.parent == null){
      add(_restartButton);
    }
    toogleTutorial(false);
  }

  void onGameWin(){
    if(_winNotification.parent == null){
      add(_winNotification);
    }
    if(_restartButton.parent == null){
      add(_restartButton);
    }
    toogleTutorial(false);
  }

  void toogleTutorial(bool show){
    if(show && _weaponTutorialNotification.parent == null){
      add(_weaponTutorialNotification);
      _weaponTutorialNotification.triggerEffect();
    }
    else if (!show && _weaponTutorialNotification.parent != null){
      _weaponTutorialNotification.removeFromParent();
    }
  }
}