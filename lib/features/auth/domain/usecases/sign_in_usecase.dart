import '../../../../core/utils/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the "sign in with email/password" business action.
/// Keeping one class per usecase makes each action independently
/// testable and gives every business rule a single, obvious home.
class SignInUseCase {
  const SignInUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
