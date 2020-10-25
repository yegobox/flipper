
import 'package:flipper/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'payable_viewmodel.dart';

class BuildPayable extends StatelessWidget {
  const BuildPayable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
          if(model.isBusy)
            return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  color: Theme.of(context)
                      .copyWith(canvasColor: AppColors.darkBlue)
                      .canvasColor,
                  onPressed:(){
                     model.nvaigate();
                  },
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              'Charge  ',
                            ),
                            Text(model.payable.text)
                          ],
                        ),
                      )
                    ],
                  ))
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
