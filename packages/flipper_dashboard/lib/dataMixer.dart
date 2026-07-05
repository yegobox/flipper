// ignore_for_file: unused_result

import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/features/product_entry/product_entry_navigation.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:overlay_support/overlay_support.dart';

// Create cached providers to reduce network requests
final productProvider = FutureProvider.family.autoDispose<Product?, String>((
  ref,
  productId,
) async {
  if (productId.isEmpty) return null;
  return await ProxyService.strategy.getProduct(
    businessId: ProxyService.box.getBusinessId()!,
    id: productId,
    branchId: ProxyService.box.getBranchId()!,
  );
});

final assetProvider = FutureProvider.family.autoDispose<Assets?, String>((
  ref,
  productId,
) async {
  if (productId.isEmpty) return null;
  return await ProxyService.strategy.getAsset(productId: productId);
});

/// Same resolution as mobile edit UI ([DesktopProductAdd] thumbnails): prefer
/// [Variant.imageUrl], else legacy `asset:` prefix in [Variant.addInfo].
String? variantRowImageAssetName(Variant v) {
  final direct = v.imageUrl;
  if (direct != null && direct.isNotEmpty) return direct;
  final raw = v.addInfo;
  if (raw == null || raw.isEmpty) return null;
  return raw.startsWith('asset:') ? raw.substring('asset:'.length) : null;
}

// Then update the mixin
mixin Datamixer<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void _openProductEntry(BuildContext context, {String? productId}) {
    openProductEntryScreen(context, productId: productId);
  }

  Widget buildVariantRow({
    required BuildContext context,
    required ProductViewModel model,
    required Variant variant,
    required bool isOrdering,
    required bool forceRemoteUrl,
    bool forceListView = false,
    bool usePosCatalogTile = false,
    Map<String, Stock?>? stocksById,
  }) {
    final stockId = variant.stockId ?? '';
    return buildRowItem(
      forceRemoteUrl: forceRemoteUrl,
      forceListView: forceListView,
      usePosCatalogTile: usePosCatalogTile,
      context: context,
      model: model,
      variant: variant,
      stock: isOrdering ? 0.0 : variant.stock?.currentStock ?? 0.0,
      isOrdering: isOrdering,
      liveStock: stocksById?[stockId],
    );
  }

  Future<void> deleteFunc(String? variantId, ProductViewModel model) async {
    try {
      /// first if there is image attached delete if first
      final product = await ref.read(productProvider(variantId!).future);
      Variant? variant = await ProxyService.getStrategy(
        Strategy.capella,
      ).getVariant(id: variantId);

      /// Check if the product and variant are valid and if the variant is owned (not shared)
      ///
      bool canDelete = variant?.isShared == false;

      if (canDelete) {
        if (product == null) {
          ProxyService.strategy.flipperDelete(
            id: variantId,
            endPoint: 'variant',
          );
          // Remove the variant from the provider state directly
          ref
              .read(
                outerVariantsProvider(ProxyService.box.getBranchId()!).notifier,
              )
              .removeVariantById(variantId);
          return;
        }
        // If the product is  composite, search and delete related composites
        if ((product.isComposite ?? false)) {
          List<Composite> composites = await ProxyService.strategy.composites(
            variantId: variantId,
          );
          for (Composite composite in composites) {
            await ProxyService.strategy.flipperDelete(
              id: composite.id,
              endPoint: 'composite',
              flipperHttpClient: ProxyService.http,
            );
          }
        }

        // If the product has an associated image, attempt to remove it from S3
        bool imageDeleted =
            product.imageUrl == null ||
            await ProxyService.strategy.removeS3File(
              fileName: product.imageUrl!,
            );

        if (imageDeleted) {
          await model.deleteProduct(productId: product.id);
          // Remove the variant from the provider state directly
          ref
              .read(
                outerVariantsProvider(ProxyService.box.getBranchId()!).notifier,
              )
              .removeVariantById(variantId);

          // Delete associated assets
          if (product.imageUrl != null) {
            Assets? asset = await ProxyService.strategy.getAsset(
              assetName: product.imageUrl!,
            );
            if (asset != null) {
              await ProxyService.strategy.flipperDelete(
                id: asset.id,
                flipperHttpClient: ProxyService.http,
              );
            }
          }
        } else {
          toast("Failed to delete product image. Product deletion aborted.");
        }
      } else {
        toast("Can't be deleted or has been deleted.");
      }
    } catch (e) {
      // Optionally log error
      talker.error('Error deleting variant: $e');
    }
  }

  Widget buildRowItem({
    required BuildContext context,
    required ProductViewModel model,
    required Variant variant,
    required double stock,
    required bool forceRemoteUrl,
    required bool isOrdering,
    bool forceListView = false,
    bool usePosCatalogTile = false,
    Stock? liveStock,
  }) {
    // Product/asset are optional enrichment only. Variant already has name,
    // price, and usually image — never block the row on per-item DB fetches
    // (that caused "15 of 16 products" with shimmer rows still visible).
    final productId = variant.productId ?? '';
    final productAsync = productId.isEmpty
        ? null
        : ref.watch(productProvider(productId));
    if (productAsync?.hasError ?? false) {
      talker.error(
        "Error fetching product data: ${productAsync!.error}",
        productAsync.stackTrace,
      );
    }
    final product = productAsync?.asData?.value;

    final variantImage = variantRowImageAssetName(variant);
    // Only fetch product asset if the variant doesn't have its own image.
    final needsAssetFallback =
        (variantImage == null || variantImage.isEmpty) && productId.isNotEmpty;
    final assetAsync =
        needsAssetFallback ? ref.watch(assetProvider(productId)) : null;
    if (assetAsync?.hasError ?? false) {
      talker.error(
        "Error fetching asset data: ${assetAsync!.error}",
        assetAsync.stackTrace,
      );
    }
    final assetName = assetAsync?.asData?.value?.assetName;

    return RowItem(
      forceRemoteUrl: forceRemoteUrl,
      forceListView: forceListView,
      usePosCatalogTile: usePosCatalogTile,
      isOrdering: isOrdering,
      color: variant.color ?? "#673AB7",
      stock: stock,
      liveStock: liveStock,
      model: model,
      variant: variant,
      product: product,
      productName: variant.productName ?? "Unknown Product",
      variantName: variant.name,
      imageUrl: variantImage ?? assetName,
      isComposite: !isOrdering ? (product?.isComposite ?? false) : false,
      edit: (productId, type) {
        talker.info("navigating to Edit!");
        _openProductEntry(context, productId: productId);
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
