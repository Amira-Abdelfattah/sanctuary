import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/user_profile_datasource.dart';
import '../models/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource, [this._profileDatasource]);
  final FirebaseAuthDatasource _datasource;
  final UserProfileDatasource? _profileDatasource;

  @override
  Stream<AppUser?> get authStateChanges =>
      _datasource.authStateChanges().map((user) => user?.toEntity());

  @override
  AppUser? get currentUser => _datasource.currentUser?.toEntity();

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _datasource.signIn(email: email, password: password);
      final user = credential.user;
      if (user == null) {
        return const Result.failure(AuthFailure('Sign in failed. Please try again.'));
      }
      return Result.success(user.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(AuthFailure(_mapAuthError(e)));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
    required String displayName,
    Map<String, dynamic>? extraProfileData,
  }) async {
    try {
      final credential = await _datasource.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      final user = credential.user;
      if (user == null) {
        return const Result.failure(AuthFailure('Sign up failed. Please try again.'));
      }

      // Save anything Firebase Auth itself doesn't store (e.g. home
      // location) to Realtime Database under users/{uid}/profile.
      if (_profileDatasource != null) {
        await _profileDatasource!.saveProfile(
          uid: user.uid,
          data: {
            'displayName': displayName,
            'email': email,
            'createdAt': DateTime.now().toIso8601String(),
            ...?extraProfileData,
          },
        );
      }

      return Result.success(user.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(AuthFailure(_mapAuthError(e)));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _datasource.signOut();
      return const Result.success(null);
    } catch (_) {
      return const Result.failure(UnknownFailure('Failed to sign out.'));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _datasource.sendPasswordResetEmail(email);
      return const Result.success(null);
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(AuthFailure(_mapAuthError(e)));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }

  /// Translates Firebase's error codes into user-friendly messages
  /// (bilingual-friendly: short, plain English works for both AR/EN users).
  String _mapAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Please choose a stronger password (6+ characters).';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
