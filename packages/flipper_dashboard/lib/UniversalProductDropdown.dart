import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';

class UniversalProductDropdown extends StatelessWidget {
  final BuildContext context;
  final ScannViewModel model;
  final Variant variant;
  final AsyncValue<List<UnversalProduct>>? universalProducts;

  const UniversalProductDropdown({
    Key? key,
    required this.context,
    required this.model,
    required this.variant,
    required this.universalProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return universalProducts?.when(
          data: (items) {
            final List<String> itemClsCdList = items
                .map((unit) => ((unit.itemClsNm ?? "") + " " + unit.itemClsCd!))
                .toList();

            return Container(
              width: double.infinity,
              child: DropdownSearch<String>(
                items: (a, b) => itemClsCdList,
                compareFn: (String i, String s) => i == s,
                selectedItem:
                    itemClsCdList.isNotEmpty ? itemClsCdList.first : null,
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                  ),
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    for (var scannedVariant in model.scannedVariants) {
                      if (scannedVariant.id == variant.id) {
                        final value = newValue.split(' ').last;
                        scannedVariant.itemClsCd = value;
                        break;
                      }
                    }
                  }
                },
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        ) ??
        const SizedBox.shrink();
  }
}
