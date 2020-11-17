import 'package:customappbar/customappbar.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';

class CreateCategoryInputScreen extends StatefulWidget {
  const CreateCategoryInputScreen({Key key}) : super(key: key);

  @override
  _CreateCategoryInputScreenState createState() =>
      _CreateCategoryInputScreenState();
}

class _CreateCategoryInputScreenState extends State<CreateCategoryInputScreen> {

  final DatabaseService _databaseService = ProxyService.database;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
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
      },
    );
  }
}
