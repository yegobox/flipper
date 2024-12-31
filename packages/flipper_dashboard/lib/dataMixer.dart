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

mixin Datamixer<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Widget buildVariantRow({
    required BuildContext context,
    required ProductViewModel model,
    required Variant variant,
    required bool isOrdering,
    required bool forceRemoteUrl,
  }) {
    return FutureBuilder<Widget>(
      future: buildRowItem(
          forceRemoteUrl: forceRemoteUrl,
          context: context,
          model: model,
          variant: variant,
          stock: isOrdering ? 0.0 : variant.stock?.currentStock ?? 0.0,
          isOrdering: isOrdering),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ?? SizedBox.shrink();
        } else {
          return Text('...Loading');
        }
      },
    );
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  Future<void> deleteFunc(String? productId, ProductViewModel model) async {
    try {
      /// first if there is image attached delete if first
      Product? product = await ProxyService.strategy.getProduct(
          businessId: ProxyService.box.getBusinessId()!,
          id: productId!,
          branchId: ProxyService.box.getBranchId()!);
      if (product?.isComposite ?? false) {
        /// search composite and delete them as well
        List<Composite> composites =
            await ProxyService.strategy.composites(productId: productId);

        for (Composite composite in composites) {
          ProxyService.strategy.delete(
              id: composite.id,
              endPoint: 'composite',
              flipperHttpClient: ProxyService.http);
        }
      }
      if (product != null && product.imageUrl != null) {
        if (await ProxyService.strategy
            .removeS3File(fileName: product.imageUrl!)) {
          await model.deleteProduct(productId: productId);
          ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));

          /// delete assets related to a product
          Assets? asset = await ProxyService.strategy
              .getAsset(assetName: product.imageUrl!);
          ProxyService.strategy.delete(
              id: asset?.id ?? "", flipperHttpClient: ProxyService.http);
        }
      } else {
        await model.deleteProduct(productId: productId);
        ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
      }
    } catch (e) {
      ref.refresh(outerVariantsProvider(ProxyService.box.getBranchId()!));
    }
  }

  Future<Widget> buildRowItem(
      {required BuildContext context,
      required ProductViewModel model,
      required Variant variant,
      required double stock,
      required bool forceRemoteUrl,
      required bool isOrdering}) async {
    Product? product;
    if (!isOrdering) {
      product = await ProxyService.strategy.getProduct(
          businessId: ProxyService.box.getBusinessId()!,
          id: variant.productId ?? "",
          branchId: ProxyService.box.getBranchId()!);
    }
    Assets? asset =
        await ProxyService.strategy.getAsset(productId: variant.productId);

    return RowItem(
      forceRemoteUrl: forceRemoteUrl,
      isOrdering: isOrdering,
      color: variant.color ?? "#673AB7",
      stock: stock,
      model: model,
      variant: variant,
      productName: variant.productName ?? "",
      variantName: variant.name,
      imageUrl: asset?.assetName,
      isComposite: !isOrdering
          ? (product != null ? product.isComposite ?? false : false)
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
