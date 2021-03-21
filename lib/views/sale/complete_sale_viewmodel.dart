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
import 'dart:convert';

Spenn spennFromJson(String str) => Spenn.fromJson(json.decode(str));

String spennToJson(Spenn data) => json.encode(data.toJson());

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

  set phone(String phone) {
    _phone = phone;
  }

  void listenPaymentComplete() {
    ProxyService.pusher.pay.listen((completeCashCollection) {
      if (completeCashCollection != null) {
        completedSale.value = true;
        ProxyService.nav.navigateTo(Routing.afterSaleView);
      }
    });
  }

  void collectCash() async {
    print(ProxyService.sharedState.user.id);
    final String transactionNumber = Uuid().v1();
    await http.post('https://flipper.yegobox.com/pay',
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
        }).then((response) {
      final spenn = spennFromJson(response.body);
      ProxyService.pusher
          .subOnSPENNTransaction(transactionUid: spenn.requestId);
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedState, keypad];
}
