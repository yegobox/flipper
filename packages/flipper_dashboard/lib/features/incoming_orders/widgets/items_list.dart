// ignore_for_file: unused_result

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/providers/incoming_orders_provider.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemsList extends HookConsumerWidget
    with StockRequestApprovalLogic, SnackBarMixin {
  final InventoryRequest request;
  final bool isIncoming;

  const ItemsList({Key? key, required this.request, this.isIncoming = true})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync =
        request.transactionItems != null && request.transactionItems!.isNotEmpty
            ? AsyncValue.data(request.transactionItems!)
            : ref.watch(transactionItemsProvider(request.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ITEMS',
          style: OmTokens.text(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: OmTokens.muted,
            letterSpacing: 0.05 * 12,
          ),
        ),
        const SizedBox(height: 10),
        itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No items in this request',
                  style: OmTokens.text(color: OmTokens.muted),
                ),
              );
            }
            final sorted = [...items]
              ..sort((a, b) => (a.name).compareTo(b.name));
            return Column(
              children: [
                for (var i = 0; i < sorted.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _ItemRow(
                    item: sorted[i],
                    request: request,
                    isIncoming: isIncoming,
                    onUpdate: (item, qty) =>
                        _handleUpdate(context, ref, item, qty),
                  ),
                ],
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (error, _) => Text(
            'Error loading items: $error',
            style: OmTokens.text(color: OmTokens.red),
          ),
        ),
      ],
    );
  }

  void _handleUpdate(
    BuildContext context,
    WidgetRef ref,
    TransactionItem item,
    double quantity,
  ) {
    try {
      updateRequestedQuantity(
        request: request,
        item: item,
        newQuantity: quantity.toInt(),
        context: context,
      );

      final stringValue = ref.read(stringProvider);
      final search = stringValue?.isNotEmpty == true ? stringValue : null;
      ref.refresh(
        stockRequestsProvider(status: RequestStatus.pending, search: search),
      );
      ref.refresh(
        outgoingStockRequestsProvider(
          status: RequestStatus.pending,
          search: search,
        ),
      );
    } catch (e) {
      showCustomSnackBar(
        context,
        'Failed to update item: ${e.toString()}',
        backgroundColor: OmTokens.red,
      );
    }
  }
}

class _ItemRow extends HookConsumerWidget {
  final TransactionItem item;
  final InventoryRequest request;
  final bool isIncoming;
  final void Function(TransactionItem, double) onUpdate;

  const _ItemRow({
    required this.item,
    required this.request,
    required this.isIncoming,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBulkMode = ref.watch(
      selectionProvider.select((s) => s.isNotEmpty),
    );
    final isEditing = useState(false);
    final canEditOutgoing = !isIncoming &&
        request.status == RequestStatus.pending &&
        !isBulkMode;
    final quantityController = useTextEditingController(
      text: '${item.quantityRequested ?? 0}',
    );

    useEffect(() {
      if (!isEditing.value) {
        quantityController.text = '${item.quantityRequested ?? 0}';
      }
      return null;
    }, [isEditing.value, item.quantityRequested]);

    final isOutgoingPending =
        !isIncoming && request.status == RequestStatus.pending;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        border: Border.all(color: OmTokens.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: OmTokens.text(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                if (isEditing.value && canEditOutgoing)
                  Row(
                    children: [
                      Text(
                        'Update Qty: ',
                        style: OmTokens.text(
                          fontSize: 13,
                          color: OmTokens.muted,
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          style: OmTokens.text(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(OmTokens.radiusXs),
                              borderSide:
                                  const BorderSide(color: OmTokens.line2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text.rich(
                    TextSpan(
                      style: OmTokens.text(
                        fontSize: 13,
                        color: OmTokens.muted,
                      ),
                      children: isOutgoingPending
                          ? [
                              const TextSpan(text: 'Requested: '),
                              TextSpan(
                                text: '${item.quantityRequested ?? 0}',
                                style: OmTokens.text(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: OmTokens.redStrong,
                                ),
                              ),
                            ]
                          : [
                              const TextSpan(text: 'Approved: '),
                              TextSpan(
                                text:
                                    '${item.quantityApproved ?? 0}/${item.quantityRequested ?? 0}',
                                style: OmTokens.text(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: OmTokens.greenStrong,
                                ),
                              ),
                            ],
                    ),
                  ),
              ],
            ),
          ),
          if (canEditOutgoing) ...[
            const SizedBox(width: 8),
            Material(
              color: OmTokens.surface,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                onTap: () => isEditing.value = !isEditing.value,
                borderRadius: BorderRadius.circular(9),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: OmTokens.line2),
                  ),
                  child: Icon(
                    isEditing.value ? Icons.close : Icons.edit_outlined,
                    size: 17,
                    color: OmTokens.accentStrong,
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                final qty = double.tryParse(quantityController.text) ?? 0;
                onUpdate(item, qty);
                isEditing.value = false;
              },
              icon: const Icon(Icons.save_outlined, size: 17),
              label: Text(
                'Update',
                style: OmTokens.text(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: OmTokens.accentStrong,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: OmTokens.accentStrong,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
