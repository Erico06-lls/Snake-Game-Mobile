
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/snake_game.dart';
import 'screens/game_over_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SnakeApp());
}

class SnakeApp extends StatelessWidget {
  const SnakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGameScreen(),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  late final SnakeGame game;

  @override
  void initState() {
    super.initState();
    game = SnakeGame();
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Le menu sera bientôt disponible.'),
                    ),
                  );
                },
              );
            },
          },
        ),
      ),
    );
  }
}
