import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutench/features/visits/models/customers_model.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/services/dio_service.dart';
import 'package:solutench/services/network_service_provider.dart';

final visitsRepositoryProvider =
Provider<VisitsRepository>((ref) => VisitsRepository(ref));


class VisitsRepository extends StateNotifier {
  final Ref _reader;

  VisitsRepository(this._reader) : super(0);

  Future<List<Visits>> getVisits(bool isSync)async{
    try {
      final res = await ApiHandler.doGet(
          dio:_reader.read(networkServiceProvider),
          url: "/visits",
        );
        print(res.data);
        List<Visits> visits = visitsFromJson(jsonEncode(res.data));
        return visits;
    } on DioError catch (e, s) {
      
      throw e.response?.data["message"];
    } catch (e, s) {
      print(e);
      print(s);
      throw "An unknown error occurred. Try again later";
    }
  }

  Future createVisit(bool isSync, Visits visit)async{
    try {
      final res = await ApiHandler.doPost(
          dio:_reader.read(networkServiceProvider),
          url: "/visits", data: visit.toJson(),
        );
        return res.data;
    } on DioError catch (e, s) {
    
      throw e.response?.data["message"];
    } catch (e, s) {
      print(e);
      print(s);
      throw "An unknown error occurred. Try again later";
    }
  }

  Future<List<Customers>> getCustomers(bool isSync)async{
    try {
      final res = await ApiHandler.doGet(
          dio:_reader.read(networkServiceProvider),
          url: "/customers",
        );
        List<Customers> customers = customersFromJson(jsonEncode(res.data));
        return customers;
    } on DioError catch (e, s) {
      
      throw e.response?.data["message"];
    } catch (e, s) {
      print(e);
      print(s);
      throw "An unknown error occurred. Try again later";
    }
  }

  

}


