import '../errors/failures.dart';

/// Lightweight Either-like wrapper so usecases/repositories can return
/// "success or failure" without throwing exceptions across layers and
/// without pulling in an extra package like dartz.
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = Error<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    if (self is Error<T>) return failure(self.failure);
    throw StateError('Unreachable');
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}
