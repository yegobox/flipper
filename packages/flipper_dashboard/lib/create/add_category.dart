import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/models/models.dart';
import 'package:go_router/go_router.dart';

class AddCategory extends StatelessWidget {
  AddCategory({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () async {
              model.createCategory();
              GoRouter.of(context).pop();
            },
            title: 'Create Category',
            icon: Icons.keyboard_backspace,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                onChanged: (name) {
                  if (name != '') {
                    model.setName(name: name);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Name',
                  focusColor: Colors.blue,
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
