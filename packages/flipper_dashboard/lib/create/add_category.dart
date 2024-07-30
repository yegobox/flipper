import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class AddCategory extends StatelessWidget {
  AddCategory({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () => _routerService.back(),
            title: 'Create Category',
            icon: Icons.arrow_back_ios,
            multi: 3,
            bottomSpacer: 80,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter Category Name',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    onChanged: (value) => model.setCategoryName(name: value),
                    decoration: InputDecoration(
                      hintText: 'Category Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BoxButton(
                    onTap: () async {
                      await model.createCategory();
                      _routerService.back();
                    },
                    title: 'Create Category',
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
