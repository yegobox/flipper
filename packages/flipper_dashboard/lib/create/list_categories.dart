import 'dart:developer';

import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'divider.dart';

class ListCategories extends StatelessWidget {
  ListCategories({Key? key, required this.categories}) : super(key: key);
  final List<Category>? categories;
  final _routerService = locator<RouterService>();
  Wrap categoryList(
      {required List<Category> categories,
      required BuildContext context,
      required ProductViewModel model}) {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name != 'custom') {
        list.add(
          GestureDetector(
            onTap: () {
              model.updateCategory(category: categories[i]);
            },
            child: SingleChildScrollView(
              child: ListTile(
                title: Text(
                  categories[i].name,
                  style: const TextStyle(color: Colors.black),
                ),
                trailing: Radio<String>(
                  value: categories[i].id,
                  //This radio button is considered selected if its value matches the groupValue.
                  groupValue:
                      categories[i].focused == true ? categories[i].id : '0',
                  onChanged: (value) {
                    model.updateCategory(category: categories[i]);
                  },
                ),
              ),
            ),
          ),
        );
      }
      list.add(const Center(
        child: SizedBox(
          width: double.infinity,
          child: CenterDivider(
            width: double.infinity,
          ),
        ),
      ));
    }
    return Wrap(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              log('back');
              _routerService.back();
            },
            showActionButton: false,
            title: 'Category',
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: FutureBuilder<List<Category>>(
              future: ProxyService.isar
                  .categories(branchId: ProxyService.box.getBranchId()!),
              builder: (context, snapshot) {
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        log("on tap");
                        _routerService.navigateTo(AddCategoryRoute());
                      },
                      child: ListTile(
                        title: Text('Create Category ',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400)),
                        trailing: Wrap(
                          children: const <Widget>[
                            Icon(FluentIcons.arrow_forward_20_regular),
                          ],
                        ),
                      ),
                    ),
                    categoryList(
                      categories: snapshot.data ?? [],
                      context: context,
                      model: model,
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}
