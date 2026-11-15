import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

/// Adds `Authorization: Bearer <token>` to every request that needs it, so
/// datasources don't each read the token themselves. Sign in / sign up are
/// left alone: they must work with no token, or with a stale one.
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  AuthInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthCall = options.path.contains('/api/auth/signin') ||
        options.path.contains('/api/auth/signup');
    if (!isAuthCall && !options.headers.containsKey('Authorization')) {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
