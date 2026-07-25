import '../../domain/entities/sensor_reading.dart';

/// Parses the raw `Map` that comes back from a Firebase Realtime
/// Database snapshot at `/data` into the domain's [SensorReading].
///
/// Kept deliberately defensive: sensor values arrive as `int`, `double`
/// or occasionally `String` depending on how the firmware wrote them,
/// so every field is parsed leniently instead of trusting a fixed type.
class SensorReadingModel {
  static SensorReading fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return SensorReading.empty();

    return SensorReading(
      gasLevel: _asInt(map['gas_level']),
      voltage: _asDouble(map['voltage']),
      current: _asDouble(map['current']),
      alarm: _asBool(map['alarm']),
      gasAlert: _asBool(map['gas_alert']),
      voltageAlert: _asBool(map['voltage_alert']),
      currentAlert: _asBool(map['current_alert']),
      relayActive: map.containsKey('relay_active') ? _asBool(map['relay_active']) : true,
      statusMessage: (map['status'] as String?) ?? 'System normal',
    );
  }

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _asDouble(dynamic v) {
    if (v == null) return 0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static bool _asBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }
}
