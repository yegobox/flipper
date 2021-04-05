import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class TicketsViewModel extends ReactiveViewModel {
  final List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;
  final DatabaseService _databaseService = ProxyService.database;

  /// load tickets that have not been completed to be resumed later on
  /// NOTE: once a ticket is marked as completed it is for archive only
  /// and for transaction history, can not be resumed anymore!
  void loadTickets() {
    final ticketsQuery = Query(_databaseService.db,
        'SELECT id,orderId,ticketName,resumed,table,createdAt WHERE table=\$T AND status=\$S');
    ticketsQuery.parameters = {
      'T': AppTables.tickets,
      'S': 'parked'
    }; //looking for active order joined with stock_histories
    ticketsQuery.addChangeListener((orders) {
      // String orderId;
      // delete all and orders
      if (orders.allResults.isNotEmpty) {
        for (Map map in orders.allResults) {
          //NOTE: debuging
          // Ticket.fromMap(map).orders.toList().forEach((orderId) {
          //   _databaseService.delete(id: orderId);
          // });
          // _databaseService.delete(id: Ticket.fromMap(map).id);
          //NOTE: end of debuging.
          if (!_tickets.contains(Ticket.fromMap(map))) {
            _tickets.add(Ticket.fromMap(map));
          }
        }
        notifyListeners();
      }
    });
  }

  String _ticketName;
  String _note;
  bool _isLocked = true;
  bool get isLocked {
    return _isLocked;
  }

  void setTicketName({String ticketName}) {
    _ticketName = ticketName;
    notifyListeners();
  }

  void setNote({String note}) {
    _note = note;
    notifyListeners();
  }

  void lock() {
    _ticketName.isEmpty ? _isLocked = true : _isLocked = false;
    notifyListeners();
  }

  void saveToExistingTicket({@required String ticketId}) {
    final pendingTicket = _databaseService.getById(id: ticketId);
    ProxyService.keypad.order.listen((order) {
      List<String> ods = [];
      if (pendingTicket.properties['orders'] != null) {
        ods = Ticket.fromMap(pendingTicket.map).orders.toList();
        ods.add(order.id);
        pendingTicket.properties['orders'] = ods;
        ProxyService.database.update(document: pendingTicket);
      }
      //create a ticke with a name then edit a ticket with orderId(s) added as array.
      final Document pending = ProxyService.database.getById(id: order.id);

      pending.properties['active'] = false;
      pending.properties['draft'] = false;
      pending.properties['orderNote'] = 'parked';
      pending.properties['status'] = 'parked';
      ProxyService.database.update(document: pending);
      // clear the current sale count.
      ProxyService.sharedState.setClear(c: true);
    });
  }

  Future<void> saveNewTicket() async {
    if (_ticketName != null) {
      //create a new ticket for this order
      ProxyService.ticket.saveNewTicket(note: _note, ticketName: _ticketName);
    }
  }

  void resumeOrder({String ticketId}) {
    final Document ticket = _databaseService.getById(id: ticketId);
    // set resumable ticket this set the payable to save and with charge amount to be
    ticket.map['orders'].toList().forEach((orderId) {
      final Document pendingOrder = ProxyService.database.getById(id: orderId);
      pendingOrder.properties['active'] = true;
      pendingOrder.properties['draft'] = true;
      ProxyService.database.update(document: pendingOrder);

      ticket.properties['createdAt'] = DateTime.now().toIso8601String();
      ProxyService.database.update(document: ticket);
    });
    ticket.properties['resumed'] = true;
    ProxyService.database.update(document: ticket);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [ProxyService.sharedState, ProxyService.keypad, ProxyService.ticket];
}
