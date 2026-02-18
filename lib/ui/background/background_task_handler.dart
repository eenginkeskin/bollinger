import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bollinger/core/constants/api_constants.dart';
import 'package:bollinger/core/constants/app_constants.dart';
import 'package:bollinger/data/models/kline.dart';
import 'package:bollinger/data/models/indicator_settings.dart';
import 'package:bollinger/domain/indicators/bollinger_band_indicator.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  // WorkManager requires a top-level function; actual registration is in main.dart
}

Future<bool> backgroundTaskHandler() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Read Bollinger settings
    final settingsJson = prefs.getString('indicator_settings_bollinger');
    final settings = settingsJson != null
        ? IndicatorSettings.decode(settingsJson)
        : IndicatorSettings.bollingerDefault();

    // Skip if Bollinger is disabled
    if (!settings.enabled) return true;

    final notifUpper = settings.notifications['upperBand'] ?? true;
    final notifLower = settings.notifications['lowerBand'] ?? true;
    if (!notifUpper && !notifLower) return true;

    final favorites = prefs.getStringList(AppConstants.favoritesKey) ?? [];
    if (favorites.isEmpty) return true;

    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
    ));

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(const InitializationSettings(
      iOS: DarwinInitializationSettings(),
    ));

    final period = (settings.params['period'] ?? 20).toInt();
    final stdDev = settings.params['stdDev'] ?? 2.0;
    final indicator = BollingerBandIndicator(
      period: period,
      stdDevMultiplier: stdDev,
    );
    int notifId = 0;

    for (final symbol in favorites) {
      try {
        final response = await dio.get(ApiConstants.klines, queryParameters: {
          'symbol': symbol,
          'interval': '1h',
          'limit': AppConstants.klineLimit,
        });
        final klines = (response.data as List)
            .map((item) => Kline.fromBinanceList(item as List))
            .toList();

        if (klines.length < period) continue;

        final result = indicator.computeResult(klines);
        final statusKey =
            '${AppConstants.lastBollingerStatusKey}_$symbol';
        final lastStatus = prefs.getString(statusKey);
        final currentStatus = result.currentStatus.name;

        if (currentStatus != lastStatus) {
          final shouldNotify =
              (currentStatus == 'upper' && notifUpper) ||
              (currentStatus == 'lower' && notifLower);

          if (shouldNotify) {
            final bandText =
                currentStatus == 'upper' ? 'UST BANT' : 'ALT BANT';
            await plugin.show(
              notifId++,
              '$symbol - $bandText',
              'Fiyat ${result.currentPrice} $bandText seviyesine ulasti.',
              const NotificationDetails(
                iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentSound: true,
                ),
              ),
            );
          }
        }
        await prefs.setString(statusKey, currentStatus);
      } catch (_) {
        // Skip this symbol on error
      }
    }
    return true;
  } catch (_) {
    return false;
  }
}
