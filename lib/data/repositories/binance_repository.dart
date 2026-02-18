import 'package:bollinger/core/constants/api_constants.dart';
import 'package:bollinger/core/constants/app_constants.dart';
import 'package:bollinger/data/models/coin.dart';
import 'package:bollinger/data/models/kline.dart';
import 'package:bollinger/data/services/dio_client.dart';

class BinanceRepository {
  final _dio = DioClient().dio;

  Future<List<Coin>> fetchAllTickers() async {
    final response = await _dio.get(ApiConstants.ticker24hr);
    final List<dynamic> data = response.data;
    return data
        .map((json) => Coin.fromJson(json as Map<String, dynamic>))
        .where((coin) => coin.symbol.endsWith('USDT'))
        .toList()
      ..sort((a, b) => b.priceChangePercent.compareTo(a.priceChangePercent));
  }

  Future<List<Kline>> fetchKlines(String symbol,
      {String interval = AppConstants.defaultInterval}) async {
    final response = await _dio.get(
      ApiConstants.klines,
      queryParameters: {
        'symbol': symbol,
        'interval': interval,
        'limit': AppConstants.klineLimit,
      },
    );
    final List<dynamic> data = response.data;
    return data.map((item) => Kline.fromBinanceList(item as List)).toList();
  }
}
