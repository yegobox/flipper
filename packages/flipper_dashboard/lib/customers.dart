// ignore_for_file: unused_result

import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'add_customer.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

class Customers extends StatefulHookConsumerWidget {
  const Customers({Key? key}) : super(key: key);

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
    final transaction =
        ref.watch(pendingTransactionStreamProvider(isExpense: false));

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Add Customer',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                // ref.refresh(customersProvider);
                ///TODO: this is supposed to make SearchCustomer refresh but for somereason it is not,debug this further
                ref.refresh(pendingTransactionStreamProvider(isExpense: false));
                _routerService.pop();
              },
            ),
          ),
          body: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child:
                    _buildCustomerList(customersRef, model, transaction.value!),
              ),
              _buildAddButton(context, model, customersRef, searchKeyword,
                  transaction.value!.id),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for a customer',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
              ref
                  .read(customerSearchStringProvider.notifier)
                  .emitString(value: "");
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          ref
              .read(customerSearchStringProvider.notifier)
              .emitString(value: value);
        },
      ),
    );
  }

  Widget _buildCustomerList(AsyncValue<List<Customer>> customersRef,
      CoreViewModel model, ITransaction transaction) {
    return customersRef.when(
      data: (customers) => ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return _buildCustomerCard(customer, model, transaction);
        },
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error', style: TextStyle(color: Colors.red)),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildCustomerCard(
      Customer customer, CoreViewModel model, ITransaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        key: Key('customer-${customer.id}'),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                await model.deleteCustomer(
                    customer.id, (message) => toast(message));
                ref
                    .refresh(customersProvider.notifier)
                    .loadCustomers(searchString: '');
              },
              backgroundColor: Colors.red,
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
              onPressed: (_) {
                model.assignToSale(
                    customerId: customer.id, transactionId: transaction.id);
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
                await model.removeFromSale(transaction: transaction);
                model.getTransactionById();
                toast("Customer removed from sale");
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.remove,
              label: 'Remove',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                customer.custNm!.substring(0, 1),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              '${customer.custNm!}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(customer.telNo ?? '',
                    style: TextStyle(color: Colors.grey[600])),
                Text(customer.custTin ?? '',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            onTap: () {
              model.assignToSale(
                  customerId: customer.id, transactionId: transaction.id);
              model.getTransactionById();
              showAlert(context,
                  onPressedOk: () {}, title: "Customer added to sale!");
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(
      BuildContext context,
      CoreViewModel model,
      AsyncValue<List<Customer>> customersRef,
      String searchKeyword,
      String id) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FlipperButton(
        color: Colors.blue,
        textColor: Colors.white,
        text: _getButtonText(customersRef, searchKeyword),
        onPressed: () =>
            _handleButtonPress(context, model, customersRef, searchKeyword, id),
      ),
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

  Future<void> _handleButtonPress(
      BuildContext context,
      CoreViewModel model,
      AsyncValue<List<Customer>> customersRef,
      String searchKeyword,
      String id) async {
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
              transactionId: id,
              searchedKey: searchKeyword,
            ),
          );
        },
      );
    } else {
      final customer = filteredCustomers.first;
      model.assignToSale(customerId: customer.id, transactionId: id);
      showAlert(context, onPressedOk: () {}, title: "Customer added to sale!");
    }
  }
}
