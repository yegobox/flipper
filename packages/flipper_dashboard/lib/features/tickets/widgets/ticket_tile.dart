import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils/string_utils.dart';
import '../models/ticket_status.dart';

// Fluent Design inspired colors
const _cardElevation = 2.0;
const _cardHoverElevation = 4.0;
const _cardRadius = 8.0;
const _animationDuration = Duration(milliseconds: 150);
const _contentPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
const _spacingXSmall = 4.0;
const _spacingSmall = 8.0;
const _spacingMedium = 12.0;

// Typography
final _titleStyle = GoogleFonts.roboto(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.2,
  color: const Color(0xFF323130),
);

final _subtitleStyle = GoogleFonts.roboto(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF605E5C),
);

final _captionStyle = GoogleFonts.roboto(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF8A8886),
);

// Animation extensions
extension AnimationExtension on Widget {
  Widget withHoverEffect() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: _animationDuration,
        child: this,
      ),
    );
  }
}

// Helper widget for status badges
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSmall;

  const StatusBadge({
    Key? key,
    required this.label,
    required this.color,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: isSmall ? 12 : 13,
          fontWeight: FontWeight.w500,
          height: 1.2,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

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

  String _formatTimeRemaining(int minutes) {
    if (minutes < 0) {
      return 'Overdue';
    }

    final days = minutes ~/ (60 * 24);
    final hours = (minutes % (60 * 24)) ~/ 60;
    final remainingMinutes = minutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h left';
    } else if (hours > 0) {
      return '${hours}h ${remainingMinutes}m left';
    } else {
      return '$minutes min left';
    }
  }

  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final theme = Theme.of(context);
    final ticketStatus =
        TicketStatusExtension.fromString(ticket.status ?? PARKED);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Calculate card elevation based on hover state
    final cardElevation = _isHovering ? _cardHoverElevation : _cardElevation;

    // Format the due date if it exists
    final formattedDueDate = ticket.dueDate != null
        ? '${ticket.dueDate!.toLocal().toString().split(' ')[0]} • ${_formatTimeRemaining(_minutesRemaining ?? 0)}'
        : null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: _animationDuration,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            elevation: cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_cardRadius),
              side: BorderSide(
                color: theme.dividerColor.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(_cardRadius),
              onTap: widget.onTap,
              child: Padding(
                padding: _contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main content row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title row with ID
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ticket.ticketName ?? "Untitled Ticket",
                                      style: _titleStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: _spacingSmall),
                                  Text(
                                    '#${safeSubstring(ticket.id, 0, end: 6, ellipsis: false)}',
                                    style: _captionStyle,
                                  ),
                                ],
                              ),

                              const SizedBox(height: _spacingXSmall),

                              // Metadata row
                              Wrap(
                                spacing: _spacingMedium,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  // Last updated
                                  Text(
                                    timeago.format(ticket.updatedAt!),
                                    style: _subtitleStyle,
                                  ),

                                  // Subtotal
                                  Text(
                                    (ticket.subTotal ?? 0.0).toStringAsFixed(2),
                                    style: _subtitleStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  // Due date and timer
                                  if (formattedDueDate != null) ...[
                                    const SizedBox(width: _spacingSmall),
                                    StatusBadge(
                                      label: formattedDueDate,
                                      color: _minutesRemaining != null &&
                                              _minutesRemaining! < 0
                                          ? Colors.red
                                          : Colors.deepPurple,
                                      isSmall: true,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right actions
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Status badge or loan indicator
                            if (ticket.isLoan == true)
                              StatusBadge(
                                label: 'LOAN',
                                color: Colors.orange,
                              )
                            else
                              StatusBadge(
                                label: ticketStatus.displayName,
                                color: ticketStatus.color,
                              ),

                            const SizedBox(width: _spacingSmall),

                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: theme.colorScheme.error,
                              tooltip: 'Delete ticket',
                              onPressed: () =>
                                  _showDeleteConfirmation(context, ticket),
                              style: IconButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Additional info for small screens
                    if (isSmallScreen) ...[
                      const SizedBox(height: _spacingSmall),
                      if (ticket.isLoan != true)
                        Align(
                          alignment: Alignment.centerRight,
                          child: StatusBadge(
                            label: ticketStatus.displayName,
                            color: ticketStatus.color,
                            isSmall: true,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ITransaction ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ticket'),
          content: const Text(
            'Are you sure you want to delete this ticket? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(ticket);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
