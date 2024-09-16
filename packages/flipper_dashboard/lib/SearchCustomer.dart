import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  final _routerService = locator<RouterService>();

  final List<String> _customerTypes = [
    'Walk-in',
    'Take Away',
    'Delivery',
  ];

  List<Customer> _searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSearchBoxFromTransaction();
    });
  }

  void _updateSearchBoxFromTransaction() {
    final transaction = ref.read(pendingTransactionProviderNonStream(
        (mode: TransactionType.sale, isExpense: false)));
    if (transaction.customerId != null) {
      final customer =
          ProxyService.realm.getCustomer(id: transaction.customerId);
      if (customer != null) {
        _searchController.text = customer.custNm!;
      }
    } else {
      _searchController.clear();
    }
  }

  void _removeAttachedCustomer() {
    final transaction = ref.read(pendingTransactionProviderNonStream(
        (mode: TransactionType.sale, isExpense: false)));
    if (transaction.id != null) {
      ProxyService.realm
          .removeCustomerFromTransaction(transaction: transaction);
      setState(() {
        _searchController.clear();
      });
      ref.invalidate(pendingTransactionProviderNonStream(
          (mode: TransactionType.sale, isExpense: false)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the transaction once and reuse it
    final transaction = ref.watch(
      pendingTransactionProviderNonStream(
          (mode: TransactionType.sale, isExpense: false)),
    );

    // React to changes in the transaction using ref.listen
    ref.listen<ITransaction>(
      pendingTransactionProviderNonStream(
          (mode: TransactionType.sale, isExpense: false)),
      (previous, next) {
        if (previous?.customerId != next.customerId) {
          _updateSearchBoxFromTransaction();
        }
      },
    );

    final attachedCustomer = transaction.customerId != null
        ? ProxyService.realm.getCustomer(id: transaction.customerId)
        : null;
    useEffect(() {
      if (attachedCustomer != null) {
        _searchController.text = attachedCustomer.custNm!;
      }
      return null;
    }, [attachedCustomer]);
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input Field
                TextFormField(
                  readOnly: attachedCustomer != null,
                  controller: _searchController,
                  onChanged: (searchKey) {
                    if (searchKey.isEmpty) {
                      setState(() {
                        _searchResults = [];
                      });
                      return;
                    }
                    List<Customer> customers =
                        ProxyService.realm.getCustomers(key: searchKey);
                    setState(() {
                      _searchResults = customers.isNotEmpty ? customers : [];
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (attachedCustomer != null)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: _removeAttachedCustomer,
                          ),
                        // Dropdown for Customer Type
                        DropdownButton<String>(
                          isDense: true,
                          value: _selectedCustomerType,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCustomerType = newValue!;
                            });
                          },
                          items: _customerTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        // Add Customer Button
                        IconButton(
                          onPressed: () {
                            _routerService.navigateTo(CustomersRoute());
                          },
                          icon: Icon(
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
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 12.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Search Results List
                if (_searchResults.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            talker.warning(
                                "CustomerId:${_searchResults[index].id}");
                            if (widget.transaction == null) return;
                            model.assignToSale(
                              customerId: _searchResults[index].id!,
                              transactionId: widget.transaction!.id!,
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
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: ListTile(
                              title: Text(
                                _searchResults[index].custNm!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(_searchResults[index].custTin!),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
