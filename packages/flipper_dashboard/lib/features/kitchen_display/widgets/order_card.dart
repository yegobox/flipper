import 'dart:async';

import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/providers/transaction_items_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OrderCard extends HookConsumerWidget {
  final ITransaction order;
  final Color borderColor;
  final OrderStatus status;
  final VoidCallback? onTap;

  const OrderCard({
    Key? key,
    required this.order,
    required this.borderColor,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final minutesRemaining = useState<int?>(null);

    // Timer setup using useEffect
    useEffect(() {
      Timer? timer;

      void updateMinutesRemaining() {
        if (order.dueDate != null) {
          final now = DateTime.now().toUtc();
          final diff = order.dueDate!.toLocal().difference(now.toLocal());
          minutesRemaining.value = diff.inMinutes;
        } else {
          minutesRemaining.value = null;
        }
      }

      void setupTimer() {
        updateMinutesRemaining();
        timer?.cancel();
        if (order.dueDate != null && status != OrderStatus.incoming) {
          timer = Timer.periodic(const Duration(minutes: 1), (_) {
            updateMinutesRemaining();
          });
        }
      }

      setupTimer();
      return () => timer?.cancel();
    }, [order.dueDate, status]);

    // Format created time
    String createdAt = 'Unknown';
    if (order.createdAt != null) {
      try {
        createdAt = DateFormat('HH:mm').format(order.createdAt!);
      } catch (e) {
        createdAt = order.createdAt.toString();
      }
    }

    // Only allow setting due date for orders in the incoming column
    bool canSetDueDate = status == OrderStatus.incoming;

    // Show due date chip for non-incoming columns if due date exists
    final bool showDueDateChip =
        status != OrderStatus.incoming && order.dueDate != null;

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
          isExpanded.value = !isExpanded.value;
          if (onTap != null) {
            onTap!();
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
                  // Show minutes remaining chip for non-incoming columns
                  if (showDueDateChip)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Chip(
                        avatar: const Icon(Icons.timer,
                            size: 16, color: Colors.deepPurple),
                        label: Text(
                          minutesRemaining.value == null
                              ? ''
                              : minutesRemaining.value! < 0
                                  ? 'Overdue'
                                  : '${minutesRemaining.value!} min left',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.deepPurple,
                          ),
                        ),
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  // Show set due date button if allowed
                  if (canSetDueDate)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon:
                            const Icon(Icons.edit_calendar, color: Colors.blue),
                        tooltip: 'Set Due Date',
                        onPressed: () async {
                          final picked = await showDialog<Duration>(
                            context: context,
                            builder: (context) {
                              final selected =
                                  useState(const Duration(minutes: 30));
                              return AlertDialog(
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Slider(
                                          value: selected.value.inMinutes
                                              .toDouble(),
                                          min: 5,
                                          max: 240,
                                          divisions: 47,
                                          label:
                                              '${selected.value.inMinutes} minutes',
                                          onChanged: (val) {
                                            setState(() {
                                              selected.value = Duration(
                                                  minutes: val.round());
                                            });
                                          },
                                        ),
                                        Text(
                                            'Due in ${selected.value.inMinutes} minutes'),
                                      ],
                                    );
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context)
                                        .pop(selected.value),
                                    child: const Text('Set'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (picked != null) {
                            order.dueDate = DateTime.now().toUtc().add(picked);
                            // Force a rebuild to show the new due date
                            // This is a bit of a hack, but it works for now
                            // ignore: invalid_use_of_protected_member
                            (context as Element).reassemble();
                          }
                        },
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
                'Total: ${order.subTotal?.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
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
                      isExpanded.value ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      isExpanded.value = !isExpanded.value;
                    },
                  ),
                ],
              ),

              // Expanded section with transaction items
              if (isExpanded.value)
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
                                    item.totAmt?.toCurrencyFormatted(
                                            symbol: ProxyService.box
                                                .defaultCurrency()) ??
                                        '',
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
