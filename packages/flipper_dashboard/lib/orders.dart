// ignore_for_file: unused_result
import 'dart:convert';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipe_to_complete/view/swiper_widget.dart';

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

class Product {
  final String productName;
  final double retailPrice;

  Product({required this.productName, required this.retailPrice});
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
    headers: {'Authorization': 'Bearer ${token}'},
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
    FutureProvider.autoDispose<List<Product>?>((ref) async {
  final supplier = ref.watch(selectedSupplierProvider);

  final response = await http.get(
    Uri.parse(
        'https://db.yegobox.com/api/collections/variants/records?filter=(branchId=\'${supplier.value!.branchId}\')'),
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDIyMDA1NjMsImlkIjoiZXM4Zm9kc2lxa2ljbDZwIiwidHlwZSI6ImFkbWluIn0.amcO_wouA_69M8PaGtiNB0YSWeQQxD1wIYN1p1fO2FE',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> items = data['items'];
    return items.map<Product>((item) {
      return Product(
        productName: item['productName'],
        retailPrice: item['retailPrice']?.toDouble() ?? 0,
      );
    }).toList();
  } else {
    throw Exception('Failed to load products');
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
  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productListProvider);
    final selectedSupplier = ref.watch(selectedSupplierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products loading${selectedSupplier.value!.branchId}'),
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
                      builder: (context) => const Confirm(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(products[index].productName),
                  subtitle: Text(
                      'Price: \$${products[index].retailPrice.toStringAsFixed(2)}'),
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

class Confirm extends StatelessWidget {
  const Confirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Text('hello world'),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NewSwiper(
              type: SwiperType.horizontal,
              callback: () =>
                  const SizedBox(height: 200, child: Text("swiping")),
            )),
      ],
    );
  }
}
