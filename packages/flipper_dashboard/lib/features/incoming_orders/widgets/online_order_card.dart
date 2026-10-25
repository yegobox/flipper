import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart'
    show formatOnlineMoney;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// One online-shop order in Incoming Orders → Online.
///
/// Pure UI: [onAction] runs the PATCH (and, for accept, parks the ticket).
class OnlineOrderCard extends StatelessWidget {
  const OnlineOrderCard({
    super.key,
    required this.order,
    required this.onAction,
    this.onCreateTicket,
    this.busy = false,
  });

  final OnlineOrder order;
  final ValueChanged<OnlineOrderAction> onAction;

  /// Re-parks the ticket of an accepted order that has none.
  final VoidCallback? onCreateTicket;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final money = (double v) => formatOnlineMoney(v, order.currency);
    final suggestion = order.suggestedPayment;
    final actions = order.availableActions;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line),
        boxShadow: OmTokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.onlineOrderNumber('${order.orderNumber}'),
                  style: OmTokens.text(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _Pill(
                text: _statusLabel(l10n, order.status),
                color: OmTokens.ink2,
                wash: OmTokens.surface3,
              ),
              const SizedBox(width: 6),
              _paymentPill(l10n),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.customerName} · ${order.customerPhone}',
                  style: OmTokens.text(fontSize: 14, color: OmTokens.ink2),
                ),
              ),
              if (order.customerPhone.isNotEmpty) ...[
                IconButton(
                  tooltip: l10n.onlineOrderCall,
                  icon: const Icon(Icons.call_outlined, size: 20),
                  color: OmTokens.accentStrong,
                  onPressed: () =>
                      _launch(Uri.parse('tel:${order.customerPhone}')),
                ),
                IconButton(
                  tooltip: l10n.onlineOrderWhatsapp,
                  icon: const Icon(Icons.chat_outlined, size: 20),
                  color: OmTokens.accentStrong,
                  onPressed: () => _launch(
                    Uri.parse('https://wa.me/${_digits(order.customerPhone)}'),
                  ),
                ),
              ],
            ],
          ),
          Text(
            [
              order.isDelivery
                  ? l10n.onlineOrderDelivery
                  : l10n.onlineOrderPickup,
              if (order.isDelivery &&
                  (order.deliveryAddress ?? '').trim().isNotEmpty)
                order.deliveryAddress!,
            ].join(' · '),
            style: OmTokens.text(fontSize: 13.5, color: OmTokens.muted),
          ),
          if ((order.note ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              order.note!,
              style: OmTokens.text(fontSize: 13.5, color: OmTokens.ink2),
            ),
          ],
          const Divider(height: 24, color: OmTokens.line),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_qty(item.qty)} × ${item.name}',
                      style: OmTokens.text(fontSize: 14),
                    ),
                  ),
                  Text(
                    money(item.lineTotal),
                    style: OmTokens.text(fontSize: 14, color: OmTokens.ink2),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.onlineOrderTotal(money(order.total)),
                  style: OmTokens.text(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (!order.paysOnDelivery && order.amountDue != order.total)
                Text(
                  l10n.onlineOrderAmountDue(money(order.amountDue)),
                  key: const Key('online_order_amount_due'),
                  style: OmTokens.text(fontSize: 13.5, color: OmTokens.ink2),
                ),
            ],
          ),
          if (suggestion != null && !order.isPaid) ...[
            const SizedBox(height: 12),
            Container(
              key: const Key('online_order_suggestion'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OmTokens.amberWash,
                borderRadius: BorderRadius.circular(OmTokens.radiusSm),
              ),
              child: Text(
                l10n.onlineOrderPossiblePayment(
                  money(suggestion.amount),
                  suggestion.counterpartyName ?? '',
                  suggestion.counterpartyTail ?? '',
                ),
                style: OmTokens.text(fontSize: 13.5, color: OmTokens.amber),
              ),
            ),
          ],
          if (actions.isNotEmpty || order.needsTicket) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                if (order.needsTicket && onCreateTicket != null)
                  _button(
                    key: const Key('online_order_create_ticket'),
                    label: l10n.onlineOrderCreateTicket,
                    primary: true,
                    onPressed: onCreateTicket!,
                  ),
                for (final action in actions)
                  _button(
                    key: Key('online_order_${action.wire}'),
                    label: _actionLabel(l10n, action),
                    primary: _primary.contains(action),
                    danger: action == OnlineOrderAction.reject,
                    onPressed: () => onAction(action),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static const _primary = {
    OnlineOrderAction.accept,
    OnlineOrderAction.ready,
    OnlineOrderAction.complete,
    OnlineOrderAction.confirmPayment,
  };

  Widget _button({
    required Key key,
    required String label,
    required VoidCallback onPressed,
    bool primary = false,
    bool danger = false,
  }) {
    final callback = busy ? null : onPressed;
    if (primary) {
      return FilledButton(
        key: key,
        style: FilledButton.styleFrom(backgroundColor: OmTokens.accentStrong),
        onPressed: callback,
        child: Text(label),
      );
    }
    return OutlinedButton(
      key: key,
      style: OutlinedButton.styleFrom(
        foregroundColor: danger ? OmTokens.redStrong : OmTokens.accentStrong,
        side: const BorderSide(color: OmTokens.line2),
      ),
      onPressed: callback,
      child: Text(label),
    );
  }

  Widget _paymentPill(FlipperAppLocalizations l10n) {
    if (order.isPaid) {
      return _Pill(
        key: const Key('online_order_pay_paid'),
        text: l10n.onlineOrderPayPaid,
        color: OmTokens.greenStrong,
        wash: OmTokens.greenWash,
      );
    }
    if (order.paymentStatus == OnlineOrderPaymentStatus.needsReview) {
      return _Pill(
        key: const Key('online_order_pay_review'),
        text: l10n.onlineOrderPayNeedsReview,
        color: OmTokens.amber,
        wash: OmTokens.amberWash,
      );
    }
    return _Pill(
      key: const Key('online_order_pay_unpaid'),
      text: order.paysOnDelivery
          ? l10n.onlineOrderPayOnDelivery
          : l10n.onlineOrderPayUnpaid,
      color: OmTokens.redStrong,
      wash: OmTokens.redWash,
    );
  }

  static String _statusLabel(
    FlipperAppLocalizations l10n,
    OnlineOrderStatus status,
  ) => switch (status) {
    OnlineOrderStatus.newOrder => l10n.onlineOrderStatusNew,
    OnlineOrderStatus.accepted => l10n.onlineOrderStatusAccepted,
    OnlineOrderStatus.rejected => l10n.onlineOrderStatusRejected,
    OnlineOrderStatus.ready => l10n.onlineOrderStatusReady,
    OnlineOrderStatus.completed => l10n.onlineOrderStatusCompleted,
    OnlineOrderStatus.cancelled => l10n.onlineOrderStatusCancelled,
    OnlineOrderStatus.expired => l10n.onlineOrderStatusExpired,
    OnlineOrderStatus.unknown => '—',
  };

  static String _actionLabel(
    FlipperAppLocalizations l10n,
    OnlineOrderAction action,
  ) => switch (action) {
    OnlineOrderAction.accept => l10n.onlineOrderAccept,
    OnlineOrderAction.reject => l10n.onlineOrderReject,
    OnlineOrderAction.ready => l10n.onlineOrderReady,
    OnlineOrderAction.complete => l10n.onlineOrderComplete,
    OnlineOrderAction.confirmPayment => l10n.onlineOrderConfirm,
    OnlineOrderAction.dismissSuggestion => l10n.onlineOrderNotThisOne,
    OnlineOrderAction.markPaid => l10n.onlineOrderMarkPaid,
    OnlineOrderAction.linkTicket => l10n.onlineOrderCreateTicket,
  };

  static String _qty(double qty) =>
      qty == qty.roundToDouble() ? '${qty.toInt()}' : '$qty';

  static String _digits(String phone) => phone.replaceAll(RegExp(r'\D'), '');

  static Future<void> _launch(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // No dialer or browser on this device: nothing to do.
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    super.key,
    required this.text,
    required this.color,
    required this.wash,
  });

  final String text;
  final Color color;
  final Color wash;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: wash,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: OmTokens.text(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
