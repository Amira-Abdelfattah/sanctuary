import '../../../../core/utils/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);
  final AuthRepository _repository;

  /// [extraProfileData] holds anything beyond email/password/displayName
  /// that Firebase Auth itself doesn't store — e.g. home location.
  /// It's optional so existing call sites keep working unchanged.
  Future<Result<AppUser>> call({
    required String email,
    required String password,
    required String displayName,
    Map<String, dynamic>? extraProfileData,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
      extraProfileData: extraProfileData,
    );
  }
}
