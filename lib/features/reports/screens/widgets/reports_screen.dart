import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solutench/common/widgets/no_data_widget.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/features/visits/providers/visits_provider.dart';
import 'package:solutench/features/visits/screens/visits_screen.dart';
import 'package:solutench/utils/app_utils.dart';

class ReportsScreen extends ConsumerWidget {
  static const routeName = "/reports";
  const ReportsScreen({super.key});

  Widget _buildShimmerCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 14,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Container(
              width: 40,
              height: 24,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerListTile() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitCard(BuildContext context, Visits visit, String customerName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: InkWell(
        onTap: () => context.goNamed(VisitsScreen.routeName),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(visit.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      visit.status?.name ?? "Unknown",
                      style: TextStyle(
                        color: _getStatusColor(visit.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppUtils.formatDate(visit.visitDate),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              if (visit.location.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        visit.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (visit.activitiesDone.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: visit.activitiesDone.map((activity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        activity,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(Status? status) {
    switch (status) {
      case Status.PENDING:
        return Colors.orange;
      case Status.COMPLETED:
        return Colors.green;
      case Status.CANCELLED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Status Cards Row
              ref.watch(visitsProvider).when(
                data: (data) {
                  final allVisits = data.length;
                  final pendingVisits = data.where((element) => element.status?.name == "Pending").length;
                  final completedVisits = data.where((element) => element.status?.name == "Completed").length;
                  final cancelledVisits = data.where((element) => element.status?.name == "Cancelled").length;

                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          context,
                          "All Visits",
                          allVisits.toString(),
                          Theme.of(context).primaryColor,
                          Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatusCard(
                          context,
                          "Pending",
                          pendingVisits.toString(),
                          Colors.orange,
                          Icons.pending_actions,
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stack) => Text(error.toString()),
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Row(
                    children: [
                      Expanded(child: _buildShimmerCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildShimmerCard()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ref.watch(visitsProvider).when(
                data: (data) {
                  final completedVisits = data.where((element) => element.status?.name == "Completed").length;
                  final cancelledVisits = data.where((element) => element.status?.name == "Cancelled").length;

                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          context,
                          "Completed",
                          completedVisits.toString(),
                          Colors.green,
                          Icons.check_circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatusCard(
                          context,
                          "Cancelled",
                          cancelledVisits.toString(),
                          Colors.red,
                          Icons.cancel,
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stack) => Text(error.toString()),
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Row(
                    children: [
                      Expanded(child: _buildShimmerCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildShimmerCard()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // View All Visits Tile
              Card(
                child: ListTile(
                  title: const Text("View All Visits"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.goNamed(VisitsScreen.routeName),
                ),
              ),
              const SizedBox(height: 24),
              // Pending Visits Section
              const Text(
                "Pending Visits",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ref.watch(visitsProvider).when(
                data: (visits) {
                  final pendingVisits = visits.where((element) => element.status?.name == "Pending").toList();
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
                          return _buildVisitCard(
                            context,
                            visit,
                            AppUtils.getCustomerName(customers, visit.customerId),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Text(error.toString()),
                    loading: () => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => _buildShimmerListTile(),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stack) => Text(error.toString()),
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => _buildShimmerListTile(),
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

  Widget _buildStatusCard(
    BuildContext context,
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 