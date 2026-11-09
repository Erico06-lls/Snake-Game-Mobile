import 'dart:collection';
import 'dart:math' as math;
import 'dart:math' show Point;

import 'package:flutter/material.dart';

class Food {
  Point<int>? position;

  void setPosition(Point<int> newPosition) {
    position = newPosition;
  }

  void spawn({
    required int columns,
    required int rows,
    required Queue<Point<int>> snakeBody,
  }) {
    if (columns <= 0 || rows <= 0) return;

    final random = math.Random();

    Point<int> newPosition;

    do {
      newPosition = Point<int>(
        random.nextInt(columns),
        random.nextInt(rows),
      );
    } while (snakeBody.contains(newPosition));

    position = newPosition;
  }

  void render(
    Canvas canvas, {
    required Rect gridRect,
    required double cellSize,
  }) {
    final foodPosition = position;

    if (foodPosition == null || cellSize <= 0) return;

    final center = Offset(
      gridRect.left +
          foodPosition.x * cellSize +
          cellSize / 2,
      gridRect.top +
          foodPosition.y * cellSize +
          cellSize / 2,
    );

    final paint = Paint()
      ..color = const Color(0xFFE53935);

    canvas.drawCircle(
      center,
      cellSize * 0.38,
      paint,
    );
  }
}