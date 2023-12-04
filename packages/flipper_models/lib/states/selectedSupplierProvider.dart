import 'package:hooks_riverpod/hooks_riverpod.dart';

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
