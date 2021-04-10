import 'package:flipper_models/customer.dart';
import 'package:flipper_models/g_customer.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/ticket.dart';

abstract class Api {
  // Home screen futures api calls
  // ignore: always_specify_types
  Future payroll();
  List<Order> currentOrders();
  List<Ticket> currentTickets();
  Future<List<GCustomer>> customers();
  List<PColor> colors();
  Customer create({Map customer, String id});
}
