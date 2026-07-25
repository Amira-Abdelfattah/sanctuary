import 'package:flutter/material.dart';
import '../../../../core/widgets/status_pill.dart';

/// A single alert derived from the live sensor state. These are
/// computed on the fly from `SensorReading` (see `AlertsProvider`)
/// rather than fetched from a separate "alerts" table, since the
/// ESP32 firmware only publishes the current state, not a history log.
class AlertItem {
  const AlertItem({
    required this.title,
    required this.message,
    required this.actionHint,
    required this.level,
    required this.icon,
    this.isCritical = false,
  });

  final String title;
  final String message;
  final String actionHint;
  final SensorStatusLevel level;
  final IconData icon;
  final bool isCritical;
}
