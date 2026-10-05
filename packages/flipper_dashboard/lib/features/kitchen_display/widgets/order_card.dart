import 'dart:async';

import 'package:flipper_dashboard/features/kitchen_display/kitchen_stage.dart';
import 'package:flipper_dashboard/features/kitchen_display/providers/transaction_items_provider.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OrderCard extends HookConsumerWidget {
  /// The kitchen order and its ticket. The stage shown is [stage], which may
  /// be a pending drag the stream has not echoed yet.
  final KitchenOrderView view;
  final KitchenStage stage;
  final Color borderColor;

  /// Persists a new due date on the kitchen order. Null hides the button.
  final ValueChanged<DateTime>? onSetDueDate;

  /// Clears the order off the display. Null hides the button.
  final VoidCallback? onServed;

  const OrderCard({
    Key? key,
    required this.view,
    required this.stage,
    required this.borderColor,
    this.onSetDueDate,
    this.onServed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final ticket = view.ticket;
    final dueDate = view.order.dueDate;
    final isExpanded = useState(false);
    final minutesRemaining = useState<int?>(null);

    useEffect(() {
      Timer? timer;
      void updateMinutesRemaining() {
        minutesRemaining.value = dueDate?.difference(DateTime.now()).inMinutes;
      }

      updateMinutesRemaining();
      if (dueDate != null && stage != KitchenStage.incoming) {
        timer = Timer.periodic(const Duration(minutes: 1), (_) {
          updateMinutesRemaining();
        });
      }
      return () => timer?.cancel();
    }, [dueDate, stage]);

    // When it reached the kitchen, not when the cart was opened.
    final sentAt = view.order.sentAt ?? ticket?.createdAt;
    final sentAtLabel = sentAt == null
        ? l10n.ticketUnknown
        : DateFormat('HH:mm').format(sentAt.toLocal());

    final canSetDueDate =
        stage == KitchenStage.incoming && onSetDueDate != null;
    final showDueDateChip = stage != KitchenStage.incoming && dueDate != null;
    final isPaid = ticket?.status == COMPLETE;

    final transactionItemsAsync = ref.watch(
      kitchenTicketItemsProvider(
        kitchenTicketItemsKey(view.order.transactionId, ticket),
      ),
    );
    // A new revision is a new provider instance, so it starts out loading;
    // keep painting the last lines meanwhile instead of flashing a spinner.
    final lastItems = useRef<List<TransactionItem>?>(null);
    if (transactionItemsAsync.hasValue) {
      lastItems.value = transactionItemsAsync.value;
    }

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: InkWell(
        onTap: () => isExpanded.value = !isExpanded.value,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.kitchenOrderNumber(_orderNumber(view)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    sentAtLabel,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  if (showDueDateChip)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Chip(
                        avatar: const Icon(
                          Icons.timer,
                          size: 16,
                          color: Colors.deepPurple,
                        ),
                        label: Text(
                          minutesRemaining.value == null
                              ? ''
                              : minutesRemaining.value! < 0
                              ? l10n.ticketOverdue
                              : l10n.ticketMinutesLeft(
                                  '${minutesRemaining.value!}',
                                ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.deepPurple,
                          ),
                        ),
                        backgroundColor: Colors.deepPurple.withValues(
                          alpha: 0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  if (canSetDueDate)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit_calendar,
                          color: Colors.blue,
                        ),
                        tooltip: l10n.kitchenSetDueDate,
                        onPressed: () async {
                          final picked = await showDialog<Duration>(
                            context: context,
                            builder: (_) => const _DueInDialog(),
                          );
                          if (picked != null) {
                            onSetDueDate!(DateTime.now().toUtc().add(picked));
                          }
                        },
                      ),
                    ),
                ],
              ),

              if (ticket == null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.kitchenTicketNotFound,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),

              if (ticket?.ticketName case final name? when name.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.kitchenTicketName(name),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              if (ticket != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.kitchenCustomerLine(
                    ticket.customerName ?? l10n.ticketWalkInCustomer,
                  ),
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.kitchenTotalLine(
                    '${ticket.subTotal?.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],

              if (ticket?.note case final note? when note.isNotEmpty)
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
                        Text(
                          l10n.kitchenNoteLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          note,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              Row(
                children: [
                  _Tag(
                    label: stage.labelOf(l10n),
                    foreground: borderColor,
                    background: borderColor.withValues(alpha: 0.2),
                    bold: true,
                  ),
                  if (isPaid) ...[
                    const SizedBox(width: 8),
                    _Tag(
                      label: l10n.ticketStatusPaid,
                      foreground: Colors.green.shade800,
                      background: Colors.green.withValues(alpha: 0.15),
                      bold: true,
                    ),
                  ],
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

              // Own full-width row: squeezed into the tag row it overflowed a
              // 300px column, and taps on the overflowing part (most of the
              // button) were outside the row's bounds, so Served did nothing.
              if (onServed != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: ValueKey(
                        'kitchen_served_${view.order.transactionId}',
                      ),
                      onPressed: onServed,
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(l10n.kitchenStageServed),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),

              if (isExpanded.value)
                (transactionItemsAsync.isLoading && lastItems.value != null
                        ? AsyncValue.data(lastItems.value!)
                        : transactionItemsAsync)
                    .when(
                      data: (items) {
                        if (items.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              l10n.kitchenNoItemsFound,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                l10n.kitchenItemsLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            for (final item in items)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${item.qty}x',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                                .defaultCurrency(),
                                          ) ??
                                          '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (error, stack) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          l10n.kitchenErrorLoadingItems(error.toString()),
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

  static String _orderNumber(KitchenOrderView view) {
    final number = view.ticket?.transactionNumber;
    if (number != null && number.isNotEmpty) return number;
    final id = view.order.transactionId;
    return id.length > 8 ? id.substring(0, 8) : id;
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.foreground,
    required this.background,
    this.bold = false,
  });

  final String label;
  final Color foreground;
  final Color background;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// "Due in N minutes" picker. A plain StatefulWidget: the old version called
/// `useState` inside a dialog builder, which is not a hook context.
class _DueInDialog extends StatefulWidget {
  const _DueInDialog();

  @override
  State<_DueInDialog> createState() => _DueInDialogState();
}

class _DueInDialogState extends State<_DueInDialog> {
  var _selected = const Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: _selected.inMinutes.toDouble(),
            min: 5,
            max: 240,
            divisions: 47,
            label: l10n.kitchenMinutesCount(_selected.inMinutes),
            onChanged: (val) {
              setState(() => _selected = Duration(minutes: val.round()));
            },
          ),
          Text(l10n.kitchenDueInMinutes(_selected.inMinutes)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: Text(l10n.kitchenSetAction),
        ),
      ],
    );
  }
}
