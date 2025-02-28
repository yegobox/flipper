import 'package:flipper_dashboard/PurchaseTable.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/proxy.dart';
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
  final void Function(
      {required List<Variant> variants,
      required String pchsSttsCd}) acceptPurchases;
  final void Function(
    Variant? itemToAssign,
    Variant? itemFromPurchase,
  ) selectSale;
  final List<Variant> finalSalesList;

  Purchases({
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptPurchases,
    required this.selectSale,
    required this.finalSalesList,
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
                  FlipperButton(
                    onPressed: () {
                      widget.acceptPurchases(
                          variants: widget.finalSalesList, pchsSttsCd: '02');
                    },
                    text: 'Accept All Purchases',
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Supplier name: JALO PARTERS"),
                  ),
                  PurchaseTable(
                    nameController: widget.nameController,
                    supplyPriceController: widget.supplyPriceController,
                    retailPriceController: widget.retailPriceController,
                    saveItemName: widget.saveItemName,
                    acceptPurchases:
                        (List<Variant> variants, pchsSttsCd) async {
                      widget.acceptPurchases(
                          variants: variants, pchsSttsCd: pchsSttsCd);
                      // Refresh the product list
                      // Refresh the product list
                      ref
                          .read(searchStringProvider.notifier)
                          .emitString(value: "search");
                      ref
                          .read(searchStringProvider.notifier)
                          .emitString(value: "");

                      await ref
                          .read(
                              productsProvider(ProxyService.box.getBranchId()!)
                                  .notifier)
                          .loadProducts(searchString: "", scanMode: true);
                    },
                    selectSale: (itemToAssign, itemFromPurchase) =>
                        widget.selectSale(itemToAssign, itemFromPurchase),
                    finalSalesList: widget.finalSalesList,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
