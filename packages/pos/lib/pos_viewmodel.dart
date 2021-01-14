import 'package:stacked/stacked.dart';

class PosViewModel extends ReactiveViewModel {
  String expression = '';
  String result = '';

  var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  var operators = <String>['+', 'C'];

  bool isOperator(String op) {
    return operators.contains(op);
  }

  bool isDigit(String op) {
    return digits.contains(op);
  }

  void addKey(String key) {
    var _expr = expression;
    var _result = '';
    if (result.isNotEmpty) {
      _expr = '';
      _result = '';
    }

    if (operators.contains(key)) {
      // Handle as an operator
      if (_expr.length > 0 && operators.contains(_expr[_expr.length - 1])) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
      _expr += key;
    } else if (digits.contains(key)) {
      _expr += key;
    } else if (key == 'C') {
      if (_expr.length > 0) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
    }

    expression = _expr;
    result = _result;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
