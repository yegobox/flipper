import 'dart:collection';

import 'package:flutter/material.dart';

class MainBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Display(),
          new Keyboard(),
        ],
      ),
    );
  }
}

var _displayState = new DisplayState();

class Display extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _displayState;
  }
}

class DisplayState extends State<Display> {
  var _expression = '';
  var _result = '';

  @override
  Widget build(BuildContext context) {
    var views = <Widget>[
      new Expanded(
          flex: 1,
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Text(
                _expression,
                textAlign: TextAlign.right,
                style: new TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ))
            ],
          )),
    ];

    if (_result.isNotEmpty) {
      views.add(
        new Expanded(
            flex: 1,
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text(
                  _result,
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ))
              ],
            )),
      );
    }

    return new Expanded(
        flex: 2,
        child: new Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(16.0),
          child: new Column(
            children: views,
          ),
        ));
  }
}

void _addKey(String key) {
  var _expr = _displayState._expression;
  var _result = '';
  if (_displayState._result.isNotEmpty) {
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
  } else if (key == '=') {
    try {
      var parser = const Parser();
      _result = parser.parseExpression(_expr).toString();
    } on Error {
      _result = 'Error';
    }
  }
  // ignore: invalid_use_of_protected_member
  _displayState.setState(() {
    _displayState._expression = _expr;
    _displayState._result = _result;
  });
}

class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        flex: 4,
        child: new Center(
            child: new AspectRatio(
          aspectRatio: 1.0,
          child: new GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: <String>[
              // @formatter:off
              '7', '8', '9', '/',
              '4', '5', '6', '*',
              '1', '2', '3', '-',
              'C', '0', '=', '+',
              // @formatter:on
            ].map((key) {
              return new GridTile(
                child: new KeyboardKey(key),
              );
            }).toList(),
          ),
        )));
  }
}

class KeyboardKey extends StatelessWidget {
  KeyboardKey(this._keyValue);

  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(
        _keyValue,
        style: new TextStyle(
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
var operators = <String>['+', '-', '*', '/'];

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
    Queue<String> operators = new ListQueue<String>();
    Queue<num> operands = new ListQueue<num>();

    bool lastDig = true;

    // INIT
    operands.addLast(0);

    expr.split('').forEach((String c) {
      if (_isDigit(c)) {
        if (lastDig) {
          num last = operands.removeLast();
          operands.addLast(last * 10 + int.parse(c));
        } else
          operands.addLast(int.parse(c));
      } else if (_isOperator(c)) {
        if (!lastDig) throw new ArgumentError('Illegal expression');

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
      num op1 = operands.removeLast();
      num op2 = operands.removeLast();
      String op = operators.removeLast();

      num res = _eval(op2, op1, op);
      operands.addLast(res);
    }

    return operands.removeLast();
  }
}
