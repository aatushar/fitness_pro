import 'package:flutter/foundation.dart';
import 'token_storage.dart';

/// Global token provider that can be accessed anywhere in the app
class GlobalToken extends ChangeNotifier {
  static final GlobalToken _instance = GlobalToken._internal();

  final TokenStorage _tokenStorage = TokenStorage();
  String? _token;

  GlobalToken._internal();

  factory GlobalToken() {
    return _instance;
  }

  /// Get the current token
  String? get token => _token;

  /// Get token asynchronously (useful when token might not be loaded yet)
  Future<String?> getToken() async {
    _token ??= await _tokenStorage.getToken();
    return _token;
  }

  /// Set token and persist it
  Future<void> setToken(String token) async {
    _token = token;
    await _tokenStorage.saveToken(token);
    notifyListeners();
  }

  /// Clear token
  Future<void> clearToken() async {
    _token = null;
    await _tokenStorage.clearAll();
    notifyListeners();
  }

  /// Load token from storage on app startup
  Future<void> initializeToken() async {
    _token = await _tokenStorage.getToken();
    notifyListeners();
  }

  /// Check if token exists
  bool get hasToken => _token != null && _token!.isNotEmpty;
}

/// Quick access to global token
GlobalToken get globalToken => GlobalToken();

