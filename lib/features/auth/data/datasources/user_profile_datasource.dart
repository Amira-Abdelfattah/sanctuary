import 'package:firebase_database/firebase_database.dart';
import '../../../../core/constants/firebase_paths.dart';

/// Writes/reads extra signup fields (home location, phone, etc.) that
/// don't belong in Firebase Auth itself. Kept as its own datasource so
/// the Auth feature doesn't need to know about Realtime Database, and
/// the Dashboard feature doesn't need to know about user profiles.
class UserProfileDatasource {
  UserProfileDatasource(this._database);
  final FirebaseDatabase _database;

  Future<void> saveProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return _database.ref(FirebasePaths.userProfile(uid)).set(data);
  }
}
