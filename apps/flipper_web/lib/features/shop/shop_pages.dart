/// The storefront, loaded deferred by [ShopRoutePage] so Books' startup
/// bundle does not carry it. Import this library only `deferred as`.
library;

import 'package:flipper_web/features/shop/shop_catalog_page.dart';
import 'package:flipper_web/features/shop/shop_checkout_page.dart';
import 'package:flipper_web/features/shop/shop_order_page.dart';
import 'package:flutter/widgets.dart';

/// Which storefront page a `/shop/...` route shows.
enum ShopPageKind { catalog, checkout, order }

Widget buildShopPage({
  required ShopPageKind kind,
  required String slug,
  String? orderId,
  String? token,
}) => switch (kind) {
  ShopPageKind.catalog => ShopCatalogPage(slug: slug),
  ShopPageKind.checkout => ShopCheckoutPage(slug: slug),
  ShopPageKind.order => ShopOrderPage(
    slug: slug,
    orderId: orderId ?? '',
    token: token,
  ),
};
