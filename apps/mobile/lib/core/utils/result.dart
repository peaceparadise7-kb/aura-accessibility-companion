import 'package:equatable/equatable.dart';
import 'package:aura_mobile/core/errors/failures.dart';

/// A value that represents either a success with data of type [T],
/// or a failure with an error of type [Failure].
sealed class Result<T> extends Equatable {
  const Result();

  /// Creates a successful [Result] holding [data].
  const factory Result.ok(T data) = Ok<T>;

  /// Creates a failed [Result] holding [failure].
  const factory Result.err(Failure failure) = Err<T>;

  /// Returns `true` if this is an [Ok] instance.
  bool get isOk => this is Ok<T>;

  /// Returns `true` if this is an [Err] instance.
  bool get isErr => this is Err<T>;

  /// Extracts the success value if present, otherwise returns `null`.
  T? get valueOrNull => switch (this) {
        Ok<T>(data: final d) => d,
        Err<T>() => null,
      };

  /// Extracts the failure if present, otherwise returns `null`.
  Failure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(failure: final f) => f,
      };

  /// Applies [onOk] if this is a success, or [onErr] if this is a failure.
  R fold<R>(
    R Function(T data) onOk,
    R Function(Failure failure) onErr,
  ) {
    return switch (this) {
      Ok<T>(data: final d) => onOk(d),
      Err<T>(failure: final f) => onErr(f),
    };
  }

  /// Transforms the value of an [Ok] instance using [transform].
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Ok<T>(data: final d) => Result.ok(transform(d)),
      Err<T>(failure: final f) => Result.err(f),
    };
  }
}

/// Successful variant of [Result].
final class Ok<T> extends Result<T> {
  final T data;

  const Ok(this.data);

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Result.ok($data)';
}

/// Failure variant of [Result].
final class Err<T> extends Result<T> {
  final Failure failure;

  const Err(this.failure);

  @override
  List<Object?> get props => [failure];

  @override
  String toString() => 'Result.err($failure)';
}
