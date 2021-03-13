import 'dart:collection';

import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class PosViewModel extends ReactiveViewModel {
  var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  String expression = '0.0';
  var operators = <String>['+', '-', '*', '/'];
  String result = '';

  final _sharedState = locator<KeyPadService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedState];

  void addKey(String key) {
    var _expr = expression;
    var _result = '';
    if (result.isNotEmpty) {
      _expr = '';
      _result = '';
    }
    if (_expr == '0.0') {
      _expr = '';
    }

    if (operators.contains(key) && key != '+') {
      // Handle as an operator
      if (_expr.isNotEmpty && operators.contains(_expr[_expr.length - 1])) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
      _expr += key;
    } else if (digits.contains(key) && key != '+') {
      _expr += key;
      print('here digit');
    } else if (key == 'C') {
      print(_expr);
      if (_expr.isNotEmpty) {
        _expr = _expr.substring(0, _expr.length - 1);
        if (_expr.isEmpty) {
          _expr = '0.0';
          // TODO: delete a created product custom
        }
      }
    } else if (key == '+') {
      if (_expr.isNotEmpty) {
        // _sharedState.createCustomAmountItemAndSell(
        //     customAmount: double.parse(expression));
        expression = '';
      }
    }
    expression = _expr;
    result = _result;
    notifyListeners();
  }

  bool isOperator(String op) {
    return operators.contains(op);
  }

  bool isDigit(String op) {
    return digits.contains(op);
  }

  void saveTicket() {
    //start the save ticket flow
    ProxyService.inAppNav.navigateTo(path: 'ticketsView');
  }

  void viewTickets() {
    ProxyService.inAppNav.navigateTo(path: 'ticketsView');
  }
}
