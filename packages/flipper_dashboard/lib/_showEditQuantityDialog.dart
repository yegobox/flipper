import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flipper_ui/flipper_ui.dart';

void showEditQuantityDialog(
  BuildContext context,
  Variant variant,
  ScannViewModel model,
  VoidCallback onDialogClosed,
) {
  final TextEditingController quantityController = TextEditingController(
    text: variant.stock?.currentStock.toString(),
  );

  final double currentStock = (variant.stock?.currentStock ?? 0.0).toDouble();

  WoltModalSheet.show<void>(
    context: context,
    onModalDismissedWithBarrierTap: onDialogClosed,
    pageListBuilder: (BuildContext context) {
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          isTopBarLayerAlwaysVisible: false,
          hasTopBarLayer: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              void updateQty(double delta) {
                double currentVal =
                    double.tryParse(quantityController.text) ?? 0;
                double newVal = currentVal + delta;
                if (newVal >= currentStock) {
                  quantityController.text = newVal.toString();
                  setState(() {});
                } else {
                  toast("Cannot reduce below current stock ($currentStock)");
                }
              }

              return Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Edit Quantity',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                variant.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onDialogClosed();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildQtyButton(
                          icon: Icons.remove,
                          onPressed: () => updateQty(-1),
                          color: Colors.redAccent,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: quantityController,
                              textAlign: TextAlign.center,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                        ),
                        _buildQtyButton(
                          icon: Icons.add,
                          onPressed: () => updateQty(1),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FlipperButton(
                        onPressed: () {
                          if (variant.itemTyCd == "3") {
                            model.updateVariantQuantity(variant.id, 0.0);
                            toast("Services do not have stock");
                            onDialogClosed();
                            Navigator.pop(context);
                            return;
                          }

                          double? newQty = double.tryParse(
                            quantityController.text,
                          );
                          if (newQty == null) {
                            toast("Please enter a valid quantity");
                            return;
                          }

                          if (newQty < currentStock) {
                            toast(
                              "Quantity cannot be reduced below current stock ($currentStock)",
                            );
                            return;
                          }

                          model.updateVariantQuantity(variant.id, newQty);
                          onDialogClosed();
                          Navigator.pop(context);
                        },
                        text: 'Update Stock',
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ];
    },
  );
}

Widget _buildQtyButton({
  required IconData icon,
  required VoidCallback onPressed,
  required Color color,
}) {
  return Material(
    color: color.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 28),
      ),
    ),
  );
}
