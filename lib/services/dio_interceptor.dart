import 'package:dio/dio.dart';
import 'package:solutench/constansts/url_constants.dart';

/// NetworkServiceInterceptor will override the onRequest method from  Dio Interceptor class
/// onRequest method will add out custom headers

class NetworkServiceInterceptor extends Interceptor {
  NetworkServiceInterceptor();

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Read the access token form the secure storage
    String accessToken = UrlConstants.token;

    options.headers['Accept'] = 'application/json';
    options.headers['contentType'] = 'application/json';
    options.headers['apikey'] = accessToken;

    super.onRequest(options, handler);
  }
}