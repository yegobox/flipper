import 'package:customappbar/customappbar.dart';
import 'package:flipper_models/view_models/add_product_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateCategoryInputScreen extends StatelessWidget {
  CreateCategoryInputScreen({Key key}) : super(key: key);
  final TextEditingController _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder: (BuildContext context, AddProductViewmodel model, Widget child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              model.createCategory(name: _name.text);
              ProxyService.nav.pop();
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
                controller: _name,
                decoration: const InputDecoration(
                    hintText: 'Name', focusColor: Colors.blue),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => AddProductViewmodel(),
    );
  }
}
