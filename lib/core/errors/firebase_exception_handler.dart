import 'app_exception.dart';

class FirebaseExceptionHandler {
  static AppException handle(dynamic error) {
    final message = error.toString();
    if (message.contains('user-not-found')) {
      return const AppException('No user found with these credentials.', code: 'user-not-found');
    } else if (message.contains('wrong-password')) {
      return const AppException('Incorrect password provided.', code: 'wrong-password');
    } else if (message.contains('email-already-in-use')) {
      return const AppException('Email is already registered.', code: 'email-already-in-use');
    } else if (message.contains('network-request-failed')) {
      return const AppException('Network error. Please check your internet connection.', code: 'network');
    }
    return AppException(message);
  }
}
