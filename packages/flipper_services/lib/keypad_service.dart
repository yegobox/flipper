import 'package:stacked/stacked.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flipper/stack.dart';

class KeyPadService with ReactiveServiceMixin {
  final _key = ReactiveValue<String>("0.0");

  Stack stack = Stack<String>();

  String get key => _key.value;

  void addKey(String key) {
    stack.push(key);
    _key.value = stack.list.join('');
  }

  void reset() {
    if (stack.isNotEmpty && stack.length > 1) {
      stack.pop();
      _key.value = stack.list.join('');
    } else {
      stack.pop();
      _key.value = '0.0';
    }
  }

  KeyPadService() {
    listenToReactiveValues([_key]);
  }
}
