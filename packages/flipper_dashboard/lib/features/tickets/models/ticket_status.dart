import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/constants.dart';

/// Enum representing the possible statuses of a ticket
enum TicketStatus {
  waiting,
  inProgress,
  completed,

  /// Ticket Review + Handover workflow (opt-in): fully paid, awaiting
  /// reviewer sign-off. Only ever appears in the Review Queue.
  pendingReview,

  /// Ticket Review + Handover workflow: reviewed, awaiting stock-manager
  /// handover confirmation. Visible in the normal Tickets list.
  awaitingHandover,
}

extension TicketStatusExtension on TicketStatus {
  /// Display label in the app's current language. Widgets should prefer
  /// [displayLabel] with `context.flipperL10n` so a language switch rebuilds.
  String get displayName => displayLabel(FlipperL10n.current);

  String displayLabel(FlipperAppLocalizations l10n) {
    switch (this) {
      case TicketStatus.waiting:
        return l10n.ticketStatusWaiting;
      case TicketStatus.inProgress:
        return l10n.ticketStatusInProgress;
      case TicketStatus.completed:
        return l10n.ticketStatusPaid;
      case TicketStatus.pendingReview:
        return l10n.ticketStatusPendingReview;
      case TicketStatus.awaitingHandover:
        return l10n.ticketStatusReviewed;
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.waiting:
        return const Color(0xFF8B6914);
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.completed:
        return Colors.green;
      case TicketStatus.pendingReview:
        return const Color(0xFF7C3AED);
      case TicketStatus.awaitingHandover:
        return const Color(0xFF0D9488);
    }
  }

  String get statusValue {
    switch (this) {
      case TicketStatus.waiting:
        return PARKED;
      case TicketStatus.inProgress:
        return IN_PROGRESS;
      case TicketStatus.completed:
        return COMPLETE;
      case TicketStatus.pendingReview:
        return PENDING_REVIEW;
      case TicketStatus.awaitingHandover:
        return AWAITING_HANDOVER;
    }
  }

  static TicketStatus fromString(String status) {
    switch (status) {
      case PARKED:
        return TicketStatus.waiting;
      case IN_PROGRESS:
        return TicketStatus.inProgress;
      case ORDERING: // Keep backward compatibility with existing data
        return TicketStatus.inProgress;
      case COMPLETE:
        return TicketStatus.completed;
      case PENDING_REVIEW:
        return TicketStatus.pendingReview;
      case AWAITING_HANDOVER:
        return TicketStatus.awaitingHandover;
      default:
        return TicketStatus.waiting;
    }
  }
}
