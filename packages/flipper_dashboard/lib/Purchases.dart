import 'package:flipper_dashboard/PurchaseTable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class Purchases extends StatefulHookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveItemName;
  final Future<void> Function(
      {required List<Purchase> purchases,
      required String pchsSttsCd,
      required Purchase purchase,
      Variant? clickedVariant}) acceptPurchases;
  final void Function(
    Variant? itemToAssign,
    Variant? itemFromPurchase,
  ) selectSale;
  final List<Variant> variants;
  final List<Purchase> purchases;

  Purchases({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptPurchases,
    required this.selectSale,
    required this.variants,
    required this.purchases,
  });

  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends ConsumerState<Purchases> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Purchase table - takes remaining space
        Flexible(
          fit: FlexFit.loose,
          child: PurchaseTable(
            purchases: widget.purchases,
            nameController: widget.nameController,
            supplyPriceController: widget.supplyPriceController,
            retailPriceController: widget.retailPriceController,
            saveItemName: widget.saveItemName,
            acceptPurchases: widget.acceptPurchases,
            selectSale: widget.selectSale,
            variants: widget.variants,
          ),
        ),
      ],
    );
  }
}
