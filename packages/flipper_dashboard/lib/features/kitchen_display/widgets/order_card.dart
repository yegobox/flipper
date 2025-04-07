import 'package:flipper_dashboard/features/kitchen_display/providers/transaction_items_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderCard extends ConsumerStatefulWidget {
  final ITransaction order;
  final Color borderColor;
  final VoidCallback? onTap;

  const OrderCard({
    Key? key,
    required this.order,
    required this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final borderColor = widget.borderColor;

    // Format created time
    String createdAt = 'Unknown';
    if (order.createdAt != null) {
      try {
        createdAt = DateFormat('HH:mm').format(order.createdAt!);
      } catch (e) {
        createdAt = order.createdAt.toString();
      }
    }

    // Get transaction items asynchronously
    final transactionItemsAsync = ref.watch(transactionItemsProvider(order.id));

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header with ID and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.transactionNumber ?? order.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    createdAt,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Ticket name if available
              if (order.ticketName != null && order.ticketName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Ticket: ${order.ticketName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const SizedBox(height: 8),

              // Customer info
              Text(
                'Customer: ${order.customerName ?? 'Walk-in Customer'}',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Total amount
              Text(
                'Total: ${order.subTotal?.toRwf()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),

              // Note if available
              if (order.note != null && order.note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Note:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.note!,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Status and payment type
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: borderColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.status ?? 'Unknown',
                      style: TextStyle(
                        color: borderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (order.paymentType != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.paymentType!,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),

              // Expanded section with transaction items
              if (_isExpanded)
                transactionItemsAsync.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'No items found',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'Items:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    '${item.qty}x',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    item.totAmt?.toRwf() ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Error loading items: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
