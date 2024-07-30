import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';

class ListCategories extends StatefulHookConsumerWidget {
  const ListCategories({Key? key, required this.modeOfOperation})
      : super(key: key);
  final String? modeOfOperation;

  @override
  ListCategoriesState createState() => ListCategoriesState();
}

class ListCategoriesState extends ConsumerState<ListCategories> {
  final _routerService = locator<RouterService>();
  String? _selectedCategoryId;

  Widget buildCategoryItem({
    required Category category,
    required CoreViewModel model,
    required String groupValue,
  }) {
    final isSelected = category.id.toString() == groupValue;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedCategoryId = category.id.toString();
          });
          model.updateCategory(category: category);
          log("Category selected: ${category.name}");
        },
        title: Text(
          category.name!,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Radio<String>(
          value: category.id.toString(),
          groupValue: groupValue,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
            model.updateCategory(category: category);
          },
        ),
        tileColor:
            isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryList({
    required List<Category> categories,
    required CoreViewModel model,
    required String groupValue,
  }) {
    return ListView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (categories[index].name == 'custom') {
          return const SizedBox.shrink();
        }
        return buildCategoryItem(
          category: categories[index],
          model: model,
          groupValue: groupValue,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              log('back');
              _routerService.back();
            },
            showActionButton: false,
            title: 'Categories',
            icon: Icons.arrow_back_ios,
            multi: 3,
            bottomSpacer: 80,
          ),
          body: FutureBuilder<List<Category>>(
            future: ProxyService.realm
                .categories(branchId: ProxyService.box.getBranchId()!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        onTap: () =>
                            _routerService.navigateTo(AddCategoryRoute()),
                        title: const Text('Create Category',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(FluentIcons.add_24_regular),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildCategoryList(
                      categories: snapshot.data ?? [],
                      model: model,
                      groupValue: _selectedCategoryId ?? '',
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
