import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/viewmodels/open_business_model.dart';
import 'package:flipper_login/helpers/style.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

enum BusinessState { OPEN, CLOSE }

// ignore: must_be_immutable
class OpenCloseDrawerView extends StatelessWidget {
  OpenCloseDrawerView(
      {Key key, this.vm, this.businessState = BusinessState.OPEN})
      : super(key: key);
  final CommonViewModel vm;
  BusinessState businessState;

  final TextEditingController _note = TextEditingController();
  final TextEditingController _float = TextEditingController();
  static final _textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OpenBusinessModel>.reactive(
      viewModelBuilder: () => OpenBusinessModel(),
      builder: (BuildContext context, OpenBusinessModel model, Widget child) {
        return Scaffold(
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                model.busy
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0,right:18.0 ),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                          controller: _float,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Opening Float',
                            fillColor: Theme.of(context)
                                .copyWith(canvasColor: Colors.white)
                                .canvasColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor('#D0D7E3')),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            suffixIcon: const Icon(Icons.payment),
                          ),
                        ),
                      ),
                      const Divider(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.blue, width: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: grey.withOpacity(0.3),
                                  offset: const Offset(2, 1),
                                  blurRadius: 2)
                            ]),
                        child: TextFormField(
                          key: _textKey,
                          controller: _note,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter Note',
                            fillColor: Theme.of(context)
                                .copyWith(canvasColor: Colors.white)
                                .canvasColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor('#D0D7E3')),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            suffixIcon: const Icon(Icons.book),
                          ),
                        ),
                      ),
                      const Divider(height: 10),
                      Center(
                        child: SizedBox(
                          width: 380,
                          height: 60,
                          child: RaisedButton(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            onPressed: () {
                               model.openBusiness(
                                vm: vm,
                                context: context,
                                float: double.parse(_float.text),
                                businessState: businessState,
                                note:_note.text,
                              );
                            },
                            child: Text(
                              businessState == BusinessState.OPEN
                                  ? 'Open'
                                  : 'Close',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
