import '../entities/sensor_reading.dart';

abstract class SensorRepository {
  /// Live stream of the house's current sensor state, pushed straight
  /// from Firebase Realtime Database whenever the ESP32 uploads a
  /// reading (every ~5s in the current firmware).
  Stream<SensorReading> watchLatestReading();
}
