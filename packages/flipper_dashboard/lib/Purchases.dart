import 'package:flipper_dashboard/PurchaseTable.dart';
import 'package:flipper_ui/flipper_ui.dart';
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
      {required List<Variant> variants,
      required String pchsSttsCd,
      required Purchase purchase}) acceptPurchases;
  final void Function(
    Variant? itemToAssign,
    Variant? itemFromPurchase,
  ) selectSale;
  final List<Variant> variants;
  final List<Purchase> purchases;

  Purchases({
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
    return Container(
      height: 400,
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.variants.isEmpty
                      ? const SizedBox.shrink()
                      : FlipperButton(
                          onPressed: () async {
                            await widget.acceptPurchases(
                                variants: widget.variants,
                                pchsSttsCd: '02',
                                purchase: widget.purchases.first);
                            showToast(context, "You Accepted all purchaes");
                          },
                          text: 'Accept All Purchases',
                          textColor: Colors.black,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
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
        ),
      ),
    );
  }
}
