import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

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
    final transaction =
        ref.read(pendingTransactionStreamProvider(isExpense: false));

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
    final transaction = ref.read(pendingTransactionStreamProvider(
      isExpense: false,
    ));

    if (transaction.value?.id != null) {
      await ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );

      ref.refresh(pendingTransactionStreamProvider(
        isExpense: false,
      ));

      setState(() {
        _searchController.clear();
      });
    }
  }

  void showPlayfulAlert(
    BuildContext context, {
    required String title,
    required VoidCallback onPressedOk,
  }) {
    showDialog(
      context: context,
      builder: (context) => TweenAnimationBuilder(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: Colors.amber,
                    size: 30 * value,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    const Text('🎉 Success! 🎉'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onPressedOk();
                      },
                      child: const Text(
                        'Awesome!',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(pendingTransactionStreamProvider(
      isExpense: false,
    ));

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
                          showPlayfulAlert(
                            context,
                            title: "Customer added to the sale!",
                            onPressedOk: () {
                              // ignore: unused_result
                              ref.refresh(pendingTransactionStreamProvider(
                                isExpense: false,
                              ));
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
