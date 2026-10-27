class ApiEndpoints {
  ApiEndpoints._();

  /// Backend address. Defaults to localhost on every platform:
  /// - Web / desktop: the backend runs on this PC.
  /// - Android phone or emulator over USB/adb: run once per connection
  ///     adb reverse tcp:8080 tcp:8080
  ///   so the device's localhost:8080 reaches the PC's backend.
  /// To call the backend over Wi-Fi instead, override it, e.g.
  ///   flutter run --dart-define=API_BASE_URL=http://10.231.105.1:8080
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const signup  = '$baseUrl/api/auth/signup';
  static const signin  = '$baseUrl/api/auth/signin';
  static const profile = '$baseUrl/api/auth/user';
}
