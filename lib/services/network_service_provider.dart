import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:solutench/constansts/url_constants.dart';
import 'package:solutench/services/dio_interceptor.dart';


/// Provide the instance of Dio
final networkServiceProvider = Provider.autoDispose<Dio>((ref) {

  final options = BaseOptions(
    baseUrl: UrlConstants.baseUrl,
    connectTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 120),
    receiveTimeout: const Duration(seconds: 60),

  );

  // Add our custom interceptors
  final dio = Dio(options)
    ..interceptors.addAll([
      // HttpFormatter(),
      NetworkServiceInterceptor(),
      // if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
    ]);

  return dio;
});