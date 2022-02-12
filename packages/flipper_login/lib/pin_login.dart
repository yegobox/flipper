import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Pin extends StatelessWidget {
  const Pin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPop: () async {
          GoRouter.of(context).pop();
        },
        title: 'Create Product',
        disableButton: false,
        showActionButton: true,
      ),
      body: Text("PIN page"),
    );
  }
}
