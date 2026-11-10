
import 'dart:math' as math;

import 'snake.dart';
import 'food.dart';
import '../components/game_controls.dart';
import '../components/game_header.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SnakeGame extends FlameGame {
  double headerHeight = 50;
  double controlsHeight = 140;

  Rect headerRect = Rect.zero;
  Rect arenaRect = Rect.zero;
  Rect controlsRect = Rect.zero;

  Rect frameRect = Rect.zero;
  Rect gridRect = Rect.zero;

  int columns = 0;
  int rows = 0;
  double cellSize = 0;

  final Snake snake = Snake();
  final Food food = Food();
  GameControls? gameControls;
  GameHeader? gameHeader;

  int score = 0;
  int bestScore = 0;

  int _lastColumns = 0;
  int _lastRows = 0;

  static const double targetCellSize = 22;
  static const double borderWidth = 3;
  static const double horizontalMargin = 12;
  static const double verticalMargin = 8;

  double _moveTimer = 0;
  bool _gameOver = false;

  static const double moveInterval = 0.18;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final controls = GameControls(
      size: Vector2(
        controlsRect.width,
        controlsRect.height,
      ),
      onDirectionChanged: (direction) {
        if (_gameOver) return;
        snake.changeDirection(direction);
      },
    );
    controls.position = Vector2(
      controlsRect.left,
      controlsRect.top,
    );
    gameControls = controls;
    add(controls);

    final header = GameHeader(
      size: Vector2(
        headerRect.width,
        headerRect.height,
      ),
      score: score,
      bestScore: bestScore,
    );
    header.position = Vector2(
      headerRect.left,
      headerRect.top,
    );
    gameHeader = header;
    add(header);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameOver || columns <= 0 || rows <= 0) return;

    _moveTimer += dt;

    if (_moveTimer >= moveInterval) {
      _moveTimer -= moveInterval;

      final head = snake.body.first;
      final nextHead = math.Point<int>(
        head.x + snake.direction.x,
        head.y + snake.direction.y,
      );
      final willGrow = food.position == nextHead;
      final moved = snake.move(
        columns: columns,
        rows: rows,
        grow: willGrow,
      );

      if (!moved) {
        _gameOver = true;
        overlays.add('GameOver');
        return;
      }
      if (willGrow) {
        score ++;
        if (score > bestScore) {
          bestScore = score;
        }
        final header = gameHeader;
        if (header != null) {
          header.score = score;
          header.bestScore = bestScore;
        }
        food.spawn(
          columns: columns,
          rows: rows,
          snakeBody: snake.body,
        );
      }
    }
  }

  void restart() {
    if (columns <= 0 || rows <= 0) return;
    score = 0;
    snake.reset(columns, rows);

    food.spawn(
      columns: columns,
      rows: rows,
      snakeBody: snake.body,
    );

    _moveTimer = 0;
    _gameOver = false;

    final header = gameHeader;
    if (header != null) {
      header.score = score;
      header.bestScore = bestScore;
    }

    overlays.remove('GameOver');
  }

  @override
  Color backgroundColor() => Colors.black;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (size.x <= 0 || size.y <= 0) return;

    headerHeight = (size.y * 0.08).clamp(45.0, 65.0);
    controlsHeight =(size.y * 0.25).clamp(170.0, 210.0);

    if (headerHeight + controlsHeight + 100 >size.y) {
      headerHeight = size.y * 0.10;
      controlsHeight = size.y * 0.28;
    }

    headerRect = Rect.fromLTWH(0, 0, size.x, headerHeight,);
    final header = gameHeader;
    if (header != null) {
      header.size = Vector2(
        headerRect.width,
        headerRect.height,
      );
      header.position = Vector2(
        headerRect.left,
        headerRect.top,
      );
    }

    controlsRect = Rect.fromLTWH(0, size.y - controlsHeight, size.x, controlsHeight,);
    final controls = gameControls;
    if (controls != null) {
      controls.size = Vector2(
        controlsRect.width,
        controlsRect.height,
      );
      controls.position = Vector2(
        controlsRect.left,
        controlsRect.top,
      );
    }

    arenaRect = Rect.fromLTRB(0, headerHeight, size.x, size.y - controlsHeight,);

    final availableWidth = math.max(0.0, size.x - 2 * horizontalMargin - 2 * borderWidth);

    if (availableWidth < targetCellSize) return;

    columns = math.max(1, (availableWidth / targetCellSize).floor(),);
    cellSize = availableWidth / columns;

    final availableHeight = math.max(0.0, arenaRect.height - 2 * verticalMargin - 2 * borderWidth,);

    rows = math.max(1, (availableHeight / cellSize).floor(),);

    final gridWidth = columns * cellSize;
    final gridHeight = rows * cellSize;

    final frameWidth = gridWidth + 2 * borderWidth;
    final frameHeight = gridHeight + 2 * borderWidth;

    final frameLeft = (size.x - frameWidth) / 2;

    final frameTop = arenaRect.top + (arenaRect.height - frameHeight) / 2;

    frameRect = Rect.fromLTWH(
      frameLeft,
      frameTop,
      frameWidth,
      frameHeight,
    );

    gridRect = Rect.fromLTWH(
      frameRect.left + borderWidth,
      frameRect.top + borderWidth,
      gridWidth,
      gridHeight,
    );

    if (columns != _lastColumns || rows != _lastRows) {
      snake.reset(columns, rows);

      food.spawn(
        columns: columns,
        rows: rows,
        snakeBody: snake.body,
      );

      _lastColumns = columns;
      _lastRows = rows;

      _moveTimer = 0;
      _gameOver = false;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      headerRect,
      Paint()..color = const Color(0xFF292929),
    );

    canvas.drawRect(
      arenaRect,
      Paint()..color = const Color(0xFF14251A),
    );

    canvas.drawRect(
      controlsRect,
      Paint()..color = const Color(0xFF292929),
    );

    if (columns > 0 && rows > 0 && cellSize > 0) {
      canvas.drawRect(
        gridRect,
        Paint()..color = const Color(0xFF1B2C20),
      );

      final gridPaint = Paint()
        ..color = const Color(0xFF304336)
        ..strokeWidth = 0.5;

      for (int col = 0; col <= columns; col++) {
        final x = gridRect.left + col * cellSize;

        canvas.drawLine(
          Offset(x, gridRect.top),
          Offset(x, gridRect.bottom),
          gridPaint,
        );
      }

      for (int row = 0; row <= rows; row++) {
        final y = gridRect.top + row * cellSize;

        canvas.drawLine(
          Offset(gridRect.left, y),
          Offset(gridRect.right, y),
          gridPaint,
        );
      }

      food.render(
        canvas,
        gridRect: gridRect,
        cellSize: cellSize,
      );

      snake.render(
        canvas,
        gridRect: gridRect,
        cellSize: cellSize,
      );

      canvas.drawRect(
        frameRect.deflate(borderWidth / 2),
        Paint()
          ..color = const Color(0xFF71C66A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }

    super.render(canvas);
  }

}
