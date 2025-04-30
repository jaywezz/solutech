import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solutench/common/widgets/no_data_widget.dart';
import 'package:solutench/features/reports/screens/widgets/shimmer_widgets.dart';
import 'package:solutench/features/reports/screens/widgets/status_card_widget.dart';
import 'package:solutench/features/visits/screens/visits_form.dart';
import 'package:solutench/features/visits/widgets/visit_card_widget.dart';
import 'package:solutench/features/visits/providers/visits_provider.dart';
import 'package:solutench/features/visits/screens/visits_screen.dart';
import 'package:solutench/utils/app_utils.dart';

class ReportsScreen extends ConsumerWidget {
  static const routeName = "/reports";
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(visitsProvider);
          ref.refresh(customersProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, James",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppUtils.formatDate(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Status Cards Row
                ref.watch(visitsProvider).when(
                  data: (data) {
                    final allVisits = data.length;
                    final pendingVisits = data.where((element) => element.status?.name.toLowerCase() == "pending").length;
                    return Row(
                      children: [
                        Expanded(
                          child: StatusCardWidget(
                            title: "All Visits",
                            count: allVisits.toString(),
                            color: Theme.of(context).colorScheme.primary,
                            icon: Icons.calendar_today,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatusCardWidget(
                            title: "Pending",
                            count: pendingVisits.toString(),
                            color: Colors.orange,
                            icon: Icons.pending_actions,
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stack) => Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  loading: () => Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surfaceVariant,
                    highlightColor: Theme.of(context).colorScheme.surface,
                    child: Row(
                      children: [
                        Expanded(child: ShimmerWidgets.buildShimmerCard()),
                        const SizedBox(width: 16),
                        Expanded(child: ShimmerWidgets.buildShimmerCard()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ref.watch(visitsProvider).when(
                  data: (data) {
                    final completedVisits = data.where((element) => element.status?.name.toLowerCase() == "completed").length;
                    final cancelledVisits = data.where((element) => element.status?.name.toLowerCase() == "cancelled").length;

                    return Row(
                      children: [
                        Expanded(
                          child: StatusCardWidget(
                            title: "Completed",
                            count: completedVisits.toString(),
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatusCardWidget(
                            title: "Cancelled",
                            count: cancelledVisits.toString(),
                            color: Colors.red,
                            icon: Icons.cancel,
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stack) => Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  loading: () => Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surfaceVariant,
                    highlightColor: Theme.of(context).colorScheme.surface,
                    child: Row(
                      children: [
                        Expanded(child: ShimmerWidgets.buildShimmerCard()),
                        const SizedBox(width: 16),
                        Expanded(child: ShimmerWidgets.buildShimmerCard()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // View All Visits Tile
                Card(
                  child: ListTile(
                    title: Text(
                      "View All Visits",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => context.pushNamed(VisitsScreen.routeName),
                  ),
                ),
                const SizedBox(height: 24),
                // Pending Visits Section
                Text(
                  "Pending Visits",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 16),
                ref.watch(visitsProvider).when(
                  data: (visits) {
                    final pendingVisits = visits.where((element) => element.status?.name.toLowerCase() == "pending").toList();
                    if (pendingVisits.isEmpty) {
                      return const NoDataWidget(
                        message: "No pending visits",
                        icon: Icons.pending_actions,
                      );
                    }
                    return ref.watch(customersProvider).when(
                      data: (customers) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pendingVisits.length,
                          itemBuilder: (context, index) {
                            final visit = pendingVisits[index];
                            return VisitCardWidget(
                              visit: visit,
                              customerName: AppUtils.getCustomerName(customers, visit.customerId),
                              onTap: () => context.pushNamed(VisitsForm.routeName, extra: visit),
                            );
                          },
                        );
                      },
                      error: (error, stack) => Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      loading: () => Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.surfaceVariant,
                        highlightColor: Theme.of(context).colorScheme.surface,
                        child: Column(
                          children: List.generate(
                            3,
                            (index) => ShimmerWidgets.buildShimmerListTile(),
                          ),
                        ),
                      ),
                    );
                  },
                  error: (error, stack) => Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  loading: () => Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surfaceVariant,
                    highlightColor: Theme.of(context).colorScheme.surface,
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => ShimmerWidgets.buildShimmerListTile(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 