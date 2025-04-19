import 'package:flipper_models/providers/transaction_items_provider.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final horizontalPadding = isMobile ? 8.0 : 16.0;
        final verticalPadding = isMobile ? 8.0 : 16.0;
        final buttonFontSize = isMobile ? 14.0 : 16.0;
        final titleFontSize = isMobile ? 16.0 : 20.0;
        final sectionTitleFontSize = isMobile ? 15.0 : 18.0;

        Widget content = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isMobile ? 8 : 16),
              // New Ticket Button
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: isMobile ? double.infinity : 220,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final transaction = widget.transaction;
                      final transactionItemsAsync = transaction != null
                          ? ref.watch(transactionItemsProvider(
                              transactionId: transaction.id,
                            ).future)
                          : Future.value(<dynamic>[]);
                      return FutureBuilder<List<dynamic>>(
                        future: transactionItemsAsync,
                        builder: (context, snapshot) {
                          final itemCount =
                              snapshot.hasData ? snapshot.data!.length : 0;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff006AFE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 12.0 : 16.0,
                              ),
                              elevation: isMobile ? 1 : 0,
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: buttonFontSize,
                              ),
                            ),
                            onPressed: itemCount > 0
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return NewTicket(
                                          transaction: transaction!,
                                          onClose: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add,
                                    size: 18, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  itemCount > 0
                                      ? 'Create Ticket for $itemCount item${itemCount > 1 ? 's' : ''}'
                                      : 'New Ticket',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: buttonFontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ).eligibleToSee(
                              ref, [AccessLevel.ADMIN, AccessLevel.WRITE]);
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24)
                  .eligibleToSee(ref, [AccessLevel.ADMIN, AccessLevel.WRITE]),
              Text(
                'Tickets',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: sectionTitleFontSize,
                  color: const Color(0xff006AFE),
                ),
              ).shouldSeeTheApp(ref, featureName: "Tickets"),
              SizedBox(height: isMobile ? 8 : 16),
              // Make ticket section scrollable on mobile
              Expanded(
                child: isMobile
                    ? Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: buildTicketSection(context),
                      )
                    : buildTicketSection(context),
              ),
            ],
          ),
        );
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      // ignore: unused_result
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
                      fontSize: titleFontSize,
                      color: Colors.black,
                    ),
                  ),
                )
              : null,
          body: content,
        );
      },
    );
  }
}
