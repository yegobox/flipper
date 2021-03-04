import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
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
        'SELECT id,orderId,ticketName,createdAt WHERE table=\$T');

    // final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);

    ticketsQuery.parameters = {
      'T': AppTables.tickets,
    }; //looking for active order joined with stock_histories

    ticketsQuery.addChangeListener((List orders) {
      String orderId;
      if (orders.isNotEmpty) {
        for (Map map in orders) {
          if (!_tickets.contains(Ticket.fromMap(map))) {
            print(Ticket.fromMap(map));
            // remove duplicate as we couldn't use query alone!
            if (orderId != Ticket.fromMap(map).orderId) {
              orderId = Ticket.fromMap(map).orderId;
              _tickets.add(Ticket.fromMap(map));
            }
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

  Future<void> saveNewTicket() async {
    final Order pOrder = ProxyService.keypad.pendingOrder(customAmount: 0.0);
    //create a new ticket for this order
    final id5 = Uuid().v1();
    final Document ticket = _databaseService.insert(id: id5, data: {
      'id': id5,
      'ticketName': _ticketName,
      'table': AppTables.tickets,
      'created': DateTime.now().toIso8601String()
    });
    final pendingTicket = _databaseService.getById(id: ticket.ID);
    List<String> ods = [];
    if (pendingTicket.properties['orders'] != null) {
      // ignore: avoid_as
      ods = pendingTicket.properties['orders'] as List<String>;
      ods.add(pOrder.id);
      pendingTicket.properties['orders'] = ods;
      ProxyService.database.update(document: pendingTicket);
    }

    //create a ticke with a name then edit a ticket with orderId(s) added as array.
    final Document pending = ProxyService.database.getById(id: pOrder.id);
    pending.properties['active'] = false;
    pending.properties['orderNote'] = 'parked';
    pending.properties['status'] = 'parked';
    ProxyService.database.update(document: pending);
  }
}
