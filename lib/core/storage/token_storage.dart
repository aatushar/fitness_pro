import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey    = 'auth_token';
  static const _usernameKey = 'username';
  static const _rolesKey    = 'roles';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> getToken() =>
      _storage.read(key: _tokenKey);

  Future<void> saveUsername(String username) =>
      _storage.write(key: _usernameKey, value: username);

  Future<String?> getUsername() =>
      _storage.read(key: _usernameKey);

  Future<void> saveRoles(List<String> roles) =>
      _storage.write(key: _rolesKey, value: roles.join(','));

  Future<List<String>> getRoles() async {
    final val = await _storage.read(key: _rolesKey);
    return val?.split(',') ?? [];
  }

  Future<void> clearAll() => _storage.deleteAll();

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}