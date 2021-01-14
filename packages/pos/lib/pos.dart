library pos;

import 'dart:collection';

import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Display(),
          Keyboard(),
        ],
      ),
    );
  }
}

// var _displayState = DisplayState();

class Display extends StatelessWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _displayState;
//   }
// }

// class DisplayState extends State<Display> {
  final _expression = '';
  final _result = '';

  @override
  Widget build(BuildContext context) {
    final views = <Widget>[
      Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                _expression,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ))
            ],
          )),
    ];

    if (_result.isNotEmpty) {
      views.add(
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  _result,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ))
              ],
            )),
      );
    }

    return Expanded(
        flex: 2,
        child: Container(
          color: Theme.of(context)
              .copyWith(canvasColor: Colors.white)
              .canvasColor, //this can be set to a visible color, when designing
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: views,
          ),
        ));
  }
}

void _addKey(String key) {
  // var _expr = _displayState._expression;
  // var _result = '';
  // if (_displayState._result.isNotEmpty) {
  //   _expr = '';
  //   _result = '';
  // }

  // if (operators.contains(key)) {
  //   // Handle as an operator
  //   if (_expr.length > 0 && operators.contains(_expr[_expr.length - 1])) {
  //     _expr = _expr.substring(0, _expr.length - 1);
  //   }
  //   _expr += key;
  // } else if (digits.contains(key)) {
  //   _expr += key;
  // } else if (key == 'C') {
  //   if (_expr.length > 0) {
  //     _expr = _expr.substring(0, _expr.length - 1);
  //   }
  // }
  // // ignore: invalid_use_of_protected_member
  // _displayState.setState(() {
  //   _displayState._expression = _expr;
  //   _displayState._result = _result;
  // });
}

class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
          flex: 12,
          child: Center(
              child: AspectRatio(
            aspectRatio: 1.0,
            child: GridView.count(
              shrinkWrap: false,
              crossAxisCount: 3,
              childAspectRatio: 2.0,
              padding: const EdgeInsets.all(2.0),
              mainAxisSpacing: 50.0,
              crossAxisSpacing: 1.0,
              children: <String>[
                // @formatter:off
                '1', '2', '3',
                '4', '5', '6',
                '7', '8', '9',
                'C', '0', '+',
                // @formatter:on
              ].map((key) {
                return GridTile(
                  child: KeyboardKey(key),
                );
              }).toList(),
            ),
          ))),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  const KeyboardKey(this._keyValue);

  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        _keyValue,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26.0,
          color: Colors.black,
        ),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      onPressed: () {
        _addKey(_keyValue);
      },
    );
  }
}

var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var operators = <String>['+'];

class Parser {
  const Parser();

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

  bool _isOperator(String op) {
    return operators.contains(op);
  }

  bool _isDigit(String op) {
    return digits.contains(op);
  }

  num parseExpression(String expr) {
    final Queue<String> operators = ListQueue<String>();
    final Queue<num> operands = ListQueue<num>();

    bool lastDig = true;

    // INIT
    operands.addLast(0);

    expr.split('').forEach((String c) {
      if (_isDigit(c)) {
        if (lastDig) {
          final num last = operands.removeLast();
          operands.addLast(last * 10 + int.parse(c));
        } else
          operands.addLast(int.parse(c));
      } else if (_isOperator(c)) {
        if (!lastDig) throw ArgumentError('Illegal expression');

        if (operators.isEmpty)
          operators.addLast(c);
        else {
          while (operators.isNotEmpty &&
              operands.isNotEmpty &&
              _getPriority(c) <= _getPriority(operators.last)) {
            num op1 = operands.removeLast();
            num op2 = operands.removeLast();
            String op = operators.removeLast();

            // op1 and op2 in reverse order!
            num res = _eval(op2, op1, op);
            operands.addLast(res);
          }
          operators.addLast(c);
        }
      }
      lastDig = _isDigit(c);
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
}
