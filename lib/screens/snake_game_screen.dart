
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/snake_game.dart';
import 'game_over_page.dart';

class SnakeGameScreen extends StatefulWidget {
  final int initialBestScore;

  const SnakeGameScreen({
    super.key,
    this.initialBestScore = 0,
  });

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  late final SnakeGame game;

  @override
  void initState() {
    super.initState();

    game = SnakeGame(
      bestScore: widget.initialBestScore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GameWidget<SnakeGame>(
          game: game,
          overlayBuilderMap: {
            'GameOver': (context, game) {
              return GameOverPage(
                score: game.score,
                onTryAgain: game.restart,
                onMenu: () {
                  Navigator.of(context).pop(game.bestScore);
                },
              );
            },
          },
        ),
      ),
    );
  }
}
