
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/snake_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SnakeGameScreen(),
        ),
      ),
    ),
  );
}

class SnakeGameScreen extends StatelessWidget {
  const SnakeGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SnakeGame(),
    );
  }
}
