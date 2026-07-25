import '../../domain/entities/sensor_reading.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/sensor_remote_datasource.dart';
import '../models/sensor_reading_model.dart';

class SensorRepositoryImpl implements SensorRepository {
  SensorRepositoryImpl(this._datasource);
  final SensorRemoteDatasource _datasource;

  @override
  Stream<SensorReading> watchLatestReading() {
    return _datasource.watchDataNode().map((snapshot) {
      final value = snapshot.value;
      if (value is Map) {
        return SensorReadingModel.fromMap(value);
      }
      return SensorReading.empty();
    });
  }
}
