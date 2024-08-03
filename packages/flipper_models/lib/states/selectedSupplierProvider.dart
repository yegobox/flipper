import 'package:flipper_models/realm/schemas.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedSupplierProvider =
    StateNotifierProvider<SelectedItemNotifier, AsyncValue<Branch>>((ref) {
  return SelectedItemNotifier();
});

class SelectedItemNotifier extends StateNotifier<AsyncValue<Branch>> {
  SelectedItemNotifier() : super(const AsyncLoading());
  void setSupplier({required Branch supplier}) {
    state = AsyncData(supplier);
  }
}
