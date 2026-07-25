import 'package:equatable/equatable.dart';
import '../../../../core/widgets/status_pill.dart';

/// Snapshot of everything the ESP32 publishes to
/// `/data` in Firebase Realtime Database. One instance of this entity
/// represents "the current state of the house" at a point in time.
class SensorReading extends Equatable {
  const SensorReading({
    required this.gasLevel,
    required this.voltage,
    required this.current,
    required this.alarm,
    required this.gasAlert,
    required this.voltageAlert,
    required this.currentAlert,
    required this.relayActive,
    required this.statusMessage,
  });

  final int gasLevel;
  final double voltage;
  final double current;

  final bool alarm;
  final bool gasAlert;
  final bool voltageAlert;
  final bool currentAlert;

  /// true = relay is closed (power flowing normally),
  /// false = relay tripped open (power cut as a safety measure).
  final bool relayActive;

  final String statusMessage;

  factory SensorReading.empty() => const SensorReading(
        gasLevel: 0,
        voltage: 0,
        current: 0,
        alarm: false,
        gasAlert: false,
        voltageAlert: false,
        currentAlert: false,
        relayActive: true,
        statusMessage: 'Waiting for device...',
      );

  SensorStatusLevel get gasStatus {
    if (gasAlert) return SensorStatusLevel.danger;
    if (gasLevel > 1500) return SensorStatusLevel.warning;
    return SensorStatusLevel.safe;
  }

  SensorStatusLevel get powerStatus {
    if (voltageAlert || currentAlert) return SensorStatusLevel.danger;
    return SensorStatusLevel.safe;
  }

  SensorStatusLevel get overallStatus {
    if (alarm) return SensorStatusLevel.danger;
    return SensorStatusLevel.safe;
  }

  bool get isHomeSafe => !alarm;

  @override
  List<Object?> get props => [
        gasLevel,
        voltage,
        current,
        alarm,
        gasAlert,
        voltageAlert,
        currentAlert,
        relayActive,
        statusMessage,
      ];
}
