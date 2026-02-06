import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'work_order_form.dart';

/// Mobile-optimized bottom sheet for creating/editing work orders
///
/// Uses WoltModalSheet to provide a smooth, native-feeling bottom sheet
/// experience on mobile devices, following the pattern from bottomSheet.dart
class WorkOrderBottomSheet {
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required Future<void> Function(Map<String, dynamic>) onSubmit,
    String? workOrderId,
    String? initialVariantId,
    String? initialVariantName,
    double? initialPlannedQuantity,
  }) {
    WoltModalSheet.show<void>(
      context: context,
      barrierDismissible: true,
      enableDrag: true,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            isTopBarLayerAlwaysVisible: false,
            hasSabGradient: false,
            hasTopBarLayer: false,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  _buildHeader(context, workOrderId),
                  Divider(height: 1, color: Colors.grey[200]),
                  // Content - scrollable form
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: WorkOrderForm(
                        workOrderId: workOrderId,
                        initialVariantId: initialVariantId,
                        initialVariantName: initialVariantName,
                        initialPlannedQuantity: initialPlannedQuantity,
                        onSubmit: (data) async {
                          await onSubmit(data);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  static Widget _buildHeader(BuildContext context, String? workOrderId) {
    final isEdit = workOrderId != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isEdit ? Icons.edit_outlined : Icons.add_circle_outline,
              color: Colors.blue,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              isEdit ? 'Edit Work Order' : 'Create Work Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
