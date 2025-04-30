import 'package:intl/intl.dart';
import 'package:solutench/features/visits/models/customers_model.dart';

class AppUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return "No date specified";
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  static String getCustomerName(List<Customers> customers, int customerId) {
    final customer = customers.firstWhere(
      (c) => c.id == customerId,
      orElse: () => Customers(id: 0, name: "Unknown Customer", createdAt: DateTime.now()),
    );
    return customer.name;
  }
} 