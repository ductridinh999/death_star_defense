import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static const String _key = 'highest_unlocked_level';

  static Future<int> getHighestUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 1;
  }

  static Future<void> saveHighestUnlockedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key) ?? 1;
    if (level > current) {
      await prefs.setInt(_key, level);
    }
  }
}
