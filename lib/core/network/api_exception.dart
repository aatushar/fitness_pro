import 'package:dio/dio.dart';

/// The only error type datasources throw; [message] is safe to show to the user.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  /// Translates a [DioException] into a user-facing [ApiException].
  /// [statusMessages] overrides the default text for specific status codes.
  factory ApiException.fromDio(
    DioException e, {
    Map<int, String> statusMessages = const {},
  }) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
            'Connection timed out. Please check your internet connection.');
      case DioExceptionType.connectionError:
        final message = e.message?.toLowerCase() ?? '';
        if (message.contains('cors') ||
            message.contains('origin') ||
            message.contains('blocked')) {
          return const ApiException(
              'CORS error: Server is not allowing requests from this origin. Please contact the developer.');
        }
        return const ApiException(
            'Cannot connect to server. Please check if the server is running.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final override = statusMessages[statusCode];
        if (override != null) return ApiException(override);
        switch (statusCode) {
          case 401:
            return const ApiException('Session expired. Please sign in again.');
          case 403:
            return const ApiException('Access denied.');
          case 404:
            return const ApiException('Server endpoint not found.');
          case 500:
            return const ApiException('Server error. Please try again later.');
        }
        final data = e.response?.data;
        final serverMessage = data is Map ? data['message'] : null;
        if (serverMessage is String && serverMessage.isNotEmpty) {
          return ApiException(serverMessage);
        }
        return ApiException('Request failed with status: $statusCode');
      default:
        return ApiException(e.message ?? 'An unexpected error occurred.');
    }
  }

  /// User-facing text for any error caught in a bloc: the [ApiException]
  /// message, or a generic fallback so raw exceptions never reach the UI.
  static String messageOf(Object error) => error is ApiException
      ? error.message
      : 'Something went wrong. Please try again.';

  @override
  String toString() => message;
}
