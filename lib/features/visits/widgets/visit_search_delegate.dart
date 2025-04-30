import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solutench/features/visits/models/customers_model.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/features/visits/screens/visits_form.dart';
import 'package:solutench/utils/app_utils.dart';

class VisitSearchDelegate extends SearchDelegate {
  final List<Visits> visits;
  final List<Customers> customers;

  VisitSearchDelegate({
    required this.visits,
    required this.customers,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<Visits> searchResults = visits.where((visit) {
      final customerName = AppUtils.getCustomerName(customers, visit.customerId).toLowerCase();
      final visitDate = AppUtils.formatDate(visit.visitDate).toLowerCase();
      final status = visit.status?.name.toLowerCase() ?? '';
      
      return customerName.contains(query.toLowerCase()) ||
          visitDate.contains(query.toLowerCase()) ||
          status.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final visit = searchResults[index];
        final customerName = AppUtils.getCustomerName(customers, visit.customerId);
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              customerName[0].toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          title: Text(
            customerName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${AppUtils.formatDate(visit.visitDate)} - ${visit.status?.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () {
            context.pushNamed(VisitsForm.routeName, extra: visit);

          },
        );
      },
    );
  }

  static Widget buildSearchSuggestions(BuildContext context, List<Visits> visits, List<Customers> customers, String query) {
    final suggestions = visits.where((visit) {
      final customerName = AppUtils.getCustomerName(customers, visit.customerId).toLowerCase();
      final visitDate = AppUtils.formatDate(visit.visitDate).toLowerCase();
      final status = visit.status?.name.toLowerCase() ?? '';
      
      return customerName.contains(query) ||
          visitDate.contains(query) ||
          status.contains(query);
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final visit = suggestions[index];
        final customerName = AppUtils.getCustomerName(customers, visit.customerId);
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              customerName[0].toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          title: Text(
            customerName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${AppUtils.formatDate(visit.visitDate)} - ${visit.status?.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () {
             context.pushNamed(VisitsForm.routeName, extra: visit);

          },
        );
      },
    );
  }
} 