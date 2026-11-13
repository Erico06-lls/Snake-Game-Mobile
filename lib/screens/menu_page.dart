
import 'package:flutter/material.dart';

import 'snake_game_screen.dart';
import '../services/score_storage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int highScore = 0;

  Future<void> _playGame() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => SnakeGameScreen(
          initialBestScore: highScore,
        ),
      ),
    );

    if (result != null) {
      await ScoreStorage.saveHighScore(result);

      if(!mounted) return;

      setState(() {
        highScore = result > highScore ? result : highScore;
      });
    }
  }

  void _showDifficultyMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Le choix de difficulté sera disponible bientôt.'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final savedScore = await ScoreStorage.loadHighScore();
    if (!mounted) return;
    setState(() {
      highScore = savedScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF8BA34F);
    const darkColor = Color(0xFF26321A);
    const textColor = Color(0xFF243016);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SNAKE\nGAME',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 25,
                    height: 1.8,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 45),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/trophee.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'HIGH SCORE: $highScore',
                        style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 10,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 55),

                _buildButton(
                  label: 'PLAY',
                  color: darkColor,
                  onPressed: _playGame,
                ),

                const SizedBox(height: 18),

                _buildButton(
                  label: 'DIFFICULTY',
                  color: darkColor,
                  onPressed: _showDifficultyMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 190,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
