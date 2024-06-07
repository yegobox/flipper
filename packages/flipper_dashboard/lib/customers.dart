import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'add_customer.dart';
import 'customappbar.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
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
                _routerService.pop();
              },
              title: 'Add customer',
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
                verticalSpaceSmall,
                Expanded(
                  // Use Expanded for the list view
                  child: customersRef.when(
                    data: (customers) => ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding for spacing
                          child: Slidable(
                            key: Key(
                                'customer-${customer.id}'), // Unique key for each Slidable
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
                              onLongPress: () {},
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    leading: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: 58,
                                      child: TextDrawable(
                                        backgroundColor: Colors.green,
                                        text: customer.custNm! +
                                            "(${customer.telNo})",
                                        isTappable: true,
                                        onTap: null,
                                        boxShape: BoxShape.rectangle,
                                      ),
                                    ),
                                    title: Text(
                                      (customer.custNm!) +
                                          "(${customer.telNo} ${customer.custTin})",
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                  onPressed: (_) async {
                                    model.deleteCustomer(customer.id!,
                                        (message) {
                                      toast(message);
                                    });

                                    // Refresh the customers provider
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
                              motion: const ScrollMotion(
                                key: Key('dismissable-100'),
                              ),
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
                                  icon: Icons.attach_file,
                                  label: 'Remove',
                                ),
                              ],
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
                verticalSpaceSmall,
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                  child: BoxButton(
                    title: ref
                            .read(customersProvider.notifier)
                            .filterCustomers(
                                customersRef.asData?.value ?? [], searchKeyword)
                            .isEmpty
                        ? 'Create Customer ${searchKeyword}'
                        : 'Add ${searchKeyword} To sale',
                    onTap: () async {
                      if (ref
                          .read(customersProvider.notifier)
                          .filterCustomers(
                              customersRef.asData?.value ?? [], searchKeyword)
                          .isEmpty) {
                        _showModalBottomSheet(
                          context,
                          widget.transactionId!,
                          searchKeyword,
                        );
                      } else {
                        final customer = ref
                            .read(customersProvider.notifier)
                            .filterCustomers(
                                customersRef.asData?.value ?? [], searchKeyword)
                            .first;
                        await model.assignToSale(
                          customerId: customer.id!,
                          transactionId: widget.transactionId!,
                        );
                        showAlert(context,
                            onPressedOk: () {},
                            title: "Customer added to sale!");
                      }
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

  void _showModalBottomSheet(
      BuildContext context, int transactionId, searchedKey) {
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
