
class AppException implements Exception {
  final String? message;

  AppException([this.message]);

  @override
  String toString() {
    return message ?? 'An unknown error occurred';
  }
}

class FetchDataException extends AppException {
  FetchDataException([super.message]);
}

class BadRequestException extends AppException {
  BadRequestException([super.message]);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([super.message]);
}

class InvalidInputException extends AppException {
  InvalidInputException([super.message]);
}