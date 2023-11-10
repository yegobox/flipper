import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'add_customer.dart';
import 'customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Customers extends StatefulHookConsumerWidget {
  Customers({Key? key, this.transactionId}) : super(key: key);
  final String? transactionId;

  @override
  CustomersState createState() => CustomersState();
}

class CustomersState extends ConsumerState<Customers> {
  final TextEditingController _searchController = TextEditingController();

  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(searchStringProvider);
    final customersRef =
        ref.watch(customersProvider(ProxyService.box.getBranchId()!));
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                _routerService.pop();
              },
              title: 'Add customer here',
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
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: BoxInputField(
                    controller: _searchController,
                    trailing: const Icon(Icons.clear_outlined),
                    trailingTapped: () {
                      //clear the
                      _searchController.clear();
                      ref
                          .read(searchStringProvider.notifier)
                          .emitString(value: "");
                    },
                    placeholder: 'Search for a customer',
                    onChanged: (value) {
                      ref
                          .read(searchStringProvider.notifier)
                          .emitString(value: value);
                    },
                  ),
                ),
                verticalSpaceSmall,
                _buildCustomerList(context, model, customersRef),
                verticalSpaceSmall,
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                  child: BoxButton(
                    title: ref
                                .read(customersProvider(
                                        ProxyService.box.getBranchId()!)
                                    .notifier)
                                .filterCustomers(customersRef.asData?.value,
                                    searchKeyword) ==
                            null
                        ? 'Create Customer "${searchKeyword}"'
                        : 'Add Customer',
                    onTap: () {
                      _showModalBottomSheet(
                        context,
                        widget.transactionId ?? '0',
                        searchKeyword,
                      );
                    },
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerList(BuildContext context, CoreViewModel model,
      AsyncValue<List<Customer>> customersRef) {
    return customersRef.when(
      data: (customers) => Expanded(
        child: ListView(
          shrinkWrap: true,
          children: customers
              .map(
                (customer) => Slidable(
                  // ... (rest of your code)
                  child: GestureDetector(
                    onTap: () async {
                      await model.assignToSale(
                        customerId: customer.id,
                        transactionId: widget.transactionId,
                      );
                      model.app.setCustomer(customer);
                      model.getTransactionById();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Customer added to sale"),
                        ),
                      );
                    },
                    onLongPress: () {},
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          leading: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: 58,
                            child: TextDrawable(
                              backgroundColor: Colors.green,
                              text: customer.name + "(${customer.phone})",
                              isTappable: true,
                              onTap: null,
                              boxShape: BoxShape.rectangle,
                            ),
                          ),
                          title: Text(
                            (customer.name) +
                                "(${customer.phone} ${customer.tinNumber ?? ''})",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(
                      key: Key('dismissable-100'),
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          model.deleteCustomer(customer.id, (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(message),
                              ),
                            );
                          });
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(
                      key: Key('dismissable-100'),
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          await model.assignToSale(
                            customerId: customer.id,
                            transactionId: widget.transactionId!,
                          );
                          model.app.setCustomer(customer);
                          model.getTransactionById();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Customer added to sale"),
                            ),
                          );
                        },
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.add,
                        label: 'Add',
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      error: (error, stackTrace) => Expanded(
        child: Text('Error: $error'),
      ),
      loading: () => const Expanded(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showModalBottomSheet(
      BuildContext context, String transactionId, searchedKey) {
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
            transactionId: transactionId,
            searchedKey: searchedKey,
          ),
        );
      },
    );
  }
}
