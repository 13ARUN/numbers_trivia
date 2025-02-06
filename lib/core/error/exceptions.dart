abstract class AppException implements Exception {
  final String message;

  const AppException([this.message = "An Exception occurred"]);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = "Server exception"]);
}

class CacheException extends AppException {
  const CacheException([super.message = "Cache exception"]);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = "Request Timeout"]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = "Unauthorized"]);
}

class FormatException extends AppException {
  const FormatException([super.message = "Invalid Format"]);
}
