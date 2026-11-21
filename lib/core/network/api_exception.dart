import 'package:dio/dio.dart';
import '../l10n/app_strings.dart';

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
        return ApiException(
            'Connection timed out. Please check your internet connection.'.trNow);
      case DioExceptionType.connectionError:
        final message = e.message?.toLowerCase() ?? '';
        if (message.contains('cors') ||
            message.contains('origin') ||
            message.contains('blocked')) {
          return ApiException(
              'CORS error: Server is not allowing requests from this origin. Please contact the developer.'.trNow);
        }
        return ApiException(
            'Cannot connect to server. Please check if the server is running.'.trNow);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final override = statusMessages[statusCode];
        if (override != null) return ApiException(override);
        switch (statusCode) {
          case 401:
            return ApiException('Session expired. Please sign in again.'.trNow);
          case 403:
            return ApiException('Access denied.'.trNow);
          case 404:
            return ApiException('Server endpoint not found.'.trNow);
          case 500:
            return ApiException('Server error. Please try again later.'.trNow);
        }
        final data = e.response?.data;
        final serverMessage = data is Map ? data['message'] : null;
        if (serverMessage is String && serverMessage.isNotEmpty) {
          return ApiException(serverMessage);
        }
        // Bean-validation errors arrive as {"field": "problem", ...}.
        if (data is Map && data.isNotEmpty && data.values.every((v) => v is String)) {
          return ApiException(data.values.join('\n'));
        }
        return ApiException(AppStrings.tNow(
            'Request failed with status: $statusCode',
            'অনুরোধ ব্যর্থ হয়েছে (স্ট্যাটাস: $statusCode)'));
      default:
        return ApiException(e.message ?? 'An unexpected error occurred.'.trNow);
    }
  }

  /// User-facing text for any error caught in a bloc: the [ApiException]
  /// message, or a generic fallback so raw exceptions never reach the UI.
  static String messageOf(Object error) => error is ApiException
      ? error.message
      : 'Something went wrong. Please try again.'.trNow;

  @override
  String toString() => message;
}
