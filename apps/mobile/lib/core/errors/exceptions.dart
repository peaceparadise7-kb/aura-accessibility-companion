/// Base exception for data and platform layers.
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  const AppException(this.message, {this.code, this.cause});

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

class CameraException extends AppException {
  const CameraException(super.message, {super.code, super.cause});
}

class ARSessionException extends AppException {
  const ARSessionException(super.message, {super.code, super.cause});
}

class RecognitionException extends AppException {
  const RecognitionException(super.message, {super.code, super.cause});
}

class OCRException extends AppException {
  const OCRException(super.message, {super.code, super.cause});
}

class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.cause});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.cause});
}
