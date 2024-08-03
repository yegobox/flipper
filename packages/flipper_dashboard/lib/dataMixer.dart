// ignore_for_file: unused_result

import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:stacked_services/stacked_services.dart';

mixin Datamixer<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Widget buildVariantRow({
    required BuildContext context,
    required ProductViewModel model,
    required Variant variant,
    required bool isOrdering,
  }) {
    final stockStream = ref.watch(stockByVariantIdProvider(variant.id ?? 0));

    return stockStream.when(
      data: (double stock) {
        return buildRowItem(
            context: context,
            model: model,
            variant: variant,

            /// when we are ordering we have no way knowing the stock from supplier
            /// nor we care in this case, we just place order and wait for supplier to fullfill it.
            stock: isOrdering ? 0.0 : stock,
            isOrdering: isOrdering);
      },
      error: (dynamic error, stackTrace) => SizedBox.shrink(),
      loading: () =>
          SizedBox(width: 20, height: 20, child: const SizedBox.shrink()),
    );
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  Future<void> deleteFunc(int? productId, ProductViewModel model) async {
    try {
      /// first if there is image attached delete if first
      Product? product = ProxyService.realm.getProduct(id: productId!);
      if (product!.isComposite!) {
        /// search composite and delete them as well
        List<Composite> composites =
            ProxyService.realm.composites(productId: productId);
        ProxyService.realm.realm!.write(() {
          for (Composite composite in composites) {
            ProxyService.realm.realm!.delete(composite);
          }
        });
      }
      if (product.imageUrl != null) {
        if (await ProxyService.realm
            .removeS3File(fileName: product.imageUrl!)) {
          await model.deleteProduct(productId: productId);
          ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));

          /// delete assets related to a product
          Assets? asset =
              ProxyService.realm.getAsset(assetName: product.imageUrl!);
          ProxyService.realm.delete(id: asset?.id ?? 0);
        }
      } else {
        await model.deleteProduct(productId: productId);
        ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
      }
    } catch (e, s) {
      talker.error("ProductViewClass:" + s.toString());
      talker.error("ProductViewClass:" + e.toString());
      ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
    }
  }

  Widget buildRowItem(
      {required BuildContext context,
      required ProductViewModel model,
      required Variant variant,
      required double stock,
      required bool isOrdering}) {
    Product? product;
    if (!isOrdering) {
      product = ProxyService.realm.getProduct(id: variant.productId ?? 0);
    }
    Assets? asset = ProxyService.realm.getAsset(productId: variant.productId);

    return RowItem(
      isOrdering: isOrdering,
      color: variant.color ?? "#673AB7",
      stock: stock,
      model: model,
      variant: variant,
      productName: variant.productName ?? "",
      variantName: variant.name ?? "",
      imageUrl: asset?.assetName,
      isComposite: !isOrdering ? product?.isComposite ?? false : false,
      orderItem: (int productId) {
        // ref.read(cartListProvider.notifier).addToCart(variant);
        // ref.refresh(cartListProvider);

        /// add item to the cart, as user start ordering items.
      },
      edit: (productId, type) {
        talker.info("navigating to Edit!");
        if (_getDeviceType(context) != "Phone") {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => OptionModal(
              child: ProductEntryScreen(productId: productId),
            ),
          );
        } else {
          locator<RouterService>().navigateTo(
            AddProductViewRoute(productId: productId),
          );
        }
      },
      delete: (productId, type) async {
        await deleteFunc(productId, model);
      },
      enableNfc: (product) {
        // Handle NFC functionality
      },
    );
  }
}
