import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'import_purchase_helpers.dart';
import 'import_purchase_tokens.dart';

class IpmVariantCombo extends ConsumerStatefulWidget {
  const IpmVariantCombo({
    super.key,
    this.selectedVariantId,
    required this.onSelected,
    this.placeholder = 'Select Variant',
  });

  final String? selectedVariantId;
  final ValueChanged<Variant?> onSelected;
  final String placeholder;

  @override
  ConsumerState<IpmVariantCombo> createState() => _IpmVariantComboState();
}

class _IpmVariantComboState extends ConsumerState<IpmVariantCombo> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void _toggleOverlay(List<Variant> variants) {
    if (_entry != null) {
      _removeOverlay();
      return;
    }
    _searchController.clear();
    _query = '';
    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, ImportPurchaseTokens.fieldH + 6),
            child: Material(
              elevation: 8,
              shadowColor: const Color(0x38141E3C),
              borderRadius: BorderRadius.circular(ImportPurchaseTokens.radius),
              child: Container(
                width: 320,
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: ImportPurchaseTokens.surface,
                  borderRadius: BorderRadius.circular(ImportPurchaseTokens.radius),
                  border: Border.all(color: ImportPurchaseTokens.line),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Search variants…',
                          prefixIcon: const Icon(Icons.search, size: 18),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              ImportPurchaseTokens.radiusSm,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(6),
                        children: _filtered(variants)
                            .map((v) => _optionTile(v))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  List<Variant> _filtered(List<Variant> variants) {
    final q = _query.toLowerCase();
    if (q.isEmpty) return variants;
    return variants
        .where((v) => v.name.toLowerCase().contains(q))
        .toList();
  }

  Widget _optionTile(Variant variant) {
    final selected = widget.selectedVariantId == variant.id;
    return InkWell(
      onTap: () {
        widget.onSelected(variant);
        _removeOverlay();
      },
      borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusXs),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? ImportPurchaseTokens.accentWash : null,
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusXs),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                variant.name,
                style: ImportPurchaseHelpers.text(
                  size: 14.5,
                  weight: FontWeight.w600,
                  color: selected
                      ? ImportPurchaseTokens.accentStrong
                      : ImportPurchaseTokens.ink,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check,
                size: 16,
                color: ImportPurchaseTokens.accentStrong,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Text('No branch selected');
    }

    final variantsAsync = ref.watch(outerVariantsProvider(branchId));
    return variantsAsync.when(
      loading: () => const SizedBox(
        height: ImportPurchaseTokens.fieldH,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const Text('Failed to load variants'),
      data: (variants) {
        final filtered =
            variants.where((v) => v.itemTyCd != '3').toList();
        Variant? selected;
        if (widget.selectedVariantId != null) {
          for (final v in filtered) {
            if (v.id == widget.selectedVariantId) {
              selected = v;
              break;
            }
          }
        }

        return CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            onTap: () => _toggleOverlay(filtered),
            borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: ImportPurchaseTokens.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 13),
                constraints:
                    const BoxConstraints(minHeight: ImportPurchaseTokens.fieldH),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(ImportPurchaseTokens.radiusSm),
                  borderSide: const BorderSide(color: ImportPurchaseTokens.line2),
                ),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: ImportPurchaseTokens.muted,
                ),
              ),
              child: Text(
                selected?.name ?? widget.placeholder,
                style: ImportPurchaseHelpers.text(
                  size: 14.5,
                  weight: selected != null ? FontWeight.w600 : FontWeight.w400,
                  color: selected != null
                      ? ImportPurchaseTokens.ink
                      : ImportPurchaseTokens.faint,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
