
import 'package:flipper/views/welcome/payable/payable_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';


class KeyPadButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
          return Wrap(
            // alignment: Alignment.center,
            children: _buildButtons(model.showButton),
          );
        },
        viewModelBuilder: () => PayableViewModel());
  }

  List<Widget> _buildButtons(bool showButton) {
    final List<int> list = <int>[];
    // ignore: always_specify_types
    // define keys for keypad exclude C and +

    list.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
    final List<Widget> widget = <Widget>[];

    for (int i = 1; i < list.length; i++) {
      widget.add(
        SingleKey(
          buttonKeyName: i.toString(),
        ),
      );
    }
    widget.add(const SingleKey(
      buttonKeyName: '0',
    ));
    widget.add(const SingleKey(
      buttonKeyName: 'C',
    ));
    if (showButton) {
      widget.add(const SingleKey(
        buttonKeyName: '+',
      ));
    }

    return widget;
  }
}

class SingleKey extends StatelessWidget {
  const SingleKey({
    Key key,
    @required this.buttonKeyName,
    this.temp,
    this.sum,
    this.flag,
    this.count,
    this.sumString,
    this.permanentSum,
    this.permanentSumString,
    this.temp1,
    this.temp2,
  }) : super(key: key);

  final String buttonKeyName;

  final double sum;

  final bool flag;

  final int count;

  final String sumString;

  final double temp;

  final double permanentSum;

  final String permanentSumString;

  final double temp1;

  final double temp2;

  void btnClicked({
    String buttonKeyName,
    BuildContext context,
    PayableViewModel model,
  }) async {
    HapticFeedback.vibrate();
    if (buttonKeyName == 'C') {
      // StoreProvider.of<AppState>(context).dispatch(CleanKeyPad());
      return model.onClearPad();
    }
    if (buttonKeyName == '+') {
      model.onPlusButtonClicked();
    } else {
      model.normalKeypad();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
          return Container(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 100.99,
                height: 80.0,
                child: InkWell(
                  enableFeedback: false,
                  onTap: () => {
                    btnClicked(
                        buttonKeyName: buttonKeyName,
                        context: context,
                        model: model),
                    model.totalString(stringButton: buttonKeyName)
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        width: 0.0,
                      ),
                    ),
                    // padding: const EdgeInsets.fromLTRB(55, 21, 20, 20),
                    child: Center(
                      child: Text(
                        buttonKeyName.toString(),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 40, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => PayableViewModel());
  }
}
