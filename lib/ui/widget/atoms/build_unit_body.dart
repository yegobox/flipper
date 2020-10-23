import 'package:flipper/ui/widget/atoms/unit_viewmodel.dart';
import 'package:flipper/model/unit.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BuildUnitBody extends StatelessWidget {
  const BuildUnitBody({Key key}) : super(key: key);
  Text unitSelector(List<Unit> units) {
    Text text;
    for (Unit unit in units) {
      if (unit.focused) {
        text = Text(unit.name);
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.nonReactive(
        builder: (BuildContext context, UnitViewModel model, Widget child) {
          return model.data == null || model.busy
              ? const Text(
                  'Select Unit',
                )
              : unitSelector(model.data);
        },
        viewModelBuilder: () => UnitViewModel());
  }
}
