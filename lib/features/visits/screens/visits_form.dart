//form for visits have customer name, visit date, status, location, notes, activities done

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutench/features/activities/models/acttivities_model.dart';
import 'package:solutench/features/activities/provider/activities_provider.dart';
import 'package:solutench/features/visits/models/customers_model.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/features/visits/providers/visits_provider.dart';
import 'package:solutench/utils/app_utils.dart';
import 'package:solutench/common/widgets/common_widgets.dart';

final selectedActivities = StateProvider<List<int>>((ref) => []);

TextEditingController locationController = TextEditingController();
TextEditingController notesController = TextEditingController();

class VisitsForm extends ConsumerWidget {
  static const routeName = "/visits_form";
  final Visits visit;
  const VisitsForm({super.key, required this.visit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerName = AppUtils.getCustomerName(ref.read(customersProvider).value ?? [], visit.customerId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Visit Details",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(visitsProvider);
          ref.refresh(customersProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Info Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                customerName[0].toUpperCase(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer",
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    customerName,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppUtils.formatDate(DateTime.now()),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location Field
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Activities Section
              Text(
                "Activities",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ref.watch(activitiesProvider).when(
                    data: (activities) => Column(
                      children: activities.map((activity) => CheckboxListTile(
                        title: Text(
                          activity.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        value: ref.watch(selectedActivities).contains(activity.id),
                        onChanged: (value) {
                          ref.read(selectedActivities.notifier).state = value! 
                            ? [...ref.read(selectedActivities), activity.id]
                            : ref.read(selectedActivities).where((element) => element != activity.id).toList();
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      )).toList(),
                    ),
                    error: (error, stack) => Center(
                      child: Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ref.watch(visitsNotifier).when(
                  data: (_) => ElevatedButton(
                    onPressed: () {
                      if (locationController.text.isEmpty) {
                        showCustomSnackBar("Please enter a location");
                        return;
                      }
                      if (ref.read(selectedActivities).isEmpty) {
                        showCustomSnackBar("Please select at least one activity");
                        return;
                      }
                      ref.read(visitsNotifier.notifier).createVisit(
                        context,
                        Visits(
                          id: 0,
                          customerId: visit.customerId,
                          visitDate: DateTime.now(),
                          location: locationController.text,
                          notes: notesController.text,
                          activitiesDone: ref.read(selectedActivities),
                          createdAt: DateTime.now(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Save Visit",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  loading: () => ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Saving...",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  error: (error, stack) => ElevatedButton(
                    onPressed: () {
                      if (locationController.text.isEmpty) {
                        showCustomSnackBar("Please enter a location");
                        return;
                      }
                      if (ref.read(selectedActivities).isEmpty) {
                        showCustomSnackBar("Please select at least one activity");
                        return;
                      }
                      ref.read(visitsNotifier.notifier).createVisit(
                        context,
                        Visits(
                          id: 0,
                          customerId: visit.customerId,
                          visitDate: DateTime.now(),
                          location: locationController.text,
                          notes: notesController.text,
                          activitiesDone: ref.read(selectedActivities),
                          createdAt: DateTime.now(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Try Again",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

