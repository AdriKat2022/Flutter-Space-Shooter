import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_space_shooter/ui/button_component.dart';
import 'package:flutter_space_shooter/components/simple_square.dart';

/// ColorSelector: A DoubleSelectionButton to select colors
class ColorSelector extends PositionComponent {
  final List<Color> colors;
  int currentSelectionIndex = 0;

  double componentsSize = 50;
  double spacing = 10;

  late final ButtonComponent leftArrow;
  late final ButtonComponent rightArrow;
  late SimpleSquare colorSquare;

  Function(Color)? onColorSelected;

  ColorSelector({
    required this.colors,
    this.componentsSize = 50,
    this.spacing = 10,
    this.onColorSelected
  }) {
    anchor = Anchor.center;

    // Middle color square
    colorSquare = SimpleSquare(size: Vector2.all(componentsSize), color: colors[currentSelectionIndex]);
    colorSquare.anchor = Anchor.bottomLeft;
    add(colorSquare);
  }

  @override
  FutureOr<void> onLoad() async {

    // Left arrow button
    leftArrow = ButtonComponent(
      position: Vector2(-componentsSize - spacing, 0),
      text: 'Previous',
      size: Vector2(componentsSize, componentsSize),
      onPressed: _selectPreviousColor,
      normalSprite: await Sprite.load('ui/buttons/arrow_left.png'),
      hoverSprite: await Sprite.load('ui/buttons/arrow_left_hover.png'),
      pressedSprite: await Sprite.load('ui/buttons/arrow_left_pressed.png'),
    );

    // Right arrow button
    rightArrow = ButtonComponent(
      position: Vector2(componentsSize + spacing, 0),
      text: 'Next',
      size: Vector2(componentsSize, componentsSize),
      onPressed: _selectNextColor,
      normalSprite: await Sprite.load('ui/buttons/arrow_right.png'),
      hoverSprite: await Sprite.load('ui/buttons/arrow_right_hover.png'),
      pressedSprite: await Sprite.load('ui/buttons/arrow_right_pressed.png'),
    );

    leftArrow.anchor = Anchor.bottomLeft;
    rightArrow.anchor = Anchor.bottomLeft;

    add(leftArrow);
    add(rightArrow);

    return super.onLoad();
  }

  void _selectPreviousColor() {
    currentSelectionIndex = (currentSelectionIndex - 1 + colors.length) % colors.length;
    _updateColor();
  }

  void _selectNextColor() {
    currentSelectionIndex = (currentSelectionIndex + 1) % colors.length;
    _updateColor();
  }

  void _updateColor() {
    colorSquare.setColor(colors[currentSelectionIndex]);
    onColorSelected?.call(colors[currentSelectionIndex]);
  }
}