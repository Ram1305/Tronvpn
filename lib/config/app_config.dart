/// Backend API base URL (from env or build). Used by payment and other APIs.
///
/// Default: http://72.61.236.154:2626
/// Override via: flutter run --dart-define=API_BASE_URL=http://YOUR_IP:PORT
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://72.61.236.154:2626',
  );
}
