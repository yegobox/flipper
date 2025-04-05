import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';

/// Enum representing the possible statuses of a ticket
enum TicketStatus { pending, inProgress, completed }

extension TicketStatusExtension on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.completed:
        return Colors.green;
    }
  }

  String get statusValue {
    switch (this) {
      case TicketStatus.pending:
        return PARKED;
      case TicketStatus.inProgress:
        return ORDERING;
      case TicketStatus.completed:
        return COMPLETE;
    }
  }

  static TicketStatus fromString(String status) {
    switch (status) {
      case PARKED:
        return TicketStatus.pending;
      case ORDERING:
        return TicketStatus.inProgress;
      case COMPLETE:
        return TicketStatus.completed;
      default:
        return TicketStatus.pending;
    }
  }
}
