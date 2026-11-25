import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/features/product_entry/sku_entry.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A combo's SKU and bar code, styled like the rest of the product editor.
///
/// The bar code is validated by the editor's own [Form] (there is no nested
/// form here), so Save stays blocked while it is empty.
/// Upper-cases a SKU as it is typed, on any keyboard.
final skuUpperCaseFormatter = TextInputFormatter.withFunction(
  (oldValue, newValue) => newValue.copyWith(
    text: newValue.text.toUpperCase(),
    selection: newValue.selection,
  ),
);

class Fieldcompositeactivated extends StatefulHookConsumerWidget {
  const Fieldcompositeactivated({
    Key? key,
    required this.barCodeController,
    required this.skuController,
  }) : super(key: key);

  final TextEditingController barCodeController;
  final TextEditingController skuController;

  @override
  FieldcompositeactivatedState createState() => FieldcompositeactivatedState();
}

class FieldcompositeactivatedState
    extends ConsumerState<Fieldcompositeactivated> {
  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();
    final l10n = context.flipperL10n;

    if (branchId == null) {
      return Center(child: Text(l10n.noBranchSelected));
    }

    return Row(
      // Top-aligned: the SKU's hint line must not push the bar code down.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // Optional: blank means a SKU is assigned on save. The placeholder
          // shows the next one without taking it.
          child: PeField(
            label: 'SKU',
            optional: true,
            hint: l10n.skuAutoHelper,
            child: PeTextInput(
              controller: widget.skuController,
              placeholder: skuFieldHint(
                l10n,
                skuPreviewFor(businessId: businessId ?? ''),
              ),
              mono: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              // The capitalization above is only a soft-keyboard hint; a
              // hardware keyboard on the desk types lowercase.
              inputFormatters: [skuUpperCaseFormatter],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PeField(
            label: l10n.compositeBarcode,
            required: true,
            child: PeTextInput(
              controller: widget.barCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.compositeBarcodeRequired;
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
