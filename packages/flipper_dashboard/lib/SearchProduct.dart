import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stacked/stacked.dart';

class SelectedVariantsNotifier extends StateNotifier<List<Variant>> {
  SelectedVariantsNotifier() : super([]);

  void addVariant(Variant product) {
    if (!state.contains(product)) {
      state = [...state, product];
    }
  }

  // Delete a variant from the list
  void deleteVariant(Variant variant) {
    state = state.where((v) => v != variant).toList();
  }
}

final selectedVariantsProvider =
    StateNotifierProvider<SelectedVariantsNotifier, List<Variant>>((ref) {
  return SelectedVariantsNotifier();
});

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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        // final selectedProducts = ref.watch(selectedProductsProvider);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                onChanged: (searchKey) {
                  if (searchKey.isEmpty) {
                    setState(() {
                      _searchResults = [];
                    });
                    return;
                  }
                  List<Variant> variants =
                      ProxyService.realm.getVariants(key: searchKey);
                  setState(() {
                    _searchResults = variants.isNotEmpty ? variants : [];
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        isDense: true,
                        alignment: AlignmentDirectional.topStart,
                        value: _selectedProductType,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProductType = newValue!;
                          });
                        },
                        items: _productTypes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FluentIcons.add_24_regular,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ref
                            .read(selectedVariantsProvider.notifier)
                            .addVariant(_searchResults[index]);
                        talker.warning("click Happened");
                        _searchController.clear();
                        setState(() {
                          _searchResults = [];
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        child: ListTile(
                          title: Text(_searchResults[index].name!),
                          subtitle:
                              Text(_searchResults[index].productName ?? ""),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
