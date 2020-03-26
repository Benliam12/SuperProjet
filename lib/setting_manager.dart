import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static SettingsManager instance = new SettingsManager();

  /// Main instance of Settings
  static SettingsManager getInstance() {
    return instance;
  }

  void setup() {}

  String getString(String key) {
    String value = "";
    switch (key) {
      case "enter_message":
        value = "Votre message";
        break;
      default:
        break;
    }

    return value;
  }

  //Testing to write some preferences
  void testWrite() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lang", "us-en");
  }

  //Testing to read some preferences
  void testRead() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString("lang");
    print(t);
  }
}
