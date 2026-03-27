import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/text.dart';
import 'package:flutter_space_shooter/data/font_palette.dart';

class ScoreComponent extends TextComponent {
  int score = 0;

  ScoreComponent() : super(text: 'Score: 0');

  @override
  Future<void> onLoad() async {
    super.onLoad();
    textRenderer = TextPaint(style: TextStyle(fontFamily: FontPalette.primaryTextFont, fontSize: 24, color: Color(0xFFFFFFFF)));
  } 

  void updateScore(int newScore) {
    // Throw a little animation
    score = newScore;
    text = 'Score: $score';
  }

  void animateScoreIncrease() {
    add(ScaleEffect.to(
      Vector2(1.5, 1.5), 
      EffectController(duration: 0.2, reverseDuration: 0.2),
    ));
  }
}
