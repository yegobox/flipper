import 'package:flutter/material.dart';
import 'package:flipper/wrapper.dart';
import 'package:flipper_finance/app.dart' deferred as finance;
import 'package:flipper/deferred_widget.dart';

class FinanceApp extends StatelessWidget {
  const FinanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      study: DeferredWidget(finance.loadLibrary,
          () => finance.RallyApp(), // ignore: prefer_const_constructors
          placeholder: DeferredLoadingPlaceholder(name: 'Finance')),
    );
  }
}
