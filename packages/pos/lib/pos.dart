library pos;

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'pos_viewmodel.dart';

class KeyPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PosViewModel>.reactive(
      builder: (BuildContext context, PosViewModel model, Widget child) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Display(
                model: model,
              ),
              Keyboard(model: model),
            ],
          ),
        );
      },
      viewModelBuilder: () => PosViewModel(),
    );
  }
}

class Display extends StatelessWidget {
  const Display({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    final views = <Widget>[
      Expanded(
        flex: 1,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              model.expression,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ))
          ],
        ),
      ),
    ];

    if (model.result.isNotEmpty) {
      views.add(
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                model.result,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ))
            ],
          ),
        ),
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
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard({Key key, this.model}) : super(key: key);
  final PosViewModel model;
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
                  child: KeyboardKey(key, model),
                );
              }).toList(),
            ),
          ))),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  const KeyboardKey(this._keyValue, this.model);
  final PosViewModel model;
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
        model.addKey(_keyValue);
      },
    );
  }
}

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
}
