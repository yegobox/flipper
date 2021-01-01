import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/widget/atoms/unit_viewmodel.dart';
import 'package:flipper/model/unit.dart';

class SectionSelectUnit extends StatelessWidget {
  const SectionSelectUnit({Key key}) : super(key: key);
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
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, UnitViewModel model, Widget child) {
          return Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  ProxyService.nav.navigateTo(
                    Routing.addUnitType,
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.4),
                  dense: true,
                  leading: const Text(
                    'Unit Type',
                  ),
                  trailing: model.units.isNotEmpty
                      ? Wrap(
                          children: [
                            unitSelector(model.units),
                            Theme(
                                data: ThemeData(
                                  iconTheme: const IconThemeData(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Icon(Icons.arrow_forward_ios))
                          ],
                        )
                      : const Text(
                          'Select Unit',
                        ),
                ),
              ),
            ),
          );
        },
        onModelReady: (UnitViewModel model) {
          model.loadUnits();
        },
        viewModelBuilder: () => UnitViewModel());
  }
}
