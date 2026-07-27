/// Realtime Database paths.
///
/// IMPORTANT: these must stay in sync with the keys the ESP32 firmware
/// writes to (see `Firebase.setXxx(firebaseData, "/data/...")` in the
/// .ino sketch). If you rename a key on the device, rename it here too.
class FirebasePaths {
  FirebasePaths._();

  static const String root = 'data';

  static const String gasLevel = 'data/gas_level';
  static const String voltage = 'data/voltage';
  static const String current = 'data/current';

  static const String alarm = 'data/alarm';
  static const String gasAlert = 'data/gas_alert';
  static const String voltageAlert = 'data/voltage_alert';
  static const String currentAlert = 'data/current_alert';

  /// Written by the Python anomaly-detection service (Isolation Forest),
  /// NOT by the ESP32 firmware. `true` means the AI model flagged the
  /// current reading as statistically unusual, even if it didn't cross
  /// a hard threshold.
  static const String aiAnomaly = 'data/ai_anomaly';
  static const String aiAnomalyScore = 'data/ai_anomaly_score';

  static const String relayActive = 'data/relay_active';
  static const String ledStatus = 'data/led_status';
  static const String status = 'data/status';

  /// Per-user alert history, kept separate from the live sensor node so
  /// the device firmware never has to know about individual accounts.
  static String userAlertsHistory(String uid) => 'users/$uid/alerts_history';

  /// Per-user profile info (display name, home name, phone, etc.)
  static String userProfile(String uid) => 'users/$uid/profile';
}
