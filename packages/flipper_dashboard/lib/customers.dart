// ignore_for_file: unused_result

import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'add_customer.dart';
import 'customappbar.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Customers extends StatefulHookConsumerWidget {
  Customers({Key? key, this.transactionId}) : super(key: key);
  final int? transactionId;

  @override
  CustomersState createState() => CustomersState();
}

class CustomersState extends ConsumerState<Customers> {
  final TextEditingController _searchController = TextEditingController();
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(customerSearchStringProvider);
    final customersRef = ref.watch(customersProvider);

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ref.refresh(customersProvider);
                _routerService.pop();
              },
              title: 'Add Customer',
              showActionButton: false,
              onActionButtonClicked: () async {
                _routerService.pop();
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 50,
            ),
            body: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: BoxInputField(
                    controller: _searchController,
                    trailing: const Icon(Icons.clear_outlined),
                    trailingTapped: () {
                      _searchController.clear();
                      ref
                          .read(customerSearchStringProvider.notifier)
                          .emitString(value: "");
                    },
                    placeholder: 'Search for a customer',
                    onChanged: (value) {
                      ref
                          .read(customerSearchStringProvider.notifier)
                          .emitString(value: value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: customersRef.when(
                    data: (customers) => ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Slidable(
                              key: Key('customer-${customer.id}'),
                              child: GestureDetector(
                                onTap: () async {
                                  await model.assignToSale(
                                    customerId: customer.id!,
                                    transactionId: widget.transactionId!,
                                  );

                                  model.getTransactionById();
                                  showAlert(
                                    context,
                                    onPressedOk: () {},
                                    title: "Customer added to sale!",
                                  );
                                },
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          16, 8, 16, 8),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Text(
                                          customer.custNm!.substring(0, 1),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        '${customer.custNm!} (${customer.telNo})',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        customer.custTin ?? '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              ),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) async {
                                      model.deleteCustomer(customer.id!,
                                          (message) {
                                        toast(message);
                                      });

                                      ref
                                          .refresh(customersProvider.notifier)
                                          .loadCustomers(searchString: '');
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) async {
                                      await model.assignToSale(
                                        customerId: customer.id!,
                                        transactionId: widget.transactionId!,
                                      );

                                      model.getTransactionById();
                                      toast("Customer added to sale");
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.add,
                                    label: 'Add',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) async {
                                      await model.removeFromSale(
                                        customerId: customer.id!,
                                        transactionId: widget.transactionId!,
                                      );
                                      model.getTransactionById();
                                      toast("Customer removed from sale");
                                    },
                                    backgroundColor:
                                        Color.fromARGB(255, 253, 174, 4),
                                    foregroundColor: Colors.white,
                                    icon: Icons.remove,
                                    label: 'Remove',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text('Error: $error'),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24), // Adjusted horizontal padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Added bold text
                      ),
                    ),
                    icon: Icon(
                      FluentIcons.person_add_16_regular,
                      color: Colors.white,
                      size: 24, // Increased icon size
                    ),
                    label: Text(
                      _getButtonText(customersRef, searchKeyword),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _handleButtonPress(
                      context,
                      model,
                      customersRef,
                      searchKeyword,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getButtonText(
      AsyncValue<List<Customer>> customersRef, String searchKeyword) {
    final customers = customersRef.asData?.value ?? [];
    final isCustomerListEmpty = ref
        .read(customersProvider.notifier)
        .filterCustomers(customers, searchKeyword)
        .isEmpty;
    return isCustomerListEmpty
        ? 'Add Customer $searchKeyword'
        : 'Add $searchKeyword to Sale';
  }

  Future<void> _handleButtonPress(BuildContext context, CoreViewModel model,
      AsyncValue<List<Customer>> customersRef, String searchKeyword) async {
    final customers = customersRef.asData?.value ?? [];
    final filteredCustomers = ref
        .read(customersProvider.notifier)
        .filterCustomers(customers, searchKeyword);

    if (filteredCustomers.isEmpty) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AddCustomer(
              transactionId: widget.transactionId ?? 0,
              searchedKey: searchKeyword,
            ),
          );
        },
      );
    } else {
      final customer = filteredCustomers.first;
      await model.assignToSale(
          customerId: customer.id!, transactionId: widget.transactionId!);
      showAlert(context, onPressedOk: () {}, title: "Customer added to sale!");
    }
  }
}
