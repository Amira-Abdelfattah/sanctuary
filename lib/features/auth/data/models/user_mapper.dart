import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/app_user.dart';

/// Converts the Firebase SDK's [fb.User] into the domain's [AppUser].
/// Isolating this mapping means a Firebase model change never leaks
/// past the `data` layer.
extension UserMapper on fb.User {
  AppUser toEntity() => AppUser(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoURL,
      );
}
