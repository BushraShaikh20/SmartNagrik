import 'package:flutter/material.dart';
import '../utils/snackbar_utils.dart';
import 'app_exception.dart';

class ErrorHandler {
  static void handle(BuildContext context, dynamic error) {
    if (error is AppException) {
      SnackbarUtils.showError(context, error.message);
    } else {
      SnackbarUtils.showError(context, error?.toString() ?? 'An unexpected error occurred.');
    }
  }
}
