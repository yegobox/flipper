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
import 'package:stacked_services/stacked_services.dart';

class SearchInputWithDropdown extends ConsumerStatefulWidget {
  const SearchInputWithDropdown({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchInputWithDropdown> createState() =>
      _SearchInputWithDropdownState();
}

class _SearchInputWithDropdownState
    extends ConsumerState<SearchInputWithDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _customerTypes = ['Walk-in', 'Take Away', 'Delivery'];
  String _selectedCustomerType = 'Walk-in';
  List<Customer> _searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSearchBox();
    });
  }

  Future<void> _initializeSearchBox() async {
    final transaction = ref.read(pendingTransactionProviderNonStream(
        (mode: TransactionType.sale, isExpense: false)));

    if (transaction.value?.customerId != null) {
      final customer = await ProxyService.strategy.customers(
        id: transaction.value!.customerId,
        branchId: ProxyService.box.getBranchId()!,
      );
      if (customer.isNotEmpty) {
        _searchController.text = customer.first.custNm!;
      }
    } else {
      _searchController.clear();
    }
  }

  Future<void> _removeCustomer() async {
    final transaction = ref.read(pendingTransactionProviderNonStream((
      mode: TransactionType.sale,
      isExpense: false,
    )));

    if (transaction.value?.id != null) {
      await ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );

      ref.invalidate(pendingTransactionProviderNonStream((
        mode: TransactionType.sale,
        isExpense: false,
      )));

      setState(() {
        _searchController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(pendingTransactionProviderNonStream((
      mode: TransactionType.sale,
      isExpense: false,
    )));

    final attachedCustomerFuture = ref.watch(
      customerProvider((id: transaction.value?.customerId ?? '')),
    );

    return attachedCustomerFuture.when(
      data: (attachedCustomer) {
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

                  final customers = await ProxyService.strategy.customers(
                    key: searchKey,
                    branchId: ProxyService.box.getBranchId()!,
                  );
                  talker.warning(customers);

                  setState(() {
                    _searchResults = customers;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        isDense: true,
                        value: _selectedCustomerType,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCustomerType = newValue!;
                          });
                        },
                        items: _customerTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      attachedCustomer != null
                          ? IconButton(
                              icon: const Icon(
                                FluentIcons.person_delete_20_regular,
                                color: Colors.red,
                              ),
                              onPressed: _removeCustomer,
                            )
                          : IconButton(
                              onPressed: () {
                                locator<RouterService>()
                                    .navigateTo(CustomersRoute());
                              },
                              icon: const Icon(
                                FluentIcons.person_add_16_regular,
                                color: Colors.blue,
                              ),
                            ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16.0),
              if (_searchResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final customer = _searchResults[index];
                    return GestureDetector(
                      onTap: () async {
                        try {
                          await ProxyService.strategy
                              .assignCustomerToTransaction(
                                  customerId: _searchResults[index].id,
                                  transactionId: transaction.value!.id);
                          showAlert(
                            context,
                            title: "Customer added to the sale!",
                            onPressedOk: () {
                              // ignore: unused_result
                              ref.refresh(pendingTransactionProviderNonStream((
                                mode: TransactionType.sale,
                                isExpense: false,
                              )));
                            },
                          );
                          setState(() {
                            _searchResults = [];
                          });
                        } catch (e) {
                          talker.warning(e);
                          rethrow;
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(customer.custNm!),
                          subtitle: Text(customer.custTin!),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
      loading: () => SizedBox.shrink(),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
