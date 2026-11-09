
import 'dart:collection';
import 'dart:math' show Point;

import 'package:flutter/material.dart';

class Snake {
  final Queue<Point<int>> body = Queue<Point<int>>();

  int get length => body.length;
  Point<int> direction = const Point<int>(1, 0);

  bool move({required int columns, required int rows, bool grow = false,}) {
    if (body.isEmpty) return false;

    final head = body.first;

    final nextHead = Point<int>(
      head.x + direction.x,
      head.y + direction.y,
    );

    if (nextHead.x < 0 ||
        nextHead.x >= columns ||
        nextHead.y < 0 ||
        nextHead.y >= rows) {
      return false;
    }

    body.addFirst(nextHead);

    if (!grow) {
      body.removeLast();
    }

    return true;
  }

  bool changeDirection(Point<int> newDirection) {
    final isValid = newDirection.x.abs() + newDirection.y.abs() == 1;
    if (!isValid) return false;

    if (newDirection.x == -direction.x &&
        newDirection.y == -direction.y) {
      return false;
    }

    direction = newDirection;
    return true;
  }

  void reset(int columns, int rows) {
    body.clear();

    if (columns < 3 || rows < 1) return;

    final headX = columns ~/ 2;
    final headY = rows ~/ 2;

    body.addFirst(Point<int>(headX, headY));
    body.addLast(Point<int>(headX - 1, headY));
    body.addLast(Point<int>(headX - 2, headY));
  }

  void render(
    Canvas canvas, {
    required Rect gridRect,
    required double cellSize,
  }) {
    if (body.isEmpty || cellSize <= 0) return;

    final bodyPaint = Paint()
      ..color = const Color(0xFF419B50);

    final headPaint = Paint()
      ..color = const Color(0xFF8BD96B);

    for (var i = 0; i < body.length; i++) {
      final segment = body.elementAt(i);

      final cellRect = Rect.fromLTWH(
        gridRect.left + segment.x * cellSize,
        gridRect.top + segment.y * cellSize,
        cellSize,
        cellSize,
      );

      final rect = i == 0
          ? cellRect
          : cellRect.deflate(cellSize * 0.06);

      canvas.drawRect(
        rect,
        i == 0 ? headPaint : bodyPaint,
      );
    }
  }
}