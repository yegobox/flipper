// ignore_for_file: unused_result

import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_dashboard/widgets/variant_shimmer_placeholder.dart';

final productProvider =
    FutureProvider.family<Product?, String>((ref, productId) async {
  if (productId.isEmpty) return null;
  return await ProxyService.strategy.getProduct(
      businessId: ProxyService.box.getBusinessId()!,
      id: productId,
      branchId: ProxyService.box.getBranchId()!);
});

final assetProvider =
    FutureProvider.family<Assets?, String>((ref, productId) async {
  if (productId.isEmpty) return null;
  return await ProxyService.strategy.getAsset(productId: productId);
});

// Then update the mixin
mixin Datamixer<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Widget buildVariantRow({
    required BuildContext context,
    required ProductViewModel model,
    required Variant variant,
    required bool isOrdering,
    required bool forceRemoteUrl,
    bool forceListView = false, // Add parameter with default value
  }) {
    return buildRowItem(
        forceRemoteUrl: forceRemoteUrl,
        forceListView: forceListView, // Pass the parameter
        context: context,
        model: model,
        variant: variant,
        stock: isOrdering ? 0.0 : variant.stock?.currentStock ?? 0.0,
        isOrdering: isOrdering);
  }

  Future<void> deleteFunc(String? productId, ProductViewModel model) async {
    try {
      /// first if there is image attached delete if first
      final product = await ref.read(productProvider(productId!).future);
      Variant? variant =
          await ProxyService.strategy.getVariant(productId: productId);

      /// Check if the product and variant are valid and if the variant is owned (not shared)
      ///
      bool canDelete =
          variant != null && (variant.isShared != null && !variant.isShared!);

      if (canDelete) {
        if (product == null) {
          ProxyService.strategy
              .flipperDelete(id: variant.id, endPoint: 'variant');
          // Remove the variant from the provider state directly
          ref
              .read(outerVariantsProvider(ProxyService.box.getBranchId()!)
                  .notifier)
              .removeVariantById(variant.id);
          return;
        }
        // If the product is  composite, search and delete related composites
        if ((product.isComposite ?? false)) {
          List<Composite> composites =
              await ProxyService.strategy.composites(productId: productId);
          for (Composite composite in composites) {
            await ProxyService.strategy.flipperDelete(
                id: composite.id,
                endPoint: 'composite',
                flipperHttpClient: ProxyService.http);
          }
        }

        // If the product has an associated image, attempt to remove it from S3
        bool imageDeleted = product.imageUrl == null ||
            await ProxyService.strategy
                .removeS3File(fileName: product.imageUrl!);

        if (imageDeleted) {
          await model.deleteProduct(productId: productId);
          // Remove the variant from the provider state directly
          ref
              .read(outerVariantsProvider(ProxyService.box.getBranchId()!)
                  .notifier)
              .removeVariantById(variant.id);

          // Delete associated assets
          if (product.imageUrl != null) {
            Assets? asset = await ProxyService.strategy
                .getAsset(assetName: product.imageUrl!);
            if (asset != null) {
              await ProxyService.strategy.flipperDelete(
                  id: asset.id, flipperHttpClient: ProxyService.http);
            }
          }
        } else {
          toast("Failed to delete product image. Product deletion aborted.");
        }
      } else {
        toast("Can't delete shared product");
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
    bool forceListView = false, // Add parameter with default value
  }) {
    final productAsync = ref.watch(productProvider(variant.productId ?? ""));
    final assetAsync = ref.watch(assetProvider(variant.productId ?? ""));

    return productAsync.when(
      loading: () => const VariantShimmerPlaceholder(),
      error: (err, stack) {
        // Log the error but don't show it to the user
        talker.error("Error fetching product data: $err");
        talker.error(stack);

        // Return a fallback UI instead of showing the error
        return RowItem(
          forceRemoteUrl: forceRemoteUrl,
          forceListView: forceListView, // Pass the parameter
          isOrdering: isOrdering,
          color: variant.color ?? "#673AB7",
          stock: stock,
          model: model,
          variant: variant,
          productName: variant.productName ?? "Unknown Product",
          variantName: variant.name,
          imageUrl: null, // No image available in error case
          isComposite: false, // Default to false in error case
          edit: (productId, type) {
            talker.info("navigating to Edit!");
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => OptionModal(
                child: ProductEntryScreen(productId: productId),
              ),
            );
          },
          delete: (productId, type) async {
            await deleteFunc(productId, model);
          },
          enableNfc: (product) {
            // Handle NFC functionality
          },
        );
      },
      data: (product) {
        return assetAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (err, stack) {
            // Log the error but don't show it to the user
            talker.error("Error fetching asset data: $err");
            talker.error(stack);

            // Return the product row without asset data
            return RowItem(
              forceRemoteUrl: forceRemoteUrl,
              forceListView: forceListView, // Pass the parameter
              isOrdering: isOrdering,
              color: variant.color ?? "#673AB7",
              stock: stock,
              model: model,
              variant: variant,
              productName: variant.productName ?? "Unknown Product",
              variantName: variant.name,
              imageUrl: null, // No image available in error case
              isComposite:
                  !isOrdering ? (product?.isComposite ?? false) : false,
              edit: (productId, type) {
                talker.info("navigating to Edit!");
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => OptionModal(
                    child: ProductEntryScreen(productId: productId),
                  ),
                );
              },
              delete: (productId, type) async {
                await deleteFunc(productId, model);
              },
              enableNfc: (product) {
                // Handle NFC functionality
              },
            );
          },
          data: (asset) {
            return RowItem(
              forceRemoteUrl: forceRemoteUrl,
              forceListView: forceListView, // Pass the parameter
              isOrdering: isOrdering,
              color: variant.color ?? "#673AB7",
              stock: stock,
              model: model,
              variant: variant,
              productName: variant.productName!,
              variantName: variant.name,
              imageUrl: asset?.assetName,
              isComposite:
                  !isOrdering ? (product?.isComposite ?? false) : false,
              edit: (productId, type) {
                talker.info("navigating to Edit!");

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => OptionModal(
                    child: ProductEntryScreen(productId: productId),
                  ),
                );
              },
              delete: (productId, type) async {
                await deleteFunc(productId, model);
              },
              enableNfc: (product) {
                // Handle NFC functionality
              },
            );
          },
        );
      },
    );
  }
}
