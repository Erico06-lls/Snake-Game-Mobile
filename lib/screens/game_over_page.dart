import 'package:flutter/material.dart';

class GameOverPage extends StatelessWidget {
  final int score;
  final VoidCallback onTryAgain;
  final VoidCallback onMenu;

  const GameOverPage({
    super.key,
    required this.score,
    required this.onTryAgain,
    required this.onMenu,
  });

  static const Color backgroundColor = Color(0xFF8BA34F);
  static const Color buttonColor = Color(0xFF26321A);
  static const Color textColor = Color(0xFF243016);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game\nOver!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: textColor,
                  fontSize: 28,
                  height: 1.8,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Your score: $score',
                style: const TextStyle(
                  fontFamily: 'PressStart2P',
                  color: textColor,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 22),

              _buildButton(
                label: 'Try Again',
                onPressed: onTryAgain,
              ),

              const SizedBox(height: 12),

              _buildButton(
                label: 'Menu',
                onPressed: onMenu,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 120,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}