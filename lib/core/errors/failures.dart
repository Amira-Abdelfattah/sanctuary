/// Base class for all domain-level failures. Using typed failures instead
/// of throwing raw exceptions across layers keeps the UI layer free of
/// try/catch blocks tied to a specific package (e.g. FirebaseAuthException).
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
