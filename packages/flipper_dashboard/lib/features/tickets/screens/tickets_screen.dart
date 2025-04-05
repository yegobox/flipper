import 'package:flipper_dashboard/new_ticket.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

import '../widgets/tickets_list.dart';

class TicketsScreen extends StatefulHookConsumerWidget {
  const TicketsScreen(
      {Key? key, required this.transaction, this.showAppBar = true})
      : super(key: key);

  final ITransaction? transaction;
  final bool showAppBar;

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen>
    with TicketsListMixin {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  ref.refresh(
                    pendingTransactionStreamProvider(isExpense: false),
                  );
                  _routerService.back();
                },
                icon: const Icon(Icons.close, color: Colors.black),
              ),
              title: Text(
                'Tickets',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // New Ticket Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff006AFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                if (widget.transaction != null) {
                  // Show NewTicket widget in a full-screen dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NewTicket(
                        transaction: widget.transaction!,
                        onClose: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'New Ticket',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ).eligibleToSee(ref, [AccessLevel.ADMIN, AccessLevel.WRITE]),
            const SizedBox(height: 24)
                .eligibleToSee(ref, [AccessLevel.ADMIN, AccessLevel.WRITE]),

            Text(
              'Tickets',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: const Color(0xff006AFE),
              ),
            ).shouldSeeTheApp(ref, featureName: "Tickets"),
            const SizedBox(height: 16),
            buildTicketSection(context),
          ],
        ),
      ),
    );
  }
}
