import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Single source of truth for authentication state, exposed to the
/// widget tree via `provider`. Pages call [signIn]/[signUp]/[signOut]
/// and read [status]/[errorMessage]/[isLoading] to render themselves —
/// no page talks to Firebase or a repository directly.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthRepository repository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _repository = repository,
        _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase {
    _subscription = _repository.authStateChanges.listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  late final StreamSubscription<AppUser?> _subscription;

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  bool isLoading = false;
  String? errorMessage;

  void _onAuthChanged(AppUser? newUser) {
    user = newUser;
    status = newUser != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    final result = await _signInUseCase(email: email, password: password);
    return result.when(
      success: (u) {
        user = u;
        errorMessage = null;
        _setLoading(false);
        return true;
      },
      failure: (f) {
        errorMessage = f.message;
        _setLoading(false);
        return false;
      },
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    Map<String, dynamic>? extraProfileData,
  }) async {
    _setLoading(true);
    final result = await _signUpUseCase(
      email: email,
      password: password,
      displayName: displayName,
      extraProfileData: extraProfileData,
    );
    return result.when(
      success: (u) {
        user = u;
        errorMessage = null;
        _setLoading(false);
        return true;
      },
      failure: (f) {
        errorMessage = f.message;
        _setLoading(false);
        return false;
      },
    );
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _signOutUseCase();
    _setLoading(false);
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
