import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/shop/shop_pages.dart' deferred as shop;
import 'package:flutter/material.dart';

/// Storefront page kinds, mirrored here so the router does not have to
/// import the deferred library to name one.
enum ShopRoute { catalog, checkout, order }

/// `/shop/...`: a business's public online shop. No sign-in.
///
/// The storefront is a deferred import (like `/pos`): a separate JS part
/// fetched on first open, so it costs Books nothing at startup and a
/// customer does not download Books' screens to see the shop.
class ShopRoutePage extends StatefulWidget {
  const ShopRoutePage({
    super.key,
    required this.route,
    required this.slug,
    this.orderId,
    this.token,
  });

  final ShopRoute route;
  final String slug;
  final String? orderId;
  final String? token;

  @override
  State<ShopRoutePage> createState() => _ShopRoutePageState();
}

class _ShopRoutePageState extends State<ShopRoutePage> {
  late Future<void> _loaded = shop.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loaded,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => setState(() => _loaded = shop.loadLibrary()),
                child: Text(context.flipperL10n.retry),
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return shop.buildShopPage(
          kind: shop.ShopPageKind.values[widget.route.index],
          slug: widget.slug,
          orderId: widget.orderId,
          token: widget.token,
        );
      },
    );
  }
}
