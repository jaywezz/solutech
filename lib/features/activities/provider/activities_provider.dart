 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutench/features/activities/models/acttivities_model.dart';
import 'package:solutench/features/activities/repository/activities_repo.dart';

final activitiesProvider = FutureProvider<List<Activities>>((ref) async {
  final activities = await ref.watch(activitiesRepositoryProvider).getActivities(true);
  return activities;
});



