import 'package:flipper_dashboard/features/kitchen_display/kitchen_stage.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_card.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Touch screens drag on long-press, so a swipe still scrolls the column; a
/// mouse drags straight away.
bool get _dragOnLongPress =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

class OrderColumn extends StatelessWidget {
  final KitchenStage stage;
  final List<KitchenOrderView> orders;
  final void Function(String transactionId, KitchenStage from, KitchenStage to)
  onOrderMoved;
  final void Function(KitchenOrderView view, DateTime dueDate) onSetDueDate;

  /// Clears an order off the display. Offered on Ready cards, and on any card
  /// whose ticket is gone so it can never get stuck.
  final void Function(KitchenOrderView view) onServed;

  const OrderColumn({
    Key? key,
    required this.stage,
    required this.orders,
    required this.onOrderMoved,
    required this.onSetDueDate,
    required this.onServed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = stage.color;
    return DragTarget<KitchenDragData>(
      // Dropping a card back on its own column is not a move.
      onWillAcceptWithDetails: (details) => details.data.from != stage,
      onAcceptWithDetails: (details) {
        onOrderMoved(details.data.transactionId, details.data.from, stage);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return Container(
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: isHovered ? color.withValues(alpha: 0.08) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHovered ? color : Colors.grey[300]!,
              width: isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stage.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${orders.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: orders.isEmpty
                    ? Center(
                        child: Text(
                          'No orders',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: orders.length,
                        // Keyed by ticket so a Ditto emit that reorders or
                        // shrinks the column never hands a card (or a drag in
                        // flight) to a different order.
                        findChildIndexCallback: (key) {
                          final id = (key as ValueKey<String>).value;
                          final i = orders.indexWhere(
                            (o) => o.order.transactionId == id,
                          );
                          return i < 0 ? null : i;
                        },
                        itemBuilder: (context, index) =>
                            _buildDraggable(context, orders[index]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggable(BuildContext context, KitchenOrderView view) {
    final id = view.order.transactionId;
    final data = KitchenDragData(transactionId: id, from: stage);
    OrderCard card() => OrderCard(
      view: view,
      stage: stage,
      borderColor: stage.color,
      onSetDueDate: (dueDate) => onSetDueDate(view, dueDate),
      onServed: stage == KitchenStage.ready || view.ticket == null
          ? () => onServed(view)
          : null,
    );
    final feedback = Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.35,
          minWidth: 250,
        ),
        child: card(),
      ),
    );
    final whileDragging = Opacity(opacity: 0.5, child: card());

    if (_dragOnLongPress) {
      return LongPressDraggable<KitchenDragData>(
        key: ValueKey<String>(id),
        data: data,
        feedback: feedback,
        childWhenDragging: whileDragging,
        child: card(),
      );
    }
    return Draggable<KitchenDragData>(
      key: ValueKey<String>(id),
      data: data,
      feedback: feedback,
      childWhenDragging: whileDragging,
      child: card(),
    );
  }
}
