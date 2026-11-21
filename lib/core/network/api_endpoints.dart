class ApiEndpoints {
  ApiEndpoints._();

  /// Backend address. Defaults to the backend PC's Wi-Fi/LAN IP, which works
  /// from a real phone on the same network and from the PC itself (web/desktop).
  /// If the PC's IP changes, override it without editing code:
  ///   flutter run --dart-define=API_BASE_URL=http://NEW_IP:8080
  /// Android emulator alternative: http://10.0.2.2:8080
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.101:8080',
  );

  static const signup  = '$baseUrl/api/auth/signup';
  static const signin  = '$baseUrl/api/auth/signin';
  static const profile = '$baseUrl/api/profile';
  static const changePassword = '$baseUrl/api/profile/change-password';
  static const addresses = '$baseUrl/api/addresses';

  // Gyms, user management, dashboards
  static const publicGyms     = '$baseUrl/api/public/gyms/dropdown';
  static const adminGyms      = '$baseUrl/api/admin/gyms';
  static const adminUsers     = '$baseUrl/api/admin/users';
  static const adminDashboard = '$baseUrl/api/admin/dashboard';
  static const trainerMembers = '$baseUrl/api/trainer/members';

  // Gym subscription fees
  static const mySubscription            = '$baseUrl/api/member/subscription';
  static const adminSubscriptions        = '$baseUrl/api/admin/subscriptions';
  static const adminSubscriptionMembers  = '$baseUrl/api/admin/subscriptions/members';
  static const adminSubscriptionSummary  = '$baseUrl/api/admin/subscriptions/summary';
  static const notifications             = '$baseUrl/api/notifications';

  // Age calculator: the user's saved birth date/time (any role)
  static const ageCalculator = '$baseUrl/api/age-calculator';

  // BMI readings and history (any role)
  static const bmi = '$baseUrl/api/bmi';
}
