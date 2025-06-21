// This file is now just a re-export of the feature-based structure
// Keeping this file for backward compatibility with existing imports

import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

// Export all components from the feature directory
export 'features/tickets/tickets.dart';

// For backward compatibility, re-export the TicketsList class
import 'features/tickets/screens/tickets_screen.dart';

/// @deprecated Use TicketsScreen instead
class TicketsList extends StatelessWidget {
  const TicketsList(
      {Key? key, required this.transaction, this.showAppBar = true})
      : super(key: key);

  final ITransaction? transaction;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    // Delegate to the new implementation
    return TicketsScreen(
      transaction: transaction,
      showAppBar: showAppBar,
    );
  }
}
