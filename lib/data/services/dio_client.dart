import 'package:dio/dio.dart';
import 'package:bollinger/core/constants/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._();
  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.timeout,
        receiveTimeout: ApiConstants.timeout,
      ),
    );
  }
}
