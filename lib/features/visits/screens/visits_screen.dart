import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solutench/common/widgets/no_data_widget.dart';
import 'package:solutench/features/visits/models/customers_model.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/features/visits/providers/visits_provider.dart';
import 'package:solutench/features/visits/screens/visits_form.dart';
import 'package:solutench/features/visits/widgets/visit_card_widget.dart';
import 'package:solutench/features/visits/widgets/visit_search_delegate.dart';
import 'package:solutench/features/reports/screens/widgets/shimmer_widgets.dart';
import 'package:solutench/utils/app_utils.dart';
import 'package:shimmer/shimmer.dart';

class VisitsScreen extends ConsumerStatefulWidget {
  static const routeName = "/visits";
  const VisitsScreen({super.key});

  @override
  ConsumerState<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends ConsumerState<VisitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSuggestions = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visits = ref.watch(visitsProvider).value ?? [];
    final customers = ref.watch(customersProvider).value ?? [];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Visits",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: VisitSearchDelegate(
                    visits: visits,
                    customers: customers,
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search visits...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showSuggestions = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                TabBar(
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Pending"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancelled"),
                  ],
                  labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                ref.refresh(visitsProvider);
                ref.refresh(customersProvider);
              },
              child: ref.watch(visitsProvider).when(
                data: (visits) => ref.watch(customersProvider).when(
                  data: (customers) => TabBarView(
                    children: [
                      _buildVisitsList(context, visits, customers),
                      _buildVisitsList(
                        context,
                        visits.where((v) => v.status?.name.toLowerCase() == "pending").toList(),
                        customers,
                      ),
                      _buildVisitsList(
                        context,
                        visits.where((v) => v.status?.name.toLowerCase() == "completed").toList(),
                        customers,
                      ),
                      _buildVisitsList(
                        context,
                        visits.where((v) => v.status?.name.toLowerCase() == "cancelled").toList(),
                        customers,
                      ),
                    ],
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  loading: () => Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surfaceVariant,
                    highlightColor: Theme.of(context).colorScheme.surface,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 5,
                      itemBuilder: (context, index) => ShimmerWidgets.buildShimmerListTile(),
                    ),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                loading: () => Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceVariant,
                  highlightColor: Theme.of(context).colorScheme.surface,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) => ShimmerWidgets.buildShimmerListTile(),
                  ),
                ),
              ),
            ),
            if (_showSuggestions)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: VisitSearchDelegate.buildSearchSuggestions(
                      context,
                      visits,
                      customers,
                      _searchController.text,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitsList(BuildContext context, List<Visits> visits, List<Customers> customers) {
    if (visits.isEmpty) {
      return const Center(
        child: NoDataWidget(
          message: "No visits found",
          icon: Icons.calendar_today,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        return VisitCardWidget(
          visit: visit,
          customerName: AppUtils.getCustomerName(customers, visit.customerId),
          onTap: () {
            context.pushNamed(VisitsForm.routeName, extra: visit);
          },
        );
      },
    );
  }
}