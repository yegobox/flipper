import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/ProductList.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Orders extends StatefulHookConsumerWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends ConsumerState<Orders> {
  Branch? selectedSupplier;

  final talker = Talker();
  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(branchesProvider);
    // talker.warning("Branches ${suppliers}");
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        onWillPop(
          context: context,
          navigationPurpose: NavigationPurpose.back,
          message: 'Done shopping?',
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Supplier'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<Branch>(
                value: selectedSupplier,
                decoration: const InputDecoration(
                  labelText: 'Select Supplier',
                  border: OutlineInputBorder(),
                ),
                items: suppliers.map((Branch supplier) {
                  return DropdownMenuItem<Branch>(
                    value: supplier,
                    child: Text(supplier.name ?? "-"),
                  );
                }).toList(),
                onChanged: (Branch? newValue) {
                  setState(() {
                    selectedSupplier = newValue;
                  });
                  if (newValue != null) {
                    ref
                        .read(selectedSupplierProvider.notifier)
                        .setSupplier(supplier: newValue);
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: selectedSupplier == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListScreen(),
                          ),
                        );
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: selectedSupplier == null
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'View Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
