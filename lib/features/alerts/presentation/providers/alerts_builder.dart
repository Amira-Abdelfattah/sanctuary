import 'package:flutter/material.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../dashboard/domain/entities/sensor_reading.dart';
import '../../domain/entities/alert_item.dart';

/// Derives a human-readable alert list from the current [SensorReading].
/// This intentionally does NOT persist a history — the ESP32 firmware
/// only ever publishes "the current state of the house", so the alerts
/// screen reflects that same live snapshot rather than pretending to
/// have a database-backed timeline it doesn't have.
class AlertsBuilder {
  AlertsBuilder._();

  static List<AlertItem> build(SensorReading reading) {
    final items = <AlertItem>[];

    if (reading.gasAlert) {
      items.add(AlertItem(
        title: 'Gas leak detected',
        message: 'Gas level reading: ${reading.gasLevel}. The relay has cut power as a precaution.',
        actionHint: 'Open windows & exit immediately',
        level: SensorStatusLevel.danger,
        icon: Icons.local_fire_department_rounded,
        isCritical: true,
      ));
    }

    if (reading.voltageAlert) {
      items.add(AlertItem(
        title: 'Unusual voltage',
        message: 'Voltage reading: ${reading.voltage.toStringAsFixed(1)}V is outside the safe range.',
        actionHint: 'Check your electrical panel',
        level: SensorStatusLevel.warning,
        icon: Icons.bolt_rounded,
      ));
    }

    if (reading.currentAlert) {
      items.add(AlertItem(
        title: 'Overcurrent detected',
        message: 'Current reading: ${reading.current.toStringAsFixed(2)}A exceeds the safe threshold.',
        actionHint: 'Unplug high-draw appliances',
        level: SensorStatusLevel.warning,
        icon: Icons.electric_meter_rounded,
      ));
    }

    if (!reading.relayActive) {
      items.add(AlertItem(
        title: 'Power cut by relay',
        message: 'The safety relay has disconnected the main power supply.',
        actionHint: 'Resolve the alert above, power restores automatically',
        level: SensorStatusLevel.danger,
        icon: Icons.power_off_rounded,
        isCritical: true,
      ));
    }

    if (items.isEmpty) {
      items.add(AlertItem(
        title: 'All sensors normal',
        message: 'Gas, voltage and current are all within safe operating ranges.',
        actionHint: 'No action needed',
        level: SensorStatusLevel.safe,
        icon: Icons.check_circle_rounded,
      ));
    }

    return items;
  }
}
