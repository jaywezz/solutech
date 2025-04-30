import 'package:dio/dio.dart';

class ApiHandler {
  static Future<Response> doPost(
      {required Dio dio, required String url, required dynamic data, String? token}) async {
    // Get project code and add it to data if it's a map
    
    Response response = await dio.post(
        url, data: data);

   
    return response;
  }

  static Future<Response> doGet({required String url, required Dio dio, dynamic data}) async {
    // Initialize data as an empty map if it's null
    Map<String, dynamic> requestData = {};
    
    // If data is already a map, use it
    if (data is Map<String, dynamic>) {
      requestData = data;
    }
    
  
    Response response = await dio.get(url, data: requestData);
    
    //throw error
    if (response.statusCode == 401) {
      print("the response is 401");
    }
    return response;
  }

  
}