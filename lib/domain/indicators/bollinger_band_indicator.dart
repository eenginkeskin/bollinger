import 'dart:math';
import 'package:bollinger/core/constants/app_constants.dart';
import 'package:bollinger/data/models/kline.dart';
import 'package:bollinger/data/models/bollinger_result.dart';
import 'indicator_strategy.dart';

class BollingerBandIndicator implements IndicatorStrategy {
  final int period;
  final double stdDevMultiplier;

  const BollingerBandIndicator({
    this.period = AppConstants.bollingerPeriod,
    this.stdDevMultiplier = AppConstants.bollingerStdDev,
  });

  @override
  String get id => 'bollinger';

  @override
  String get name => 'Bollinger Bands';

  @override
  Map<String, List<double>> calculate(List<Kline> klines) {
    final closes = klines.map((k) => k.close).toList();
    final upper = <double>[];
    final middle = <double>[];
    final lower = <double>[];

    for (int i = period - 1; i < closes.length; i++) {
      final window = closes.sublist(i - period + 1, i + 1);
      final sma = window.reduce((a, b) => a + b) / period;
      final variance =
          window.map((c) => pow(c - sma, 2)).reduce((a, b) => a + b) / period;
      final stdDev = sqrt(variance);

      middle.add(sma);
      upper.add(sma + stdDevMultiplier * stdDev);
      lower.add(sma - stdDevMultiplier * stdDev);
    }

    return {'upper': upper, 'middle': middle, 'lower': lower};
  }

  BollingerResult computeResult(List<Kline> klines) {
    final bands = calculate(klines);
    final currentPrice = klines.last.close;
    final status = BollingerResult.calculateStatus(
      currentPrice,
      bands['upper']!.last,
      bands['lower']!.last,
    );

    return BollingerResult(
      upperBand: bands['upper']!,
      middleBand: bands['middle']!,
      lowerBand: bands['lower']!,
      currentStatus: status,
      currentPrice: currentPrice,
    );
  }
}
