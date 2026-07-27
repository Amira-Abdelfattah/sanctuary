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
    this.aiAnomaly = false,
    this.aiAnomalyScore = 0.0,
    this.hasAiData = false,
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

  /// Written by the separate Python anomaly-detection service (Isolation
  /// Forest), NOT by the ESP32 firmware. `true` means the AI model judged
  /// the current reading pattern statistically unusual compared to this
  /// home's historical behavior — even if no hard threshold was crossed.
  final bool aiAnomaly;

  /// Isolation Forest decision score. More negative = more anomalous.
  /// Stored as-is from the model; the UI converts it to a rough
  /// "confidence" percentage for display only.
  final double aiAnomalyScore;

  /// Whether the AI fields above have ever been written by the Python
  /// service yet. Lets the UI distinguish "AI says normal" from
  /// "AI service hasn't run yet" instead of defaulting both to false.
  final bool hasAiData;

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

  /// Rough 0-100 "confidence this is unusual" for display. Isolation
  /// Forest scores are unbounded and centered around 0, so this is a
  /// presentation-only heuristic, not a calibrated probability.
  int get aiConfidencePercent => (aiAnomalyScore.abs() * 100).clamp(0, 100).round();

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
        aiAnomaly,
        aiAnomalyScore,
        hasAiData,
      ];
}
