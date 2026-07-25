import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/repositories/sensor_repository.dart';

/// Holds the latest [SensorReading] and keeps it fresh by subscribing
/// to the repository's live stream. Pages just call `context.watch`
/// and rebuild automatically — no manual StreamBuilder wiring needed
/// in every screen that cares about sensor data.
class SensorProvider extends ChangeNotifier {
  SensorProvider({required SensorRepository repository}) : _repository = repository {
    _subscription = _repository.watchLatestReading().listen(_onReading);
  }

  final SensorRepository _repository;
  late final StreamSubscription<SensorReading> _subscription;

  static const int _maxHistoryPoints = 30;

  SensorReading reading = SensorReading.empty();
  bool hasReceivedData = false;

  /// Rolling buffer of instantaneous power (watts) readings collected
  /// during THIS session, most recent last. Used by the Usage tab for
  /// a live trend chart — it is real device data, just short-lived
  /// (the firmware/DB does not keep historical time-series today).
  final List<double> powerHistory = [];

  void _onReading(SensorReading newReading) {
    reading = newReading;
    hasReceivedData = true;

    final watts = newReading.voltage * newReading.current;
    powerHistory.add(watts);
    if (powerHistory.length > _maxHistoryPoints) {
      powerHistory.removeAt(0);
    }

    notifyListeners();
  }

  double get instantaneousPowerWatts => reading.voltage * reading.current;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
