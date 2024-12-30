import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchInputWithDropdown extends StatefulHookConsumerWidget {
  const SearchInputWithDropdown({Key? key, this.transaction}) : super(key: key);
  final ITransaction? transaction;

  @override
  _SearchInputWithDropdownState createState() =>
      _SearchInputWithDropdownState();
}

class _SearchInputWithDropdownState
    extends ConsumerState<SearchInputWithDropdown> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCustomerType = 'Walk-in';
  final List<String> _customerTypes = [
    'Walk-in',
    'Take Away',
    'Delivery',
  ];

  List<Customer> _searchResults = [];
  final _routerService = locator<RouterService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSearchBoxFromTransaction();
    });
  }

  Future<void> _updateSearchBoxFromTransaction() async {
    final transaction = ref.read(pendingTransactionProviderNonStream(
      (mode: TransactionType.sale, isExpense: false),
    ));

    if (transaction.value?.customerId != null) {
      final customer = (await ProxyService.strategy.customers(
        id: transaction.value?.customerId,
        branchId: ProxyService.box.getBranchId()!,
      ))
          .firstOrNull;
      if (customer != null) {
        _searchController.text = customer.custNm!;
      }
    } else {
      _searchController.clear();
    }
  }

  Future<Customer?> _getAttachedCustomer(ITransaction? transaction) async {
    if (transaction?.customerId == null) {
      return null;
    }
    return (await ProxyService.strategy.customers(
            id: transaction!.customerId,
            branchId: ProxyService.box.getBranchId()!))
        .firstOrNull;
  }

  void _removeAttachedCustomer() {
    final transaction = ref.read(pendingTransactionProviderNonStream(
      (mode: TransactionType.sale, isExpense: false),
    ));
    if (transaction.value?.id != null) {
      ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );
      setState(() {
        _searchController.clear();
      });
      ref.invalidate(pendingTransactionProviderNonStream(
        (mode: TransactionType.sale, isExpense: false),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the transaction
    final transaction = ref.watch(
      pendingTransactionProviderNonStream(
        (mode: TransactionType.sale, isExpense: false),
      ),
    );

    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          return FutureBuilder<Customer?>(
            future: _getAttachedCustomer(transaction.value),
            builder: (context, snapshot) {
              final attachedCustomer = snapshot.data;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      readOnly: attachedCustomer != null,
                      controller: _searchController,
                      onChanged: (searchKey) async {
                        if (searchKey.isEmpty) {
                          setState(() {
                            _searchResults = [];
                          });
                          return;
                        }
                        List<Customer> customers = await ProxyService.strategy
                            .customers(
                                key: searchKey,
                                branchId: ProxyService.box.getBranchId()!);
                        setState(() {
                          _searchResults =
                              customers.isNotEmpty ? customers : [];
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (attachedCustomer != null)
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: _removeAttachedCustomer,
                              ),
                            DropdownButton<String>(
                              isDense: true,
                              value: _selectedCustomerType,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                  height: 2, color: Colors.transparent),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCustomerType = newValue!;
                                });
                              },
                              items: _customerTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            IconButton(
                              onPressed: () {
                                _routerService.navigateTo(CustomersRoute());
                              },
                              icon: const Icon(
                                  FluentIcons.person_add_16_regular,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_searchResults.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              talker.warning(
                                  "CustomerId:${_searchResults[index].id}");
                              if (widget.transaction == null) return;
                              model.assignToSale(
                                customerId: _searchResults[index].id,
                                transactionId: widget.transaction!.id,
                              );
                              setState(() {
                                _searchResults = [];
                              });
                              showAlert(
                                context,
                                onPressedOk: () {},
                                title: "Customer added to the sale!",
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2,
                              child: ListTile(
                                title: Text(_searchResults[index].custNm!),
                                subtitle: Text(_searchResults[index].custTin!),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        });
  }
}
