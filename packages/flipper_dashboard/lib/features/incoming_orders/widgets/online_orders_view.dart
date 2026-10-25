import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/online_order_card.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_order_accept.dart';
import 'package:flipper_models/online_shop/online_order_ticket.dart';
import 'package:flipper_models/online_shop/online_orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Incoming Orders → Online: orders from the public shop, newest first.
class OnlineOrdersView extends ConsumerStatefulWidget {
  const OnlineOrdersView({super.key, required this.padding});

  final EdgeInsets padding;

  @override
  ConsumerState<OnlineOrdersView> createState() => _OnlineOrdersViewState();
}

class _OnlineOrdersViewState extends ConsumerState<OnlineOrdersView> {
  final Set<String> _busy = {};

  Future<bool> _confirm(String message) async {
    final l10n = context.flipperL10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: OmTokens.accentStrong,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.onlineOrderConfirm),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _run(
    OnlineOrder order,
    Future<String?> Function() task, {
    String? confirm,
  }) async {
    if (confirm != null && !await _confirm(confirm)) return;
    if (!mounted) return;
    final l10n = context.flipperL10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy.add(order.id));
    try {
      final message = await task();
      if (message != null) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.onlineOrderActionFailed('$e'))),
      );
    } finally {
      if (mounted) setState(() => _busy.remove(order.id));
    }
  }

  void _onAction(OnlineOrder order, OnlineOrderAction action) {
    final l10n = context.flipperL10n;
    final client = ref.read(onlineShopClientProvider);
    final branchId = ref.read(onlineShopBranchIdProvider);
    if (action == OnlineOrderAction.accept) {
      _run(order, () async {
        final writer = _writer();
        await acceptOnlineOrder(
          client: client,
          writer: writer,
          branchId: branchId,
          order: order,
          paidNote: l10n.onlineOrderTicketPaidNote,
        );
        return l10n.onlineOrderAccepted(order.ticketName);
      });
      return;
    }
    _run(
      order,
      () async {
        await client.updateOrder(
          branchId: branchId,
          orderId: order.id,
          action: action,
          smsId: action == OnlineOrderAction.confirmPayment
              ? order.suggestedPayment?.smsId
              : null,
        );
        return null;
      },
      confirm: switch (action) {
        OnlineOrderAction.reject => l10n.onlineOrderRejectConfirm,
        OnlineOrderAction.markPaid => l10n.onlineOrderMarkPaidConfirm,
        _ => null,
      },
    );
  }

  void _createTicket(OnlineOrder order) {
    final l10n = context.flipperL10n;
    final client = ref.read(onlineShopClientProvider);
    final branchId = ref.read(onlineShopBranchIdProvider);
    _run(order, () async {
      await createOnlineOrderTicket(
        client: client,
        writer: _writer(),
        branchId: branchId,
        order: order,
        paidNote: l10n.onlineOrderTicketPaidNote,
      );
      return l10n.onlineOrderAccepted(order.ticketName);
    });
  }

  OnlineOrderTicketWriter _writer() {
    final writer = ref.read(onlineOrderTicketWriterProvider);
    if (writer == null) throw StateError('Sync is still starting');
    return writer;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final branchId = ref.watch(onlineShopBranchIdProvider);
    // Keeps the new-order alerts running while the tab is open.
    ref.watch(newOnlineOrdersCountProvider);
    final orders = ref.watch(onlineOrdersProvider(branchId));
    return orders.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          l10n.onlineOrderActionFailed('$e'),
          style: OmTokens.text(color: OmTokens.red),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return ListView(
            padding: widget.padding,
            children: [_Empty(l10n: l10n)],
          );
        }
        return ListView.separated(
          padding: widget.padding,
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final order = list[i];
            return OnlineOrderCard(
              key: ValueKey(order.id),
              order: order,
              busy: _busy.contains(order.id),
              onAction: (action) => _onAction(order, action),
              onCreateTicket: () => _createTicket(order),
            );
          },
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.l10n});

  final FlipperAppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(color: OmTokens.line2, width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 28,
            color: OmTokens.faint,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onlineOrdersEmpty,
            style: OmTokens.text(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.onlineOrdersEmptyHint,
            textAlign: TextAlign.center,
            style: OmTokens.text(fontSize: 14, color: OmTokens.muted),
          ),
        ],
      ),
    );
  }
}
