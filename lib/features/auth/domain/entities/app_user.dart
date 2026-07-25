import 'package:equatable/equatable.dart';

/// Domain-level representation of the signed-in user. Deliberately does
/// NOT depend on `firebase_auth`'s `User` class — the rest of the app
/// only ever sees this plain entity, which keeps Firebase an
/// implementation detail confined to the `data` layer.
class AppUser extends Equatable {
  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];
}
