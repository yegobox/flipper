import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/open_close_drawerview.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/viewmodels/open_business_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


void shouldSeeItemOnly(BuildContext context, Product product) {
  final FlipperNavigationService _navigationService =
      ProxyService.nav;

  StoreProvider.of<AppState>(context).dispatch(
    CurrentActiveSaleProduct(
      product: product,
    ),
  );
  _navigationService.navigateTo(
    Routing.viewSingleItem,
    arguments: ViewSingleItemScreenArguments(
      productId: product.id,
      itemName: product.name,
      itemColor: product.color,
    ),
  );
}

Future<bool> onWillPop() async {
  Routing.navigator.pop(true);
  return true;
}

// ignore: always_declare_return_types

