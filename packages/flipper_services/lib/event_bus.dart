import 'dart:async';
import 'package:supabase_models/brick/models/customer.model.dart';

class CustomerUpserted {
  final Customer customer;
  CustomerUpserted(this.customer);
}

/// Fired when a service-layer action should switch an inner dashboard tab.
class OpenDashboardPageEvent {
  final String page;
  const OpenDashboardPageEvent(this.page);
}

/// Fired when a print delegation arrives so the UI can show an in-app banner.
/// OS notifications are often suppressed while Flipper is focused.
class DelegationReceivedEvent {
  final String transactionId;
  final String title;
  final String body;

  const DelegationReceivedEvent({
    required this.transactionId,
    required this.title,
    required this.body,
  });
}

/// Fired when a POS branch stock transfer completes (source) or arrives (dest).
/// Same banner path as [DelegationReceivedEvent] on desktop + mobile.
class StockTransferNotificationEvent {
  final String requestId;
  final String title;
  final String body;

  const StockTransferNotificationEvent({
    required this.requestId,
    required this.title,
    required this.body,
  });
}

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final _streamController = StreamController<dynamic>.broadcast();

  Stream<T> on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void fire(event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}