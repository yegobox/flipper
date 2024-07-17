import 'package:flipper_dashboard/customappbar.dart';
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
            onPop: () async {
              // If you want to create a category when the user clicks the back button, use the following:
              // await model.createCategory(categoryName: model.categoryName);
              _routerService.back();
            },
            title: 'Create Category',
            icon: Icons.keyboard_backspace,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Added padding for better UI
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Align children to full width
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  onChanged: (name) {
                    model.setCategoryName(
                        name: name); // Update categoryName in view model
                  },
                  decoration: const InputDecoration(
                    hintText: 'Category Name',
                    focusColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24), // Added spacing between fields
                ElevatedButton(
                  onPressed: () async {
                    // Create the category when the button is pressed
                    await model.createCategory();
                    _routerService.back();
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
