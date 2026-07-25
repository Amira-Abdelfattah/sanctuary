import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Thin wrapper around the `firebase_auth` SDK. This is the ONLY class
/// in the whole app allowed to import `firebase_auth` directly — every
/// other layer talks to [AuthRepository] instead.
class FirebaseAuthDatasource {
  FirebaseAuthDatasource(this._auth);
  final fb.FirebaseAuth _auth;

  Stream<fb.User?> authStateChanges() => _auth.authStateChanges();

  fb.User? get currentUser => _auth.currentUser;

  Future<fb.UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<fb.UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    return credential;
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
