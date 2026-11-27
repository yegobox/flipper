import 'package:flutter/widgets.dart';

/// What a combo save writes, read from the form once, right after it
/// validates. The save then awaits (the SKU check, each component write), and
/// the inputs stay editable meanwhile, so reading them again later could write
/// a price the form never validated (unparseable text became 0).
typedef ComboSaveValues = ({
  String name,
  double retailPrice,
  double supplyPrice,
  // The price fields as typed, for an edit's "did the price change" check
  // (see editedPrice), taken in the same snapshot as the parsed prices.
  String retailText,
  String supplyText,
  String sku,
  String barcode,
  String countryOfOrigin,
});

/// Takes the [ComboSaveValues] snapshot. Call it before the save's first
/// `await`.
ComboSaveValues readComboSaveValues({
  required TextEditingController name,
  required TextEditingController retailPrice,
  required TextEditingController supplyPrice,
  required TextEditingController sku,
  required TextEditingController barcode,
  required TextEditingController countryOfOrigin,
}) {
  return (
    name: name.text,
    retailPrice: double.tryParse(retailPrice.text) ?? 0,
    supplyPrice: double.tryParse(supplyPrice.text) ?? 0,
    retailText: retailPrice.text,
    supplyText: supplyPrice.text,
    sku: sku.text.trim(),
    barcode: barcode.text,
    countryOfOrigin: countryOfOrigin.text.isEmpty ? 'RW' : countryOfOrigin.text,
  );
}
