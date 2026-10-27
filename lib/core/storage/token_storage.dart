import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey    = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _rolesKey    = 'roles';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUsername(String username) async {
    final prefs = await _prefs;
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getUsername() async {
    final prefs = await _prefs;
    return prefs.getString(_usernameKey);
  }

  Future<void> saveRoles(List<String> roles) async {
    final prefs = await _prefs;
    await prefs.setString(_rolesKey, roles.join(','));
  }

  Future<List<String>> getRoles() async {
    final prefs = await _prefs;
    final val = prefs.getString(_rolesKey);
    return val?.split(',') ?? [];
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_rolesKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}