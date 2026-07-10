import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_catalog_search_row.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_catalog_tiles.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Catalog grid pane shared by desktop and mobile bar POS.
class BarPosCatalogPane extends ConsumerStatefulWidget {
  const BarPosCatalogPane({
    super.key,
    required this.branchId,
    required this.onAdd,
    this.forceTwoColumns = false,
    this.horizontalPadding = 20,
  });

  final String branchId;
  final Future<void> Function(Variant variant) onAdd;
  final bool forceTwoColumns;
  final double horizontalPadding;

  @override
  ConsumerState<BarPosCatalogPane> createState() => _BarPosCatalogPaneState();
}

class _BarPosCatalogPaneState extends ConsumerState<BarPosCatalogPane> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent - 48) return;

    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      ref.read(outerVariantsProvider(widget.branchId).notifier).loadMore();
    });
  }

  SliverGridDelegate _gridDelegate(double paneWidth) {
    if (widget.forceTwoColumns) {
      return const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      );
    }
    return barPosCatalogGridDelegate(paneWidth);
  }

  @override
  Widget build(BuildContext context) {
    final variantsAsync = ref.watch(outerVariantsProvider(widget.branchId));
    final stocksById =
        ref.watch(stocksForVisibleVariantsProvider(widget.branchId)).asData?.value ??
            const <String, Stock?>{};

    final pad = widget.horizontalPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(pad, 16, pad, 10),
          child: BarCatalogSearchRow(controller: _searchController),
        ),
        Expanded(
          child: variantsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (variants) {
              if (variants.isEmpty) {
                return Center(
                  child: Text(
                    'No products match your search',
                    style: GoogleFonts.outfit(color: BarTokens.ink3),
                  ),
                );
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(pad, 0, pad, 20),
                    gridDelegate: _gridDelegate(constraints.maxWidth),
                    itemCount: variants.length,
                    itemBuilder: (context, i) {
                      final v = variants[i];
                      return BarPosVariantTile(
                        key: ValueKey('bar-pos-variant-${v.id}'),
                        variant: v,
                        liveStock: stocksById[v.stockId ?? ''],
                        onTap: () => widget.onAdd(v),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Grid delegate helper for mobile bar POS (always 2 columns).
SliverGridDelegate barPosMobileCatalogGridDelegate() {
  return const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.72,
  );
}

/// Returns true when catalog should use mobile 2-col layout.
bool barPosForceTwoColumns(double width) =>
    width < BarLayoutBreakpoints.mobileMaxWidth;
