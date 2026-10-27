import 'package:dio/dio.dart';
import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _badResponse(int status, [Object? data]) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: data,
    ),
  );
}

void main() {
  group('ApiException.fromDio', () {
    test('timeouts become a connection message', () {
      final e = ApiException.fromDio(DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.receiveTimeout,
      ));
      expect(e.message, contains('timed out'));
    });

    test('statusMessages overrides the default text', () {
      final e = ApiException.fromDio(
        _badResponse(401),
        statusMessages: const {401: 'Invalid username or password.'},
      );
      expect(e.message, 'Invalid username or password.');
    });

    test('uses the server message for other status codes', () {
      final e = ApiException.fromDio(_badResponse(400, {'message': 'Username taken'}));
      expect(e.message, 'Username taken');
    });

    test('falls back to the status code when the body has no message', () {
      final e = ApiException.fromDio(_badResponse(400, 'plain text'));
      expect(e.message, 'Request failed with status: 400');
    });
  });

  test('messageOf hides non-API errors behind a generic message', () {
    expect(ApiException.messageOf(const ApiException('boom')), 'boom');
    expect(ApiException.messageOf(StateError('internal')),
        'Something went wrong. Please try again.');
  });
}
