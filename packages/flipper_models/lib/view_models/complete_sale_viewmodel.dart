library flipper_models;
import 'dart:convert';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

Spenn spennFromJson(String str) => Spenn.fromJson(json.decode(str));

String spennToJson(Spenn data) => json.encode(data.toJson());
SpennpaymentStatus spennpaymentStatusFromJson(String str) =>
    SpennpaymentStatus.fromJson(json.decode(str));

String spennpaymentStatusToJson(SpennpaymentStatus data) =>
    json.encode(data.toJson());

class SpennpaymentStatus {
  SpennpaymentStatus({
    this.userId,
    this.paymentSuccess,
  });

  String userId;
  int paymentSuccess;

  // ignore: sort_constructors_first
  factory SpennpaymentStatus.fromJson(Map<String, dynamic> json) =>
      SpennpaymentStatus(
        userId: json['user_id'],
        paymentSuccess: json['PaymentSuccess'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'PaymentSuccess': paymentSuccess,
      };
}

class Spenn {
  Spenn({
    this.id,
    this.requestId,
    this.status,
  });

  String id;
  String requestId;
  String status;

  factory Spenn.fromJson(Map<String, dynamic> json) => Spenn(
        id: json['\u0024id'],
        requestId: json['requestId'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        '\u0024id': id,
        'requestId': requestId,
        'status': status,
      };
}

class CompleteSaleViewModel extends ReactiveViewModel {
  final _sharedState = locator<SharedStateService>();
  final keypad = locator<KeyPadService>();

  String _phone;

  // var completedSale;
  final RxValue<bool> completedSale = RxValue<bool>(initial: null);

  double total = 0.0;

  set phone(String phone) {
    _phone = phone;
  }

  void listenPaymentComplete() {
    ProxyService.pusher.pay.listen((completeCashCollection) {
      if (completeCashCollection != null) {
        final spennpaymentStatus =
            spennpaymentStatusFromJson(completeCashCollection.data);
        if (spennpaymentStatus.paymentSuccess == 3) {
          completedSale.value = false;
        } else if (spennpaymentStatus.paymentSuccess == 2) {
          ProxyService.sharedPref.removeKey(key: 'custom_orderId');
          // TODO: right now we are saving a ticket as system, we need to keep in consideration
          // when a ticket is resusmed, no need of creating a new ticket just use the resumed ticket
          ProxyService.ticket.saveNewTicket(
            ticketName: 'system_ticket',
            cashReceived: keypad.amount,
            status: 'completed',
          );
          completedSale.value = true;
          ProxyService.nav.navigateTo(Routing.afterSaleView);
        } else {
          print(spennpaymentStatus.paymentSuccess);
        }
      }
    });
  }

  void collectSPENNPayment() async {
    final String transactionNumber = Uuid().v1();


    try {
      final http.Response response = await http.post(
          'https://flipper.yegobox.com/pay',
          body: jsonEncode({
            'amount': keypad.totalPayable,
            'message': ProxyService.sharedState.business.name.substring(0, 3) +
                '-' +
                transactionNumber.substring(0, 4),
            'phoneNumber': '+25' + _phone,
            'uid': ProxyService.sharedState.user.id
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        final spenn = spennFromJson(response.body);
        ProxyService.pusher
            .subOnSPENNTransaction(transactionUid: spenn.requestId);
      } else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    }
  }

  ///this load all pending order's item to show on order summary
  ///it is very important to understand that an order is an item too since
  ///it has a variant ID etc...
  void setCurrentItemKeyPadSaleValue() {
    final q = Query(
        ProxyService.database.db, 'SELECT  *  WHERE table=\$T AND status=\$S');

    q.parameters = {'T': AppTables.order, 'S': 'pending'};

    final results = q.execute();
    if (results.isNotEmpty) {
      keypad.currentSale.clear();
      for (Map map in results) {
        map.forEach((key, value) {
          keypad.currentSale.add({
            'name': Order.fromMap(value).variantName,
            'price': Order.fromMap(value).amount,
            'id': Order.fromMap(value).id
          });
        });
      }
    }
    // ignore: avoid_function_literals_in_foreach_calls
    keypad.currentSale.forEach((e) {
      total += e['price'];
    });
    notifyListeners();
  }

  /// The method create a ticket and add all
  /// the order that are in pending state with cash received
  /// it will be like {id:'',amount:400,orders:[array of orders or what we call  item]}
  void collectCashPayment() {
    ProxyService.ticket.saveNewTicket(
      ticketName: 'system_ticket',
      cashReceived: keypad.amount,
      status: 'completed',
    );
    ProxyService.sharedPref.removeKey(key: 'custom_orderId');
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedState, keypad];
}
