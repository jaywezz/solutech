import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutench/features/activities/models/acttivities_model.dart';
import 'package:solutench/features/visits/models/customers_model.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/services/dio_service.dart';
import 'package:solutench/services/network_service_provider.dart';

final activitiesRepositoryProvider =
Provider<ActivitiesRepository>((ref) => ActivitiesRepository(ref));


class ActivitiesRepository extends StateNotifier {
  final Ref _reader;

  ActivitiesRepository(this._reader) : super(0);

  Future<List<Activities>> getActivities(bool isSync)async{
    try {
      final res = await ApiHandler.doGet(
          dio:_reader.read(networkServiceProvider),
          url: "/activities",
        );
        List<Activities> activities = activitiesFromJson(jsonEncode(res.data));
        return activities;
    } on DioError catch (e, s) {
      
      throw e.response?.data["message"];
    } catch (e, s) {
      print(e);
      print(s);
      throw "An unknown error occurred. Try again later";
    }
  }

  
  

}


