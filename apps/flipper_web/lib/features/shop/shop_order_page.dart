import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_catalog_page.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flipper_web/features/shop/shop_providers.dart';
import 'package:flipper_web/features/shop/shop_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// How often the page asks for news while it is on screen.
const Duration kShopOrderPoll = Duration(seconds: 15);

/// `/shop/:slug/order/:id?t=<token>`: how to pay, and the order's status.
///
/// Polls every [kShopOrderPoll] while the tab is visible and the order can
/// still change. A missing token in the URL falls back to the one this
/// browser saved when it placed the order.
class ShopOrderPage extends ConsumerStatefulWidget {
  const ShopOrderPage({
    super.key,
    required this.slug,
    required this.orderId,
    this.token,
    this.now = DateTime.now,
  });

  final String slug;
  final String orderId;
  final String? token;
  final DateTime Function() now;

  @override
  ConsumerState<ShopOrderPage> createState() => _ShopOrderPageState();
}

class _ShopOrderPageState extends ConsumerState<ShopOrderPage>
    with WidgetsBindingObserver {
  ShopOrderView? _order;
  String? _token;
  Object? _loadError;
  Timer? _poll;
  bool _visible = true;
  final _txn = TextEditingController();
  bool _claiming = false;
  String? _claimError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  Future<void> _start() async {
    var token = widget.token;
    if (token == null || token.isEmpty) {
      final saved = await ref.read(shopStoreProvider).loadOrder(widget.slug);
      if (saved != null && saved.id == widget.orderId) token = saved.token;
    }
    if (!mounted) return;
    _token = token ?? '';
    await _refresh();
    _schedule();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _poll?.cancel();
    _txn.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // On the web, hiding the tab reports hidden/paused; coming back resumed.
    _visible = state == AppLifecycleState.resumed;
    if (_visible) {
      unawaited(_refresh());
      _schedule();
    } else {
      _poll?.cancel();
    }
  }

  void _schedule() {
    _poll?.cancel();
    if (_order?.isFinal ?? false) return;
    _poll = Timer.periodic(kShopOrderPoll, (_) {
      if (_visible) unawaited(_refresh());
    });
  }

  Future<void> _refresh() async {
    try {
      final order = await ref
          .read(shopApiProvider)
          .order(widget.slug, widget.orderId, _token ?? '');
      if (!mounted) return;
      setState(() {
        _order = order;
        _loadError = null;
      });
      if (order.isFinal) {
        _poll?.cancel();
        unawaited(ref.read(shopStoreProvider).clearOrder(widget.slug));
      }
    } catch (e) {
      // Keep showing the last good copy; only an empty page shows the error.
      if (mounted) setState(() => _loadError = e);
    }
  }

  Future<void> _claim() async {
    final l10n = context.flipperL10n;
    final txn = _txn.text.trim();
    if (txn.length < 4) {
      setState(() => _claimError = l10n.shopErrGeneric);
      return;
    }
    setState(() {
      _claiming = true;
      _claimError = null;
    });
    try {
      final order = await ref
          .read(shopApiProvider)
          .claimPayment(
            widget.slug,
            widget.orderId,
            token: _token ?? '',
            transactionId: txn,
          );
      if (mounted) setState(() => _order = order);
    } catch (e) {
      if (mounted) {
        setState(
          () => _claimError = e is ShopApiException && e.offline
              ? l10n.shopErrOffline
              : l10n.shopErrGeneric,
        );
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final order = _order;
    final shop = ref.watch(shopCatalogProvider(widget.slug)).value?.shop;
    return Scaffold(
      backgroundColor: kShopCanvas,
      appBar: AppBar(
        backgroundColor: kShopCanvas,
        surfaceTintColor: Colors.transparent,
        title: Text(
          order == null ? '' : l10n.shopOrderTitle('${order.orderNumber}'),
        ),
        leading: IconButton(
          tooltip: l10n.shopBackToShop,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/shop/${widget.slug}'),
        ),
      ),
      body: order == null
          ? (_loadError == null
                ? const Center(
                    child: CircularProgressIndicator(color: kShopBlue),
                  )
                : ShopMessage(
                    text:
                        _loadError is ShopApiException &&
                            (_loadError as ShopApiException).notFound
                        ? l10n.shopOrderNotFound
                        : l10n.shopLoadFailed,
                    onRetry: _refresh,
                  ))
          : SafeArea(
              child: ShopBody(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    _StatusCard(order: order),
                    const SizedBox(height: 16),
                    if (order.paysByMomo && !order.isPaid && !order.isFinal)
                      ShopPayInstructions(order: order),
                    if (!order.paysByMomo && !order.isFinal)
                      _Note(text: l10n.shopPayOnDelivery),
                    if (order.claimPending)
                      _Note(
                        key: const Key('shop_claim_pending'),
                        text: l10n.shopClaimPending,
                      )
                    else if (order.canClaim(widget.now()))
                      _claimCard(l10n),
                    const SizedBox(height: 16),
                    _Lines(order: order),
                    if (shop != null) _Contact(shop: shop),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _claimCard(FlipperAppLocalizations l10n) {
    return Container(
      key: const Key('shop_claim'),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kShopLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.shopClaimTitle,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('shop_claim_txn'),
            controller: _txn,
            decoration: InputDecoration(
              labelText: l10n.shopClaimHint,
              errorText: _claimError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            style: shopPrimaryButton(),
            onPressed: _claiming ? null : _claim,
            child: Text(l10n.shopClaimSubmit),
          ),
        ],
      ),
    );
  }
}

/// "Dial *182*8*1*12345*4997# and pay exactly 4,997 RWF", with the other
/// ways to pay and why the exact amount matters.
class ShopPayInstructions extends StatelessWidget {
  const ShopPayInstructions({super.key, required this.order});

  final ShopOrderView order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final amount = shopMoney(order.amountDue, order.currency);
    final pay = order.pay;
    final payBy = order.payBy;
    return Container(
      key: const Key('shop_pay'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kShopBlueTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pay.ussd != null) ...[
            Text(
              l10n.shopPayDial,
              style: const TextStyle(fontSize: 15, color: kShopInk),
            ),
            const SizedBox(height: 6),
            InkWell(
              key: const Key('shop_pay_ussd'),
              onTap: () => launchUrl(pay.ussdUri!),
              child: Text(
                pay.ussd!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: kShopBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            l10n.shopPayExactly(amount),
            key: const Key('shop_pay_amount'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kShopInk,
            ),
          ),
          if (pay.momoNumber != null || pay.airtelNumber != null) ...[
            const SizedBox(height: 12),
            Text(
              pay.ussd == null ? l10n.shopPaySendTo : l10n.shopPayOr,
              style: const TextStyle(color: kShopMuted),
            ),
            if (pay.momoNumber != null)
              _PhoneLine(label: l10n.shopPayMomoNumber(pay.momoNumber!)),
            if (pay.airtelNumber != null)
              _PhoneLine(label: l10n.shopPayAirtelNumber(pay.airtelNumber!)),
          ],
          const SizedBox(height: 12),
          Text(
            l10n.shopPayExactWhy,
            style: const TextStyle(fontSize: 13, color: kShopMuted),
          ),
          if (payBy != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.shopPayBy(DateFormat.Hm().format(payBy.toLocal())),
              style: const TextStyle(fontSize: 13, color: kShopMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneLine extends StatelessWidget {
  const _PhoneLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: SelectableText(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, color: kShopInk),
    ),
  );
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.order});

  final ShopOrderView order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final text = switch (order.status) {
      'accepted' => l10n.shopOrderStatusAccepted,
      'ready' => l10n.shopOrderStatusReady,
      'completed' => l10n.shopOrderStatusCompleted,
      'rejected' => l10n.shopOrderStatusRejected,
      'cancelled' => l10n.shopOrderStatusCancelled,
      'expired' => l10n.shopOrderStatusExpired,
      _ => l10n.shopOrderStatusNew,
    };
    return Container(
      key: const Key('shop_order_status'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kShopLine),
      ),
      child: Row(
        children: [
          Icon(
            order.isPaid ? Icons.check_circle : Icons.schedule,
            color: kShopBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (order.isPaid)
                  Text(
                    l10n.shopPaid,
                    key: const Key('shop_paid'),
                    style: const TextStyle(color: kShopMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Lines extends StatelessWidget {
  const _Lines({required this.order});

  final ShopOrderView order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in order.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(child: Text('${shopQty(line.qty)} × ${line.name}')),
                Text(shopMoney(line.lineTotal, order.currency)),
              ],
            ),
          ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.shopTotal,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              shopMoney(order.total, order.currency),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({required this.shop});

  final ShopInfo shop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final whatsapp = shop.whatsapp?.replaceAll(RegExp(r'\D'), '');
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        children: [
          if (whatsapp != null && whatsapp.isNotEmpty)
            OutlinedButton.icon(
              key: const Key('shop_whatsapp'),
              style: OutlinedButton.styleFrom(foregroundColor: kShopBlue),
              onPressed: () => launchUrl(Uri.parse('https://wa.me/$whatsapp')),
              icon: const Icon(Icons.chat_outlined),
              label: Text(l10n.shopWhatsappShop),
            ),
          if (shop.contactPhone != null)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: kShopBlue),
              onPressed: () => launchUrl(shopTelUri(shop.contactPhone!)),
              icon: const Icon(Icons.call_outlined),
              label: Text(l10n.shopCallShop),
            ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kShopLine),
    ),
    child: Text(text),
  );
}
