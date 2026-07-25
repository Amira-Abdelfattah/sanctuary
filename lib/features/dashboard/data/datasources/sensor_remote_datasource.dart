import 'package:firebase_database/firebase_database.dart';
import '../../../../core/constants/firebase_paths.dart';

/// Thin wrapper around the `firebase_database` SDK. Like
/// FirebaseAuthDatasource, this is the only class allowed to import
/// `firebase_database` directly.
class SensorRemoteDatasource {
  SensorRemoteDatasource(this._database);
  final FirebaseDatabase _database;

  /// Streams raw snapshots of the `/data` node as they arrive.
  Stream<DataSnapshot> watchDataNode() {
    return _database.ref(FirebasePaths.root).onValue.map((event) => event.snapshot);
  }
}
