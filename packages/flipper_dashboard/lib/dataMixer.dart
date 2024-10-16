// ignore_for_file: unused_result

import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'package:flipper_models/realmExtension.dart';
// import 'package:flipper_models/power_sync/schema.dart';

mixin Datamixer<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Widget buildVariantRow({
    required BuildContext context,
    required ProductViewModel model,
    required Variant variant,
    required bool isOrdering,
    required bool forceRemoteUrl,
  }) {
    final stockStream = ref.watch(
        stockByVariantIdProvider(variant.isValid ? (variant.id ?? 0) : 0));

    return stockStream.when(
      data: (double stock) {
        return buildRowItem(
            forceRemoteUrl: forceRemoteUrl,
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
      Product? product = ProxyService.local.getProduct(id: productId!);
      if (product?.isComposite ?? false) {
        /// search composite and delete them as well
        List<Composite> composites =
            ProxyService.local.composites(productId: productId);
        ProxyService.local.realm!.write(() {
          for (Composite composite in composites) {
            ProxyService.local.realm!.delete(composite);
          }
        });
      }
      if (product != null && product.imageUrl != null) {
        if (await ProxyService.local
            .removeS3File(fileName: product.imageUrl!)) {
          await model.deleteProduct(productId: productId);
          ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));

          /// delete assets related to a product
          Assets? asset =
              ProxyService.local.getAsset(assetName: product.imageUrl!);
          ProxyService.local
              .delete(id: asset?.id ?? 0, flipperHttpClient: ProxyService.http);
        }
      } else {
        await model.deleteProduct(productId: productId);
        ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
      }
    } catch (e) {
      ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
    }
  }

  Widget buildRowItem(
      {required BuildContext context,
      required ProductViewModel model,
      required Variant variant,
      required double stock,
      required bool forceRemoteUrl,
      required bool isOrdering}) {
    Product? product;
    if (!isOrdering) {
      product = ProxyService.local
          .getProduct(id: variant.isValid ? (variant.productId ?? 0) : 0);
    }
    Assets? asset = ProxyService.local
        .getAsset(productId: variant.isValid ? variant.productId : 0);
    if (!variant.isValid) {
      return SizedBox.shrink();
    }
    return RowItem(
      forceRemoteUrl: forceRemoteUrl,
      isOrdering: isOrdering,
      color: variant.color ?? "#673AB7",
      stock: stock,
      model: model,
      variant: variant,
      productName: (variant.isValid) ? variant.productName ?? "" : "",
      variantName: variant.name ?? "",
      imageUrl: asset?.assetName,
      isComposite: !isOrdering
          ? (product != null && product.isValid
              ? product.isComposite ?? false
              : false)
          : false,
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
