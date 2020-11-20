import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/views/welcome/payable/payable_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PayableView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
        
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width:MediaQuery.of(context).size.width -20,
                height:60,
                child: FlatButton(
                  color: Theme.of(context)
                      .copyWith(canvasColor: HexColor('#2996CC'))
                      .canvasColor,
                  onPressed: () {
                    model.nvaigate();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Charge  ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.white)),
                      Text(
                        model.payable.text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
        onModelReady: (PayableViewModel model) {
          model.getOrder();
          model.initFields();
        },
        viewModelBuilder: () => PayableViewModel());
  }
}
