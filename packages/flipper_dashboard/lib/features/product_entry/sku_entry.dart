import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sku/sku_duplicate_check.dart';
import 'package:flipper_models/sku/sku_format.dart';
import 'package:flipper_models/sku/sku_service.dart';
import 'package:flutter/material.dart';

/// What the SKU field shows before anything is typed: the SKU this variant
/// would get (`BEV-00064`, or `BEV-00042-02` for one more variant of a product
/// that already has a generated SKU), or null when this device has no number
/// yet (the item saves as "SKU pending").
///
/// Reads local state only and takes no number, so a cancelled form wastes
/// nothing.
String? skuPreviewFor({
  required String businessId,
  String? categoryName,
  String? skuPrefix,
  Iterable<String?> siblingSkus = const [],
}) {
  final siblings = siblingSkus.toList();
  for (final sibling in siblings) {
    final base = skuBase(sibling);
    if (base == null) continue;
    final next = nextVariantSku(base, siblings);
    if (next != null) return next;
  }
  return previewNextSku(
    businessId: businessId,
    skuPrefix: skuPrefix,
    categoryName: categoryName,
  );
}

/// The SKU field's placeholder: the SKU it would get ([skuPreviewFor]), or
/// "SKU pending" when this device has no number yet.
String skuFieldHint(FlipperAppLocalizations l10n, String? preview) =>
    preview == null ? l10n.skuPending : l10n.skuAutoHint(preview);

/// The SKU input: separate from the barcode, optional (blank = assigned on
/// save), with the next SKU shown as the hint.
class SkuTextField extends StatelessWidget {
  const SkuTextField({
    super.key,
    required this.controller,
    required this.preview,
    this.decorate,
  });

  final TextEditingController controller;

  /// From [skuPreviewFor]. Null shows "SKU pending".
  final String? preview;

  /// Lets a form apply its own border style.
  final InputDecoration Function(InputDecoration base)? decorate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final base = InputDecoration(
      labelText: 'SKU',
      hintText: skuFieldHint(l10n, preview),
      helperText: l10n.skuAutoHelper,
    );
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.characters,
      decoration: decorate?.call(base) ?? base,
    );
  }
}

/// A localized error when [typed] cannot be saved, or null when it can.
///
/// The check runs only when the SKU is new or changed from [storedSku], and
/// only against this device's data (one local Ditto query), so it works
/// offline. [unsaved] are variants in the open form that are not stored yet
/// (same branch, so any match blocks).
Future<String?> skuSaveError(
  BuildContext context, {
  required String typed,
  required String businessId,
  required SkuHolder candidate,
  String? storedSku,
  Iterable<({String id, String? name, String? sku})> unsaved = const [],
}) async {
  if (!skuNeedsDuplicateCheck(typed: typed, stored: storedSku)) return null;
  final l10n = context.flipperL10n;
  final wanted = normalizeSku(typed);
  for (final other in unsaved) {
    if (other.id == candidate.id) continue;
    if (normalizeSku(other.sku) == wanted) {
      return l10n.skuAlreadyUsed(other.name ?? typed);
    }
  }
  try {
    final clash = await findSkuInUse(
      sku: typed,
      businessId: businessId,
      candidate: candidate,
      storedSku: storedSku,
    );
    if (clash == null) return null;
    final name = clash.name?.trim();
    return l10n.skuAlreadyUsed(name == null || name.isEmpty ? typed : name);
  } catch (_) {
    // The local lookup failed (Ditto not ready). Do not block the sale flow:
    // the server's unique index and the connector's conflict flag still
    // catch a real duplicate.
    return null;
  }
}

/// A variant's SKU for item lists: the SKU, or "SKU pending" while it waits
/// for a number, plus a "Needs attention" badge when data-connector found the
/// SKU on a different item (`skuConflict`). Nothing when there is neither.
class SkuStatusLine extends StatelessWidget {
  const SkuStatusLine({
    super.key,
    required this.sku,
    this.pending = false,
    this.conflict = false,
    this.textStyle,
  });

  final String? sku;
  final bool pending;
  final bool conflict;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final value = sku?.trim() ?? '';
    final label = value.isNotEmpty
        ? 'SKU $value'
        : (pending ? l10n.skuPending : null);
    if (label == null && !conflict) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          if (label != null)
            Flexible(
              child: Text(
                label,
                style: textStyle ?? theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (conflict) ...[
            const SizedBox(width: 6),
            // Semantics, not Tooltip: a Tooltip in list rows asserts under
            // DevicePreview's LayoutBuilder (OverlayPortal mount in layout).
            Semantics(
              label: l10n.skuConflictTooltip,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.skuNeedsAttention,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
