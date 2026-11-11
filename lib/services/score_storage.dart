import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const String _highScoreKey = 'snake_high_score';
  static Future<int> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_highScoreKey) ?? 0;
  }
  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();

    final currentHighScore = prefs.getInt(_highScoreKey) ?? 0;

    if (score > currentHighScore) {
      await prefs.setInt(_highScoreKey, score);
    }
  }
}
