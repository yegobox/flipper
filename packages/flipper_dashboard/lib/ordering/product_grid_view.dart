import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductGridView extends StatefulHookConsumerWidget {
  const ProductGridView({
    Key? key,
    required this.variants,
    required this.model,
    required this.isOrdering,
  }) : super(key: key);

  final List<Variant> variants;
  final ProductViewModel model;
  final bool isOrdering;

  @override
  ConsumerState<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends ConsumerState<ProductGridView>
    with Datamixer {
  @override
  Widget build(BuildContext context) {
    // One observer for the stock of every card. Without it each card opened
    // its own, a synchronous Ditto call on the UI thread, again on every
    // supplier search keystroke (see [RowItem.stockFromBatch]).
    final stocksById =
        ref.watch(stocksByIdsProvider(stockIdsKey(widget.variants))).value ??
        const <String, Stock?>{};
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: widget.variants.length,
      itemBuilder: (context, index) {
        return buildVariantRow(
          forceRemoteUrl: true,
          context: context,
          model: widget.model,
          variant: widget.variants[index],
          isOrdering: widget.isOrdering,
          stocksById: stocksById,
        );
      },
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
