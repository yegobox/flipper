import 'dart:developer';

import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked/stacked.dart';

class ListCategories extends StatefulHookConsumerWidget {
  ListCategories({Key? key, required this.modeOfOperation}) : super(key: key);
  final String? modeOfOperation;

  @override
  ListCategoriesState createState() => ListCategoriesState();
}

class ListCategoriesState extends ConsumerState<ListCategories> {
  final _routerService = locator<RouterService>();
  String? _selectedCategoryId;

  Widget buildCategoryItem({
    required Category category,
    required BuildContext context,
    required String groupValue,
    required CoreViewModel model,
  }) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedCategoryId = category.id.toString();
        });
        setState(() {});
        log("Category name: ${category.name}");
      },
      child: ListTile(
        title: Text(
          category.name!,
          style: const TextStyle(color: Colors.black),
        ),
        trailing: Radio<String>(
          value: category.id.toString(),
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
            model.updateCategory(category: category);

            log("Category name Selectd: ${category.name}");
          },
        ),
      ),
    );
  }

  Widget buildCategoryList({
    required List<Category> categories,
    required BuildContext context,
    required Future<void> Function(Category) onTap,
    required String groupValue,
    required CoreViewModel model,
  }) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: categories.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (categories[index].name == 'custom') {
          return const SizedBox.shrink();
        }
        return buildCategoryItem(
          category: categories[index],
          context: context,
          model: model,
          groupValue: groupValue,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModelBuilder = widget.modeOfOperation == 'product'
        ? ViewModelBuilder<CoreViewModel>.reactive(
            viewModelBuilder: () => CoreViewModel(),
            builder: (context, model, child) {
              return buildScaffold(
                model: model,
                context: context,
                future: ProxyService.realm
                    .categories(branchId: ProxyService.box.getBranchId()!),
                onTapCategory: (category) async {
                  final categories = await ProxyService.realm
                      .categories(branchId: ProxyService.box.getBranchId()!);
                  for (var cat in categories) {
                    cat.focused = false;
                    model.updateCategory(category: cat);
                  }
                  category.focused = true;
                  model.updateCategory(category: category);
                },
                groupValueBuilder: (category) =>
                    _selectedCategoryId ??
                    (category.focused ? category.id.toString() : '0'),
              );
            },
          )
        : ViewModelBuilder<CoreViewModel>.reactive(
            viewModelBuilder: () => CoreViewModel(),
            builder: (context, model, child) {
              return buildScaffold(
                model: model,
                context: context,
                future: ProxyService.realm
                    .categories(branchId: ProxyService.box.getBranchId()!),
                onTapCategory: (category) async {
                  final categories = await ProxyService.realm
                      .categories(branchId: ProxyService.box.getBranchId()!);
                  for (var cat in categories) {
                    cat.focused = false;
                    model.updateCategory(category: cat);
                  }
                  category.focused = true;
                  model.updateCategory(category: category);
                },
                groupValueBuilder: (category) =>
                    _selectedCategoryId ??
                    (category.focused ? category.id.toString() : '0'),
              );
            },
          );

    return viewModelBuilder;
  }

  Scaffold buildScaffold({
    required BuildContext context,
    required Future<List<Category>> future,
    required Future<void> Function(Category) onTapCategory,
    required String Function(Category) groupValueBuilder,
    required CoreViewModel model,
  }) {
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
        bottomSpacer: 80,
      ),
      body: FutureBuilder<List<Category>>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    log("on tap");
                    _routerService.navigateTo(AddCategoryRoute());
                  },
                  child: ListTile(
                    title: Text(
                      'Create Category',
                    ),
                    trailing: Wrap(
                      children: const <Widget>[
                        Icon(FluentIcons.arrow_forward_20_regular),
                      ],
                    ),
                  ),
                ),
                buildCategoryList(
                  categories: snapshot.data ?? [],
                  model: model,
                  context: context,
                  onTap: onTapCategory,
                  groupValue: _selectedCategoryId ?? '',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
