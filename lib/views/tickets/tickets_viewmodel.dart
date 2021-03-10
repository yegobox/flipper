import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class TicketsViewModel extends ReactiveViewModel {
  final List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;
  final DatabaseService _databaseService = ProxyService.database;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [ProxyService.sharedState];

  void loadTickets() {
    // final ticketsQuery = Query(_databaseService.db,
    //     'SELECT stocks_histories.id,stocks_histories.orderId,stocks_histories.createdAt,stocks_histories.reason,stocks_histories.channels,orders.orderNote FROM stocks_histories JOIN orders ON stocks_histories.orderId=orders.id WHERE orders.status=\$STATUS AND orders.active=\$ACTIVE');

    // // final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);

    // ticketsQuery.parameters = {
    //   'STATUS': 'parked',
    //   'ACTIVE': false,
    // }; //looking for active order joined with stock_histories

    final ticketsQuery = Query(_databaseService.db,
        'SELECT id,orderId,ticketName,table,createdAt WHERE table=\$T');

    // final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);

    ticketsQuery.parameters = {
      'T': AppTables.tickets,
    }; //looking for active order joined with stock_histories

    ticketsQuery.addChangeListener((List orders) {
      // String orderId;
      if (orders.isNotEmpty) {
        for (Map map in orders) {
          // _databaseService.delete(id: map['id']);
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
    final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);
    List<String> ods = [];
    if (pendingTicket.properties['orders'] != null) {
      ods = Ticket.fromMap(pendingTicket.jsonProperties).orders.toList();
      ods.add(pOrder.id);
      pendingTicket.properties['orders'] = ods;
      ProxyService.database.update(document: pendingTicket);
    }
    //create a ticke with a name then edit a ticket with orderId(s) added as array.
    final Document pending = ProxyService.database.getById(id: pOrder.id);

    pending.properties['active'] = false;
    pending.properties['draft'] = false;
    pending.properties['orderNote'] = 'parked';
    pending.properties['status'] = 'parked';
    ProxyService.database.update(document: pending);
    // clear the current sale count.
    ProxyService.sharedState.setClear(c: true);
  }

  Future<void> saveNewTicket() async {
    // print(ProxyService.sharedState.user.id.toString());
    if (_ticketName != null) {
      final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);
      //create a new ticket for this order
      final id5 = Uuid().v1();
      final Document ticket = _databaseService.insert(id: id5, data: {
        'id': id5,
        'ticketName': _ticketName,
        'table': AppTables.tickets,
        'note': _note,
        'createdAt': DateTime.now().toIso8601String(),
        'channels': [ProxyService.sharedState.user.id.toString()],
        'orders': []
      });
      final pendingTicket = _databaseService.getById(id: ticket.ID);
      List<String> ods = [];
      if (pendingTicket.properties['orders'] != null) {
        ods = Ticket.fromMap(pendingTicket.jsonProperties).orders.toList();
        ods.add(pOrder.id);
        pendingTicket.properties['orders'] = ods;
        ProxyService.database.update(document: pendingTicket);
      }
      //create a ticke with a name then edit a ticket with orderId(s) added as array.
      final Document pending = ProxyService.database.getById(id: pOrder.id);

      pending.properties['active'] = false;
      pending.properties['draft'] = false;
      pending.properties['orderNote'] = 'parked';
      pending.properties['status'] = 'parked';
      ProxyService.database.update(document: pending);
      // clear the current sale count.
      ProxyService.sharedState.setClear(c: true);
    }
  }
}
