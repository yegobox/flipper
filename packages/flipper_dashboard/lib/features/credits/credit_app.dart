import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/credit_data.dart';
import 'screens/credit_home_page.dart';

/// Main entry point for the Credits feature
class CreditApp extends StatelessWidget {
  const CreditApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreditData(),
      child: const CreditHomePage(),
    );
  }
}
