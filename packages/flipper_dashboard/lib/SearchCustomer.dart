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

class SearchInputWithDropdown extends StatefulWidget {
  const SearchInputWithDropdown({Key? key, this.transaction}) : super(key: key);
  final ITransaction? transaction;

  @override
  State<SearchInputWithDropdown> createState() =>
      _SearchInputWithDropdownState();
}

class _SearchInputWithDropdownState extends State<SearchInputWithDropdown> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCustomerType = 'Walk-in Customer';
  final _routerService = locator<RouterService>();
  final List<String> _customerTypes = [
    'Walk-in Customer',
    'Take Away',
    'Delivery',
  ];

  List<Customer> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
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
                    List<Customer> customers =
                        ProxyService.realm.getCustomers(key: searchKey);
                    if (customers.length > 0) {
                      setState(() {
                        _searchResults = customers;
                      });
                    } else {
                      setState(() {
                        _searchResults = [];
                      });
                    }
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
                      return GestureDetector(
                        onTap: () async {
                          talker.warning(
                              "CustomerId:${_searchResults[index].id}");
                          if (widget.transaction == null) return;
                          await model.assignToSale(
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
                            borderRadius: BorderRadius.zero,
                          ),
                          child: ListTile(
                            title: Text(_searchResults[index].custNm!),
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
