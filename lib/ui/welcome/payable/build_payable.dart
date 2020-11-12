import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/utils/HexColor.dart';

import 'payable_viewmodel.dart';

class BuildPayable extends StatelessWidget {
  const BuildPayable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
          if (model.isBusy) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Theme.of(context)
                    .copyWith(canvasColor: HexColor('#2996CC'))
                    .canvasColor,
                onPressed: () {
                  model.nvaigate();
                },
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                    )
                  ],
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
