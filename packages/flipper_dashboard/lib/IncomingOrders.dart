// This file serves as the main entry point for the Incoming Orders feature
import 'package:flutter/material.dart';
import 'features/incoming_orders/screens/incoming_orders_screen.dart';

// Export all public components
export 'features/incoming_orders/screens/incoming_orders_screen.dart';
export 'features/incoming_orders/providers/incoming_orders_provider.dart';
export 'features/incoming_orders/widgets/action_row.dart';
export 'features/incoming_orders/widgets/branch_info.dart';
export 'features/incoming_orders/widgets/items_list.dart';
export 'features/incoming_orders/widgets/request_card.dart';
export 'features/incoming_orders/widgets/request_header.dart';
export 'features/incoming_orders/widgets/status_delivery_info.dart';

/// IncomingOrders widget is the main entry point for displaying and managing incoming order requests.
/// All implementation details are in the features/incoming_orders directory.
class IncomingOrders extends IncomingOrdersScreen {
  const IncomingOrders({Key? key}) : super(key: key);
}
