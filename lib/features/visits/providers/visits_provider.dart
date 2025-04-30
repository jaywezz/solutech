import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutench/features/visits/models/customers_model.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/features/visits/repository/visits_repository.dart';
import 'package:solutench/common/widgets/common_widgets.dart';

final visitsProvider = FutureProvider<List<Visits>>((ref) async {
  final visits = await ref.watch(visitsRepositoryProvider).getVisits(true);
  return visits.reversed.toList();
});

final customersProvider = FutureProvider<List<Customers>>((ref) async {
  final customers = await ref.watch(visitsRepositoryProvider).getCustomers(true);
  return customers.reversed.toList();
});

final visitsNotifier = StateNotifierProvider<VisitsNotifier, AsyncValue>((ref) {
  return VisitsNotifier(read: ref);
});

class VisitsNotifier extends StateNotifier<AsyncValue> {
  VisitsNotifier({required this.read}) : super(const AsyncValue.data(null));
  Ref read;

  Future<void> createVisit(BuildContext context, Visits visit) async {
    state = const AsyncValue.loading();
    try {
      final responseModel = await read.read(visitsRepositoryProvider).createVisit(true, visit);
      read.refresh(visitsProvider);
      if (!mounted) return;
      Navigator.pop(context);
      read.refresh(visitsProvider);
      state = AsyncValue.data(responseModel);
      showCustomSnackBar("Visit saved successfully", isError: false);
    } catch (e, s) {
      showCustomSnackBar(e.toString());
      state = AsyncValue.error(e.toString(), s);
    }
  }
}