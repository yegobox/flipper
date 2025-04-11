import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/bulk_product_form.dart';

class BulkAddProduct extends StatefulHookConsumerWidget {
  const BulkAddProduct({super.key});

  @override
  BulkAddProductState createState() => BulkAddProductState();
}

class BulkAddProductState extends ConsumerState<BulkAddProduct> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: BulkProductForm(),
      ),
    );
  }
}
