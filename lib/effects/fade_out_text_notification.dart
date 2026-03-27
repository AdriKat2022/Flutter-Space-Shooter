import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_space_shooter/data/font_palette.dart';
import 'package:flutter_space_shooter/main.dart';
import 'package:flutter_space_shooter/utils/log_debug.dart';

class FadingNotificationText extends TextComponent with HasGameReference<SpaceShooterGame> implements OpacityProvider {

  @override
  double opacity = 0;
  double defaultFadeInDuration;
  double defaultHoldDuration;
  double defaultFadeOutDuration;

  FadingNotificationText({
    required String text,
    required Vector2 position,
    this.defaultFadeInDuration = 0.5,
    this.defaultHoldDuration = 8,
    this.defaultFadeOutDuration = 0.5,
    double fontSize = 24,
    Anchor anchor = Anchor.topCenter,
    TextStyle? textStyle,
  }) : super(
          text: text,
          position: position,
          anchor: anchor,
        )
  {
    textRenderer = TextPaint(
      style: textStyle ?? TextStyle(fontFamily: FontPalette.primaryTextFont, fontSize: fontSize, color: Colors.white),
    );
  }

  /// Changes the text dynamically.
  void setText(String newText) {
    text = newText;
  }

  /// Trigger the text effect.
  /// 
  /// Spoilers: The fade effect doesn't work since the Flame library doesn't seem to support text opacity.
  void triggerEffect({
    double? overrideFadeInDuration,
    double? overrideHoldDuration,
    double? overrideFadeOutDuration,
    double blinkSpeed = 1,
    int blinkCount = 0,
    bool fadeOutWhileBlinking = false
  }) {

    print("triggering effect");

    double fadeInDuration = overrideFadeInDuration ?? defaultFadeInDuration;
    double holdDuration = overrideHoldDuration ?? defaultHoldDuration;
    double fadeOutDuration = overrideFadeOutDuration ?? defaultFadeOutDuration;

    if (blinkCount > 0) {
      LogDebug.printToHUD(game, "Blinking effect not supported!");
      return;
    }
    else {
      print("simple effect: fadein=$overrideFadeInDuration s, hold=$holdDuration s, fadeout=$overrideFadeOutDuration s");
      // Add a simple fade-out effect if no flicker is required.
      add(
        OpacityEffect.fadeIn(
          EffectController(
            duration: fadeInDuration,
            atMaxDuration: holdDuration,
            reverseDuration: fadeOutDuration,

          ),
          onComplete: () {
            // Hide the text after the fade-out completes.
            removeFromParent();
          },
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // The opacity cannot be repercuted directly on the text component (This is an issue with the Flame library, we would need a workaround).
  }
}
