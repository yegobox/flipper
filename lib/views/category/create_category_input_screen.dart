import 'package:customappbar/customappbar.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';


class CreateCategoryInputScreen extends StatelessWidget {
  const CreateCategoryInputScreen({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
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
                onChanged: (String name)async  {
                  // TODO: re-do this the first implementation was poor and confusing.
                  // final Document document =  await CoreDB.instance.database.document(vm.tempCategoryId);
                  // _databaseService.update(document: document.toMutable().setString('updatedAt', DateTime.now().toIso8601String()).setString('name', name));
                },
                decoration: const InputDecoration(
                    hintText: 'Name', focusColor: Colors.blue),
              ),
            ),
          ),
        );
  }
}
