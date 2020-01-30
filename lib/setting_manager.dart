class SettingsManager {
  static SettingsManager instance = new SettingsManager();

  /// Main instance of Settings
  static SettingsManager getInstance() {
    return instance;
  }

  void setup() {}

  String getString(String key) {
    return "";
  }
}
