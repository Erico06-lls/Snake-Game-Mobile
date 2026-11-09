
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameHeader extends PositionComponent {
  GameHeader({
    required Vector2 size,
    required this.score,
    required this.bestScore,
  }) : super(size: size);

  int score;
  int bestScore;

  ui.Image? _appleImage;
  ui.Image? _trophyImage;

  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  final Paint _backgroundPaint = Paint()
    ..color = const Color(0xFF292929);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final appleData = await rootBundle.load('assets/pomme.png');
    final trophyData = await rootBundle.load('assets/trophee.png');

    _appleImage = await decodeImageFromList(
      appleData.buffer.asUint8List(),
    );

    _trophyImage = await decodeImageFromList(
      trophyData.buffer.asUint8List(),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      _backgroundPaint,
    );

    _drawScore(
      canvas,
      centerX: size.x * 0.25,
      value: score,
      image: _appleImage,
    );

    _drawScore(
      canvas,
      centerX: size.x * 0.75,
      value: bestScore,
      image: _trophyImage,
    );
  }

  void _drawScore(
    Canvas canvas, {
    required double centerX,
    required int value,
    required ui.Image? image,
  }) {
    final iconSize = size.y * 0.55;
    const spacing = 10.0;

    final text = '$value';

    _textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );

    _textPainter.layout();

    final totalWidth = iconSize + spacing + _textPainter.width;
    final startX = centerX - totalWidth / 2;
    final iconRect = Rect.fromLTWH(
      startX,
      (size.y - iconSize) / 2,
      iconSize,
      iconSize,
    );

    if (image != null) {
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(
          0,
          0,
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        iconRect,
        Paint(),
      );
    }

    _textPainter.paint(
      canvas,
      Offset(
        startX + iconSize + spacing,
        (size.y - _textPainter.height) / 2,
      ),
    );
  }
}