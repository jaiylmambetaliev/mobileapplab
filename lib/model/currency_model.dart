import 'package:shared_preferences/shared_preferences.dart';


class Preferences {
  static Future<void> saveLastAmount(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lastAmount', amount);
  }

  static Future<double?> getLastAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('lastAmount');
  }
}