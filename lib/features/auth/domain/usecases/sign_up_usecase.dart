import '../../../../core/utils/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
