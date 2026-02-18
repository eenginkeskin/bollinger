import 'indicator_strategy.dart';
import 'bollinger_band_indicator.dart';

class IndicatorRegistry {
  static final IndicatorRegistry _instance = IndicatorRegistry._();
  factory IndicatorRegistry() => _instance;
  IndicatorRegistry._() {
    register(const BollingerBandIndicator());
  }

  final Map<String, IndicatorStrategy> _indicators = {};

  void register(IndicatorStrategy indicator) {
    _indicators[indicator.id] = indicator;
  }

  IndicatorStrategy? get(String id) => _indicators[id];

  List<IndicatorStrategy> get all => _indicators.values.toList();
}
