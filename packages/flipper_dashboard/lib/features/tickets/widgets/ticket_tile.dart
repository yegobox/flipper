import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import for date formatting
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

class _TicketTileState extends State<TicketTile>
    with AutomaticKeepAliveClientMixin {
  int? _minutesRemaining;
  Timer? _timer;
  final DateFormat _dateFormat = DateFormat(
    'MMM d, yyyy hh:mm a',
  ); // Date formatter

  @override
  bool get wantKeepAlive => true; // Keep the state alive even when offscreen

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
        _updateTimeRemainingString(); // Update only the string
      });
    }
  }

  void _updateMinutesRemaining() {
    if (widget.ticket.dueDate != null) {
      final now = DateTime.now();
      final diff = widget.ticket.dueDate!.toLocal().difference(now);
      _minutesRemaining = diff.inMinutes;
      _updateTimeRemainingString(); // Update the formatted string too
    } else {
      _minutesRemaining = null;
    }
  }

  /// Rebuilds so the remaining-time chip refreshes. The text itself is
  /// formatted in [build]: it needs localizations, which cannot be read from
  /// [initState] (where the first update runs).
  void _updateTimeRemainingString() {
    if (mounted) {
      setState(() {});
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

  String _formatTimeRemaining(int minutes, FlipperAppLocalizations l10n) {
    if (minutes < 0) {
      return l10n.ticketOverdue;
    }

    final days = minutes ~/ (60 * 24);
    final hours = (minutes % (60 * 24)) ~/ 60;
    final remainingMinutes = minutes % 60;

    if (days > 0) {
      return l10n.ticketDaysHoursLeft('$days', '$hours');
    } else if (hours > 0) {
      return l10n.ticketHoursMinutesLeft('$hours', '$remainingMinutes');
    } else {
      return l10n.ticketMinutesLeft('$minutes');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important for AutomaticKeepAliveClientMixin

    final l10n = context.flipperL10n;
    final ticket = widget.ticket;
    final timeRemaining = _minutesRemaining == null
        ? null
        : _formatTimeRemaining(_minutesRemaining!, l10n);
    final ticketStatus = TicketStatusExtension.fromString(
      ticket.status ?? PARKED,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final subtotalFormatted = (ticket.subTotal ?? 0.0).toStringAsFixed(
      2,
    ); // Format once

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        // Use InkWell for ripple effect on tap
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8.0), // Match Card's border radius

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align the whole column to the left
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align column to the left
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                ticket.ticketName ?? l10n.ticketNotAvailable,
                                style: GoogleFonts.outfit(
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
                              l10n.ticketIdShort(
                                safeSubstring(
                                  ticket.id,
                                  0,
                                  end: 8,
                                  ellipsis: false,
                                ),
                              ),
                              style: GoogleFonts.outfit(
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
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Display subtotal
                            Flexible(
                              child: Text(
                                l10n.ticketSubtotalValue(subtotalFormatted),
                                style: GoogleFonts.outfit(
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
                                    const Icon(
                                      Icons.event,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      l10n.ticketDueOn(
                                        _dateFormat.format(
                                          ticket.dueDate!.toLocal(),
                                        ),
                                      ),
                                      style: GoogleFonts.outfit(
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
                                  avatar: const Icon(
                                    Icons.timer,
                                    size: 16,
                                    color: Colors.deepPurple,
                                  ),
                                  label: Text(
                                    timeRemaining ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  backgroundColor: Colors.deepPurple.withValues(
                                    alpha: 0.1,
                                  ),
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
                                  title: Text(l10n.ticketDeleteTitle),
                                  content: Text(l10n.ticketDeleteConfirm),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(l10n.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        widget.onDelete(ticket);
                                      },
                                      child: Text(l10n.delete),
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
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  l10n.ticketLoan.toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.orange[800],
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ticketStatus.color.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ticketStatus.color,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  ticketStatus.displayLabel(l10n),
                                  style: GoogleFonts.outfit(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ticketStatus.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ticketStatus.color, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        ticketStatus.displayLabel(l10n),
                        style: GoogleFonts.outfit(
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
