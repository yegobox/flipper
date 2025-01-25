import 'package:flipper_dashboard/product_view.dart';
import 'package:flutter/material.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProductView.normalMode(),
    );
  }
}
