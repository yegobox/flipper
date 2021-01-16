import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

void dispatchCurrentProductVariants(
    BuildContext context, List<Variation> variants, Product product) {
  StoreProvider.of<AppState>(context)
      .dispatch(ItemsVariation(variations: variants));

  StoreProvider.of<AppState>(context).dispatch(
    CurrentActiveSaleProduct(product: product),
  );
}

void clear({BuildContext context}) {
  StoreProvider.of<AppState>(context).dispatch(CleanVariation());
  StoreProvider.of<AppState>(context).dispatch(CleanAppActions());
  StoreProvider.of<AppState>(context).dispatch(CleanCurrentColor());
}
