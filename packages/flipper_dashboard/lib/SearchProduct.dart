import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_select.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stacked/stacked.dart';

class SearchProduct extends StatefulHookConsumerWidget {
  const SearchProduct({Key? key, this.transaction}) : super(key: key);
  final ITransaction? transaction;

  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends ConsumerState<SearchProduct> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedProductType = 'All Products';
  final List<String> _productTypes = [
    'All Products',
    'Favorites',
    'In Stock',
    'Out of Stock',
  ];

  List<Variant> _searchResults = [];

  String _productTypeLabel(FlipperAppLocalizations l10n, String value) {
    switch (value) {
      case 'Favorites':
        return l10n.searchProductFavorites;
      case 'In Stock':
        return l10n.posStockFilterInStock;
      case 'Out of Stock':
        return l10n.posStockFilterOutOfStock;
      default:
        return l10n.searchProductAllProducts;
    }
  }

  Future<void> _search(String searchKey) async {
    if (searchKey.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final paged = await ProxyService.strategy.variants(
      taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
      name: searchKey,
      branchId: ProxyService.box.getBranchId()!,
    );
    List<Variant> variants = List<Variant>.from(paged.variants);
    setState(() {
      _searchResults = variants.isNotEmpty ? variants : [];
    });
  }

  void _pick(Variant variant) {
    ref
        .read(selectedVariantsLocalProvider.notifier)
        .addVariant(
          variant: VVariant(
            productName: variant.productName!,
            name: variant.name,
            retailPrice: variant.retailPrice!,
            supplyPrice: variant.supplyPrice ?? 0,
            id: variant.id,
            productId: variant.productId!,
          ),
        );
    talker.warning("click on item found");
    _searchController.clear();
    setState(() {
      _searchResults = [];
    });
  }

  Widget _resultRow(Variant variant) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => _pick(variant),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                variant.name,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink1,
                ),
              ),
              Text(
                variant.productName ?? "",
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: ProductEditorTokens.ink3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        // final selectedProducts = ref.watch(selectedProductsProvider);

        final l10n = context.flipperL10n;
        // No horizontal padding of its own: it lines up with the section.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: PeTextInput(
                    controller: _searchController,
                    leadingIcon: Icons.search,
                    placeholder: l10n.searchProductHint,
                    onChanged: _search,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 190,
                  child: PeSelect<String>(
                    value: _selectedProductType,
                    items: [
                      for (final value in _productTypes)
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            _productTypeLabel(l10n, value),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProductType = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_searchResults.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: ProductEditorTokens.surface,
                  borderRadius: BorderRadius.circular(PosTokensRadius.md),
                  border: Border.all(
                    color: ProductEditorTokens.line,
                    width: 1.5,
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: ProductEditorTokens.line,
                  ),
                  itemBuilder: (context, index) =>
                      _resultRow(_searchResults[index]),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
