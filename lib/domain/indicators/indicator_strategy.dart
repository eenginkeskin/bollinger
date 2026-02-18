import 'package:bollinger/data/models/kline.dart';

abstract class IndicatorStrategy {
  String get id;
  String get name;
  Map<String, List<double>> calculate(List<Kline> klines);
}
