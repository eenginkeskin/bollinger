import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/data/models/kline.dart';
import 'package:bollinger/data/models/bollinger_result.dart';
import 'package:bollinger/domain/indicators/bollinger_band_indicator.dart';
import 'package:bollinger/providers/all_coins_provider.dart';
import 'package:bollinger/providers/settings_provider.dart';

final selectedIntervalProvider = StateProvider<String>((ref) => '1h');

final klineProvider =
    FutureProvider.family<List<Kline>, String>((ref, symbol) async {
  final interval = ref.watch(selectedIntervalProvider);
  final repo = ref.read(binanceRepositoryProvider);
  return repo.fetchKlines(symbol, interval: interval);
});

final bollingerResultProvider =
    FutureProvider.family<BollingerResult, String>((ref, symbol) async {
  final klines = await ref.watch(klineProvider(symbol).future);
  final settings = await ref.watch(bollingerSettingsProvider.future);
  final indicator = BollingerBandIndicator(
    period: (settings.params['period'] ?? 20).toInt(),
    stdDevMultiplier: settings.params['stdDev'] ?? 2.0,
  );
  return indicator.computeResult(klines);
});
