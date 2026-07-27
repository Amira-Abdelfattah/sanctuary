import '../../../../core/utils/result.dart';
import '../entities/app_user.dart';

/// Contract the `data` layer must fulfil. The `presentation` layer (and
/// usecases) depend only on this abstraction, never on a concrete
/// Firebase implementation — this is what makes it possible to swap
/// auth providers later without touching UI code.
abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  AppUser? get currentUser;

  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
    required String displayName,
    Map<String, dynamic>? extraProfileData,
  });

  Future<Result<void>> signOut();

  Future<Result<void>> sendPasswordResetEmail(String email);
}
