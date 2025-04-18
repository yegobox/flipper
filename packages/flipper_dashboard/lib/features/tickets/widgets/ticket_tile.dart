import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils/string_utils.dart';

import '../models/ticket_status.dart';

class TicketTile extends StatelessWidget {
  const TicketTile({
    Key? key,
    required this.ticket,
    required this.onTap,
  }) : super(key: key);

  final ITransaction ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Get ticket status from transaction status
    final ticketStatus =
        TicketStatusExtension.fromString(ticket.status ?? PARKED);

    // Get screen width to adapt layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360; // Threshold for very small screens

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Ticket name and ID
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                ticket.ticketName ?? "N/A",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Display ID in a smaller, subtle format
                            Text(
                              '(ID: ${safeSubstring(ticket.id, 0, end: 8, ellipsis: false)})',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Display time ago
                            Text(
                              timeago.format(ticket.updatedAt!),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Display subtotal
                            Flexible(
                              child: Text(
                                'Subtotal: ${(ticket.subTotal ?? 0.0).toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Far right: Loan chip if loan, else status chip
                  Align(
                    alignment: Alignment.topRight,
                    child: ticket.isLoan == true
                        ? Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'LOAN',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.orange[800],
                                letterSpacing: 1.2,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ticketStatus.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: ticketStatus.color, width: 1),
                            ),
                            child: Text(
                              ticketStatus.displayName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: ticketStatus.color,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              // For small screens, show status below in full width (optional, can be kept for mobile)
              if (isSmallScreen && ticket.isLoan != true)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ticketStatus.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ticketStatus.color, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        ticketStatus.displayName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: ticketStatus.color,
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
