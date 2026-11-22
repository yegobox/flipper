import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/features/product_entry/sku_entry.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Fieldcompositeactivated extends StatefulHookConsumerWidget {
  const Fieldcompositeactivated({
    Key? key,
    required this.barCodeController,
    required this.skuController,
    required this.formKey,
  }) : super(key: key);

  final TextEditingController barCodeController;
  final TextEditingController skuController;
  final GlobalKey<FormState> formKey;

  @override
  FieldcompositeactivatedState createState() => FieldcompositeactivatedState();
}

class FieldcompositeactivatedState
    extends ConsumerState<Fieldcompositeactivated> {
  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();

    if (branchId == null) {
      return Center(child: Text(context.flipperL10n.noBranchSelected));
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              // Optional: blank means a SKU is assigned on save. The hint
              // shows the next one without taking it.
              child: SkuTextField(
                controller: widget.skuController,
                preview: skuPreviewFor(businessId: businessId ?? ''),
                decorate: (base) => base.copyWith(
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: widget.barCodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.flipperL10n.compositeBarcodeRequired;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: context.flipperL10n.compositeBarcode,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
