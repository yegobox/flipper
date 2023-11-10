import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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
                    placeholder: 'Search for a customer',
                    onChanged: (value) {
                      ref
                          .read(searchStringProvider.notifier)
                          .emitString(value: value);
                    },
                  ),
                ),
                verticalSpaceSmall,
                StreamBuilder<Customer?>(
                  stream: model.getCustomer(key: searchKeyword),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasData) {
                      print("Data received: ${snapshot.data!.toJson()}");
                    } else if (snapshot.hasError) {
                      print("Error: ${snapshot.error}");
                    }

                    return snapshot.hasData
                        ? _buildCustomerList(context, model, snapshot.data!)
                        : SizedBox.shrink();
                  },
                ),
                verticalSpaceSmall,
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                  child: BoxButton(
                    title: searchKeyword.isNotEmpty
                        ? 'Create Customer "$model.searchCustomerKey"'
                        : 'Add Customer',
                    onTap: () {
                      _showModalBottomSheet(
                        context,
                        widget.transactionId ?? '0',
                        searchKeyword,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerList(
    BuildContext context,
    CoreViewModel model,
    Customer customer,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: ListView(
        shrinkWrap: true,
        children: [
          Slidable(
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
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    leading: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: 58,
                      child: TextDrawable(
                        backgroundColor: Colors.green,
                        text: customer.name,
                        isTappable: true,
                        onTap: null,
                        boxShape: BoxShape.rectangle,
                      ),
                    ),
                    title: Text(
                      customer.phone,
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
        ],
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
