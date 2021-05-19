import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AfterSale extends StatelessWidget {
  const AfterSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(body: Text('hello I am after sale'));
      },
      viewModelBuilder: () => BusinessHomeViewModel(),
    );
  }
}
