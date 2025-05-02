import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils/string_utils.dart';

import '../models/ticket_status.dart';

class TicketTile extends StatefulWidget {
  const TicketTile({
    Key? key,
    required this.ticket,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  final ITransaction ticket;
  final VoidCallback onTap;
  final Function(ITransaction) onDelete;

  @override
  State<TicketTile> createState() => _TicketTileState();
}

class _TicketTileState extends State<TicketTile> {
  int? _minutesRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  void _setupTimer() {
    _updateMinutesRemaining();
    _timer?.cancel();
    if (widget.ticket.dueDate != null) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) {
          setState(_updateMinutesRemaining);
        }
      });
    }
  }

  void _updateMinutesRemaining() {
    if (widget.ticket.dueDate != null) {
      final now = DateTime.now();
      final diff = widget.ticket.dueDate!.toLocal().difference(now);
      _minutesRemaining = diff.inMinutes;
    } else {
      _minutesRemaining = null;
    }
  }

  @override
  void didUpdateWidget(covariant TicketTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ticket.dueDate != widget.ticket.dueDate) {
      _setupTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final ticketStatus =
        TicketStatusExtension.fromString(ticket.status ?? PARKED);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: widget.onTap,
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
                            // Show due date if present
                            if (ticket.dueDate != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.event,
                                        size: 16, color: Colors.deepPurple),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Due: ' +
                                          ticket.dueDate!
                                              .toLocal()
                                              .toString()
                                              .split(' ')[0],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Show minutes remaining chip if dueDate exists
                            if (ticket.dueDate != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Chip(
                                  avatar: const Icon(Icons.timer,
                                      size: 16, color: Colors.deepPurple),
                                  label: Text(
                                    _minutesRemaining == null
                                        ? ''
                                        : _minutesRemaining! < 0
                                            ? 'Overdue'
                                            : '${_minutesRemaining!} min left',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  backgroundColor:
                                      Colors.deepPurple.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  visualDensity: VisualDensity.compact,
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Delete button - positioned next to the status chip
                        ElevatedButton(
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Ticket'),
                                  content: const Text(
                                      'Are you sure you want to delete this ticket? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        widget.onDelete(ticket);
                                      },
                                      child: const Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red[600],
                            padding: const EdgeInsets.all(8),
                            minimumSize: const Size(36, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.red[300]!),
                          ),
                          child: const Icon(Icons.delete_outline, size: 18),
                        ),
                        const SizedBox(width: 8),
                        ticket.isLoan == true
                            ? Container(
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
                      ],
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
