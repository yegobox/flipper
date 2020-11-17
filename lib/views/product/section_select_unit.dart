import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/widget/atoms/build_unit_body.dart';


import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add/add_product_viewmodel.dart';

class SectionSelectUnit extends StatelessWidget {
  const SectionSelectUnit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, AddProductViewmodel model, Widget child) {
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
                  trailing: Wrap(
                    children: [
                      const BuildUnitBody(),
                      Theme(
                          data: ThemeData(
                              iconTheme: const IconThemeData(
                            color: Colors.black,
                          ),),
                          child: const Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        onModelReady: (AddProductViewmodel model){
          model.loadUnits();
        },
        viewModelBuilder: ()=>AddProductViewmodel());
  }
}
