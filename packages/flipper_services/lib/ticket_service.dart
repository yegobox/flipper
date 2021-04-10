library flipper_services;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_models/view_models/Queries.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class TicketService with ReactiveServiceMixin {
  /// This create a ticket and add all orders that has pending status
  /// if the ticket marked as parked which is a default status for a normal ticket that
  /// means it can be resumed but if is marked as completed then shall never be resumed as
  /// we are done with taking cash, normally a ticket combine more than one item "order"
  Future<void> saveNewTicket(
      {@required String ticketName,
      String note,
      double cashReceived = 0.0,
      String status = 'parked'}) async {
    if (ticketName != null) {
      // ProxyService.keypad.order.listen((order) {
      final q = Query(ProxyService.database.db, Queries.Q_3);

      q.parameters = {'T': AppTables.order, 'S': 'pending'};
      final id5 = Uuid().v1();
      final Document ticket = ProxyService.database.insert(id: id5, data: {
        'id': id5,
        'ticketName': ticketName,
        'table': AppTables.tickets,
        'cashReceived':
            cashReceived, //this will be updated when complete an order.
        'note': ProxyService.keypad.note.value ?? '',
        'resumed': false,
        'status': status,
        'createdAt': DateTime.now().toIso8601String(),
        'channels': [ProxyService.sharedState.user.id.toString()],
        'orders': []
      });

      q.addChangeListener((results) {
        for (Map map in results.allResults) {
          final pendingTicket = ProxyService.database.getById(id: ticket.ID);
          List<String> ods = [];
          if (pendingTicket.properties['orders'] != null) {
            ods = Ticket.fromMap(pendingTicket.map).orders.toList();
            ods.add(Order.fromMap(map).id);
            pendingTicket.properties['orders'] = ods;
            ProxyService.database.update(document: pendingTicket);
          }
          final Document parkedOrder =
              ProxyService.database.getById(id: Order.fromMap(map).id);
          parkedOrder.properties['active'] = false;
          parkedOrder.properties['draft'] = false;
          parkedOrder.properties['orderNote'] = status;
          parkedOrder.properties['status'] = status;
          ProxyService.database.update(document: parkedOrder);
        }
      });
      ProxyService.sharedState.setClear(c: true);
    }
  }
}
