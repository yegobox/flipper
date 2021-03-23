import 'dart:convert';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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
            'amount': keypad.totalAmount,
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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedState, keypad];

  void computeTotal() {
    keypad.currentSale.forEach((e) {
      print(e);
    });
  }
}
