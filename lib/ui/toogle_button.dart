import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_space_shooter/data/font_palette.dart';
import 'package:flutter_space_shooter/ui/button_component.dart';

class ToogleButton extends ButtonComponent {

  bool get isOn => _isOn;
  bool _isOn = false;

  late final Sprite _offNormalSprite;
  late final Sprite _offHoverSprite;
  late final Sprite _offPressedSprite;
  late final Sprite _onNormalSprite;
  late final Sprite _onHoverSprite;
  late final Sprite _onPressedSprite;

  late final TextComponent _textLabel;

  ToogleButton({
    required super.position,
    required super.text,
    required VoidCallback onChange,
    required Sprite offNormalSprite,
    required Sprite offHoverSprite,
    required Sprite offPressedSprite,
    required Sprite onNormalSprite,
    required Sprite onHoverSprite,
    required Sprite onPressedSprite,
    super.size,
    double spacing = 15,
    double fontSize = 20,
  }) :
  _onPressedSprite = onPressedSprite, _onHoverSprite = onHoverSprite, _onNormalSprite = onNormalSprite,
  _offHoverSprite = offHoverSprite, _offNormalSprite = offNormalSprite, _offPressedSprite = offPressedSprite,
  super(
          onPressed: onChange,
          normalSprite: offNormalSprite,
          hoverSprite: offHoverSprite,
          pressedSprite: offPressedSprite,
        )
  {
    _textLabel = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontFamily: FontPalette.primaryTextFont,
          fontSize: fontSize,
        ),
      ),
      anchor: Anchor.centerLeft,
    );

    _textLabel.position = Vector2(size.x + spacing, size.y / 2);
    add(_textLabel);
  }

  @override
  void onTapUp(TapUpEvent event) {
    toogle();
    super.onTapUp(event);
  }


  /// Toogles the button state.
  void toogle() {
    _isOn = !_isOn;

    // Update the sprites.
    if (_isOn) {
      normalSprite = _onNormalSprite;
      hoverSprite = _onHoverSprite;
      pressedSprite = _onPressedSprite;
    }
    else {
      normalSprite = _offNormalSprite;
      hoverSprite = _offHoverSprite;
      pressedSprite = _offPressedSprite;
    }
  }
}