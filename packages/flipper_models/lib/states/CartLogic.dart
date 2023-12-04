import 'package:flipper_models/isar_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'CartLogic.g.dart';

@riverpod
class CartLogic extends _$CartLogic {
  @override
  List<Variant>? build() {
    return [];
  }

  void addItemToCart({required Variant variant}) {
    // create a new list with the added variant and assign it to the state
    state = [...state!, variant];
  }

  void deleteItemFromCart({required Variant variant}) {
    // create a new list without the variant and assign it to the state
    state = state!.where((item) => item != variant).toList();
  }
}
