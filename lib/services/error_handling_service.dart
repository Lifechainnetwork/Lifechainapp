import 'dart:async';
import 'package:flutter/material.dart';

enum ErrorSeverity {
  low,    // Non-critical errors that don't affect functionality
  medium, // Errors that affect some functionality but app can continue
  high,   // Critical errors that require user action
  fatal   // Errors that require app restart
}

class ErrorHandlingService extends ChangeNotifier {
  final List<AppError> _errorLog = [];
  AppError? _currentError;
  
  List<AppError> get errorLog => _errorLog;
  AppError? get currentError => _currentError;
  
  // Log an error
  void logError(
    String message, {
    required ErrorSeverity severity,
    dynamic exception,
    StackTrace? stackTrace,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) {
    final error = AppError(
      message: message,
      severity: severity,
      timestamp: DateTime.now(),
      exception: exception,
      stackTrace: stackTrace,
      screenName: screenName,
      additionalData: additionalData,
    );
    
    _errorLog.add(error);
    
    // If the error is high or fatal, set it as current error
    if (severity == ErrorSeverity.high || severity == ErrorSeverity.fatal) {
      _currentError = error;
      notifyListeners();
    }
    
    // In a real app, you would also send this to a backend logging service
    debugPrint('ERROR [${severity.name.toUpperCase()}]: $message');
    if (exception != null) {
      debugPrint('Exception: $exception');
    }
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }
  
  // Clear the current error
  void clearCurrentError() {
    _currentError = null;
    notifyListeners();
  }
  
  // Clear all errors
  void clearAllErrors() {
    _errorLog.clear();
    _currentError = null;
    notifyListeners();
  }
  
  // Get errors for a specific screen
  List<AppError> getErrorsForScreen(String screenName) {
    return _errorLog.where((error) => error.screenName == screenName).toList();
  }
  
  // Show error dialog
  Future<void> showErrorDialog(BuildContext context, AppError error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: error.severity != ErrorSeverity.fatal,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getErrorTitle(error.severity)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error.message),
                if (error.exception != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Technical details: ${error.exception}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            if (error.severity != ErrorSeverity.fatal)
              TextButton(
                child: const Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearCurrentError();
                },
              ),
            if (error.severity == ErrorSeverity.fatal)
              TextButton(
                child: const Text('Restart App'),
                onPressed: () {
                  // In a real app, you would implement app restart logic here
                  Navigator.of(context).pop();
                  clearCurrentError();
                },
              ),
          ],
        );
      },
    );
  }
  
  // Get error title based on severity
  String _getErrorTitle(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return 'Notice';
      case ErrorSeverity.medium:
        return 'Warning';
      case ErrorSeverity.high:
        return 'Error';
      case ErrorSeverity.fatal:
        return 'Critical Error';
    }
  }
  
  // Global error handler for uncaught exceptions
  void setupGlobalErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      logError(
        details.exception.toString(),
        severity: ErrorSeverity.high,
        exception: details.exception,
        stackTrace: details.stack,
      );
    };
    
    // Handle async errors
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      logError(
        error.toString(),
        severity: ErrorSeverity.high,
        exception: error,
        stackTrace: stack,
      );
      return true;
    };
  }
}

class AppError {
  final String message;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final dynamic exception;
  final StackTrace? stackTrace;
  final String? screenName;
  final Map<String, dynamic>? additionalData;
  
  AppError({
    required this.message,
    required this.severity,
    required this.timestamp,
    this.exception,
    this.stackTrace,
    this.screenName,
    this.additionalData,
  });
}
