class AppConstants {
  static const int bollingerPeriod = 20;
  static const double bollingerStdDev = 2.0;
  static const Duration tickerRefreshInterval = Duration(seconds: 30);
  static const String favoritesKey = 'favorites';
  static const String lastBollingerStatusKey = 'last_bollinger_status';
  static const List<String> intervals = ['15m', '1h', '4h', '1d'];
  static const String defaultInterval = '1h';
  static const int klineLimit = 100;
}
