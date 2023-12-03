// ignore_for_file: unused_result
import 'dart:convert';
import 'package:flipper_models/isar_models.dart';

import 'package:flutter/foundation.dart' as found;
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'Confirm.dart';

class Supplier {
  final int businessId;
  final int branchId;
  final String name;

  Supplier({
    required this.businessId,
    required this.branchId,
    required this.name,
  });
}

final supplierListProvider =
    FutureProvider.autoDispose<List<Supplier>>((ref) async {
  final keyword = ref.read(searchQueryProvider.notifier).state;

  // Check if the keyword is null or empty, and return an empty list if true
  if (keyword.isEmpty) {
    return [];
  }
  String token = ProxyService.box.getBearerToken()!;

  final response = await http.get(
    Uri.parse('https://apihub.yegobox.com/searchAlike?name=$keyword'),
    headers: {'Authorization': '${token}'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<Supplier>((item) {
      return Supplier(
        businessId: item['business']['id'],
        branchId: item['branch']['id'],
        name: item['business']['name'],
      );
    }).toList();
  } else {
    throw Exception('Failed to load suppliers');
  }
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchQueryControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

class Orders extends StatefulHookConsumerWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends ConsumerState<Orders> {
  @override
  Widget build(BuildContext context) {
    final searchController = ref.read(searchQueryControllerProvider);
    final suppliers = ref.watch(supplierListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Supplier'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
                ref.refresh(supplierListProvider);
              },
              decoration: const InputDecoration(
                labelText: 'Search Supplier',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: suppliers.when(
              data: (suppliers) {
                return ListView.builder(
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suppliers[index].name),
                      onTap: () {
                        ref
                            .read(selectedSupplierProvider.notifier)
                            .setSupplier(supplier: suppliers[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListScreen(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: Text("No supplier choosen")),
              error: (error, stack) => Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }
}

final productListProvider =
    FutureProvider.autoDispose<List<Variant>?>((ref) async {
  final supplier = ref.watch(selectedSupplierProvider);
  String? token;
  String? url;
  if (found.kDebugMode) {
    token = await ProxyService.remote.getToken(AppSecrets.apiUrlDebug,
        AppSecrets.debugPassword, AppSecrets.debugEmail);
    url = AppSecrets.apiUrlDebug;
  } else {
    token = await ProxyService.remote.getToken(
        AppSecrets.apiUrlProd, AppSecrets.prodPassword, AppSecrets.prodEmail);
    url = AppSecrets.apiUrlProd;
  }
  final response = await http.get(
    Uri.parse(
        '${url}/api/collections/variants/records?filter=(branchId=\'${supplier.value!.branchId}\')'),
    headers: {
      'Authorization': 'Bearer ${token}',
    },
  );
  if (response.statusCode == 200) {
    // Successful response with status code 200
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['items'] is List && data['items']?.isEmpty) {
      throw Exception('No product added yet for this supplier');
    }
    final List<dynamic> items = data['items'];

    // Map the list of items to Variant objects using Variant.fromJson
    List<Variant> variants = items.map<Variant>((item) {
      print(item);
      return Variant.fromJson(item);
    }).toList();
    // Return the list of Variant objects
    return variants;
  } else {
    // Failed response with a status code other than 200
    throw Exception(
        'Failed to load products. Status Code: ${response.statusCode}');
  }
});

final selectedSupplierProvider =
    StateNotifierProvider<SelectedItemNotifier, AsyncValue<Supplier>>((ref) {
  return SelectedItemNotifier();
});

class SelectedItemNotifier extends StateNotifier<AsyncValue<Supplier>> {
  SelectedItemNotifier() : super(const AsyncLoading());
  void setSupplier({required Supplier supplier}) {
    state = AsyncData(supplier);
  }
}

class ProductListScreen extends StatefulHookConsumerWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen> {
  Color hexToColor(String code) {
    if (code.isNotEmpty) {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return Color(
          int.parse("#FF0000".substring(1, 7), radix: 16) + 0xFF000000);
    }
  }

  List<Color> extractColors(List<Variant> variants) {
    return variants.map((variant) => hexToColor(variant.color)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productListProvider);
    final selectedSupplier = ref.watch(selectedSupplierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products ${selectedSupplier.value!.branchId}'),
      ),
      body: productsAsyncValue.when(
        data: (products) {
          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Confirm(
                        products: products,
                        colors: extractColors(products),
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(products[index].name,
                      style: TextStyle(color: Colors.black)),
                  subtitle: Text(
                      'Price: \$${products[index].retailPrice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.black)),
                  // Add more details as needed
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
