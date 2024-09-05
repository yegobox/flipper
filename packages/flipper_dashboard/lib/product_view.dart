// ignore_for_file: unused_result

import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_dashboard/TransactionList.dart';

class ProductView extends StatefulHookConsumerWidget {
  final int? favIndex;
  final List<int> existingFavs;

  ProductView.normalMode({Key? key})
      : favIndex = null,
        existingFavs = [],
        super(key: key);

  ProductView.favoriteMode({
    Key? key,
    required this.favIndex,
    required this.existingFavs,
  }) : super(key: key);

  @override
  ProductViewState createState() => ProductViewState();
}

class ProductViewState extends ConsumerState<ProductView> with Datamixer {
  final searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0)
              .notifier)
          .loadVariants(
            scanMode: ref.read(scanningModeProvider),
            searchString: ref.read(searchStringProvider),
          );
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
        ref
            .read(
                productsProvider(ProxyService.box.getBranchId() ?? 0).notifier)
            .loadProducts(
                searchString: ref.read(searchStringProvider),
                scanMode: ref.read(scanningModeProvider));
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return _buildContent(context, model);
      },
    );
  }

  Widget _buildContent(BuildContext context, ProductViewModel model) {
    final buttonIndex = ref.watch(buttonIndexProvider);

    if (buttonIndex == 1) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 700),
        child: TransactionList(showDetailedReport: true),
      );
    }

    return _buildVariantList(context, model);
  }

  Widget _buildVariantList(BuildContext context, ProductViewModel model) {
    return Consumer(
      builder: (context, ref, _) {
        return ref
            .watch(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0))
            .when(
              data: (variants) {
                if (variants.isEmpty) {
                  return Text('No Products available.');
                }
                if (!variants.first.isValid) {
                  return Center(
                      child: Text("There was issue, please restart the app"));
                }
                return _buildVariantsGrid(context, model, variants);
              },
              error: (_, __) => SizedBox.shrink(),
              loading: () => SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()),
            );
      },
    );
  }

  Widget _buildVariantsGrid(
      BuildContext context, ProductViewModel model, List<Variant> variants) {
    return Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 2.0,
          ),
          itemCount: variants.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= variants.length) {
              return Center(child: CircularProgressIndicator());
            }

            return buildVariantRow(
              forceRemoteUrl: false,
              context: context,
              model: model,
              variant: variants[index],
              isOrdering: false,
            );
          },
          shrinkWrap: true,
        ),
      ],
    );
  }
}
