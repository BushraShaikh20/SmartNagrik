import 'app_exception.dart';

class FirebaseExceptionHandler {
  static String messageFor(dynamic error) {
    return handle(error).message;
  }

  static AppException handle(dynamic error) {
    String code = '';
    String raw = error.toString();
    try {
      code = (error as dynamic).code?.toString() ?? '';
    } catch (_) {}

    final haystack = '$code $raw'.toLowerCase();

    if (haystack.contains('user-not-found') ||
        haystack.contains('invalid-credential') ||
        haystack.contains('invalid-login-credentials') ||
        haystack.contains('wrong-password')) {
      return const AppException(
        'Incorrect email or password. Please try again.',
        code: 'invalid-credential',
      );
    }
    if (haystack.contains('email-already-in-use')) {
      return const AppException(
        'This email is already registered. Please log in.',
        code: 'email-already-in-use',
      );
    }
    if (haystack.contains('invalid-email')) {
      return const AppException(
        'Please enter a valid email address.',
        code: 'invalid-email',
      );
    }
    if (haystack.contains('weak-password')) {
      return const AppException(
        'Password is too weak. Use at least 6 characters.',
        code: 'weak-password',
      );
    }
    if (haystack.contains('too-many-requests')) {
      return const AppException(
        'Too many attempts. Please wait and try again.',
        code: 'too-many-requests',
      );
    }
    if (haystack.contains('network-request-failed')) {
      return const AppException(
        'Network error. Please check your internet connection.',
        code: 'network',
      );
    }
    if (haystack.contains('invalid-verification-code') ||
        haystack.contains('invalid-verification-id') ||
        haystack.contains('session-expired')) {
      return const AppException(
        'Invalid or expired OTP. Please request a new code.',
        code: 'invalid-otp',
      );
    }
    if (haystack.contains('invalid-phone-number')) {
      return const AppException(
        'Please enter a valid mobile number.',
        code: 'invalid-phone-number',
      );
    }
    if (haystack.contains('account-exists-with-different-credential')) {
      return const AppException(
        'An account already exists with a different sign-in method.',
        code: 'account-exists',
      );
    }
    if (haystack.contains('canceled') || haystack.contains('cancelled')) {
      return const AppException(
        'Sign-in was cancelled.',
        code: 'cancelled',
      );
    }
    if (haystack.contains('operation-not-allowed')) {
      return const AppException(
        'This sign-in method is not enabled in Firebase.',
        code: 'operation-not-allowed',
      );
    }
    return AppException(
      'Authentication failed. Please check your details and try again.',
      code: code.isEmpty ? 'auth' : code,
    );
  }
}
