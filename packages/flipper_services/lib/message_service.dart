import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class MessageService with ReactiveServiceMixin {
  //a client will initiate an order by scanning a QR code.
  //the client will then send a message to the server to initiate the order.
  //the server will then send a message to the client to confirm the order.
  //the client will then send a message to the server to confirm the order.
  //the server will then send a message to the client to complete the order.
  //the client will then send a message to the server to complete the order.
  //the server will then send a message to the client to complete the order.
  //an order will be shown to the user. in the message service, the same message service can be used for all of the above.
  //the message service will be used by the client, the server, and the order.
  // the message service show the list of all businesses so the customer can select one. and initiate the order. or simply send simple text messages.
  void initIniateTransactionByScannedQRCode(String qrCode) {
    //the client will initiate the order by scanning a QR code.
  }
  String scanQRCode() {
    //the client will scan a QR code.
    return "Qr code";
  }

  final _orders = ReactiveValue<dynamic>(null);

  Transaction? get orders => _orders.value;
  void onNewTransaction() {
    // _orders.value = new TransactionF();
  }
  //listen on socket and update orders

  //load orders from Objectbox and update the orders list
  void loadTransactions() {
    int branchId = ProxyService.box.getBranchId()!;
    _orders.value = ProxyService.isar.completedTransactions(branchId: branchId);
  }

  MessageService() {
    listenToReactiveValues([_orders]);
  }
}
