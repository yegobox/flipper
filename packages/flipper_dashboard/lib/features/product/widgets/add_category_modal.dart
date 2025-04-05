import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/db_model_export.dart';

class AddCategoryModal extends StatelessWidget {
  const AddCategoryModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Category',
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
                    Navigator.of(context).pop();
                  },
                  title: 'Create Category',
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

Future<void> showAddCategoryModal(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => const AddCategoryModal(),
  );
}
