import 'package:flipper_routing/app.router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchInputWithDropdown extends StatefulWidget {
  const SearchInputWithDropdown({Key? key}) : super(key: key);

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
    // Add more customer types here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
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
                  color: Colors.transparent, // Hide the underline
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
    );
  }
}
