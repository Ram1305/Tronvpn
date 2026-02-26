/// Backend API base URL (from env or build). Used by payment and other APIs.
///
/// Set via: flutter run --dart-define=API_BASE_URL=http://YOUR_IP:3000
/// - Android emulator: use http://10.0.2.2:3000 (default)
/// - iOS simulator: use http://127.0.0.1:3000
/// - Physical device: use your machine IP, e.g. http://192.168.1.10:3000
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
}
