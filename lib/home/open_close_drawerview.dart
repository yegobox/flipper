import 'package:flipper/domain/redux/functions.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.blue, width: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              // ignore: always_specify_types
                              boxShadow: [
                                BoxShadow(
                                    color: grey.withOpacity(0.3),
                                    offset: const Offset(2, 1),
                                    blurRadius: 2)
                              ]),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _float,
                            decoration: InputDecoration(
                              // color: Colors.black,
                              
                              icon: const Icon(
                                Icons.monetization_on,
                                color: grey,
                              ),
                              border: InputBorder.none,
                              hintText: businessState == BusinessState.OPEN
                                  ? 'Opening float'
                                  : 'Closing float',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sen',
                                fontSize: 18,
                              ),
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
                            keyboardType: TextInputType.text,
                            controller: _note,
                            decoration: const InputDecoration(
                              // icon: Icon(Icons.pen, color: grey),
                              border: InputBorder.none,
                              hintText: 'Add note',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sen',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 10),
                        SizedBox(
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
                              openBusiness(
                                  model: model,
                                  open: businessState == BusinessState.OPEN
                                      ? true
                                      : false,
                                  vm: vm,
                                  note: _note,
                                  businessState: businessState,
                                  float: _float);
                            },
                            child: Text(
                              businessState == BusinessState.OPEN
                                  ? 'Open'
                                  : 'Close',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
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
