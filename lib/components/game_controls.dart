
import 'dart:math' show Point;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameControls extends PositionComponent with TapCallbacks {
  GameControls({
    required Vector2 size,
    required this.onDirectionChanged,
  }) : super(size: size);

  final void Function(Point<int> direction) onDirectionChanged;

  static const double buttonSize = 56;
  static const double gap = 12;

  final Paint _buttonPaint = Paint()
    ..color = const Color(0xFF3A5A40);

  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  Rect _buttonRect(double centerX, double centerY) {
    return Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: buttonSize,
      height: buttonSize,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final offset = buttonSize + gap;

    _drawButton(canvas, centerX, centerY - offset, '↑');
    _drawButton(canvas, centerX - offset, centerY, '←');
    _drawButton(canvas, centerX + offset, centerY, '→');
    _drawButton(canvas, centerX, centerY + offset, '↓');
  }

  void _drawButton(
    Canvas canvas,
    double centerX,
    double centerY,
    String arrow,
  ) {
    final rect = _buttonRect(centerX, centerY);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(12),
      ),
      _buttonPaint,
    );

    _textPainter.text = TextSpan(
      text: arrow,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    );

    _textPainter.layout();

    _textPainter.paint(
      canvas,
      Offset(
        centerX - _textPainter.width / 2,
        centerY - _textPainter.height / 2,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    final local = event.localPosition;
    final point = Offset(local.x, local.y);

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final offset = buttonSize + gap;

    if (_buttonRect(centerX, centerY - offset).contains(point)) {
      onDirectionChanged(const Point<int>(0, -1));
    } else if (_buttonRect(centerX - offset, centerY).contains(point)) {
      onDirectionChanged(const Point<int>(-1, 0));
    } else if (_buttonRect(centerX + offset, centerY).contains(point)) {
      onDirectionChanged(const Point<int>(1, 0));
    } else if (_buttonRect(centerX, centerY + offset).contains(point)) {
      onDirectionChanged(const Point<int>(0, 1));
    }
  }
}