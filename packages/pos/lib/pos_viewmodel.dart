import 'dart:collection';

import 'package:flipper_services/flipperServices.dart';
import 'package:flipper_services/locator.dart';
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
    } else if (key == 'C') {
      if (_expr.isNotEmpty) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
    } else if (key == '+') {
      if (_expr.isNotEmpty) {
        _sharedState.setCustomAmount(customAmount: double.parse(expression));
        expression = '';
      }
    }
    expression = _expr;
    result = _result;
    notifyListeners();
  }

  int _getPriority(String op) {
    switch (op) {
      case '+':
      case '-':
        return 0;
      case '*':
      case '/':
        return 1;
      default:
        return -1;
    }
  }

  num _eval(num op1, num op2, String op) {
    switch (op) {
      case '+':
        return op1 + op2;
      case '-':
        return op1 - op2;
      case '*':
        return op1 * op2;
      case '/':
        return op1 / op2;
      default:
        return 0;
    }
  }

  num parseExpression(String expr, PosViewModel model) {
    final Queue<String> operators = ListQueue<String>();
    final Queue<num> operands = ListQueue<num>();

    bool lastDig = true;

    // INIT
    operands.addLast(0);

    expr.split('').forEach((String c) {
      if (model.isDigit(c)) {
        if (lastDig) {
          final num last = operands.removeLast();
          operands.addLast(last * 10 + int.parse(c));
        } else
          operands.addLast(int.parse(c));
      } else if (model.isOperator(c)) {
        if (!lastDig) throw ArgumentError('Illegal expression');

        if (operators.isEmpty)
          operators.addLast(c);
        else {
          while (operators.isNotEmpty &&
              operands.isNotEmpty &&
              _getPriority(c) <= _getPriority(operators.last)) {
            final num op1 = operands.removeLast();
            final num op2 = operands.removeLast();
            final String op = operators.removeLast();

            // op1 and op2 in reverse order!
            final num res = _eval(op2, op1, op);
            operands.addLast(res);
          }
          operators.addLast(c);
        }
      }
      lastDig = model.isDigit(c);
    });

    while (operators.isNotEmpty) {
      final num op1 = operands.removeLast();
      final num op2 = operands.removeLast();
      final String op = operators.removeLast();

      final num res = _eval(op2, op1, op);
      operands.addLast(res);
    }

    return operands.removeLast();
  }

  bool isOperator(String op) {
    return operators.contains(op);
  }

  bool isDigit(String op) {
    return digits.contains(op);
  }
}
