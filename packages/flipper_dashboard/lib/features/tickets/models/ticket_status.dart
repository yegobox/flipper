import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';

/// Enum representing the possible statuses of a ticket
enum TicketStatus { waiting, inProgress, completed }

extension TicketStatusExtension on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.waiting:
        return 'Waiting';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.waiting:
        return Colors.purple;
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.completed:
        return Colors.green;
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
      default:
        return TicketStatus.waiting;
    }
  }
}
