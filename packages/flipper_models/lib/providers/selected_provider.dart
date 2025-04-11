import 'package:flipper_models/db_model_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_provider.g.dart'; // Ensure this file is generated

@riverpod
class SelectedSupplier extends _$SelectedSupplier {
  @override
  Branch? build() {
    return null;
  }

  void setSupplier(Branch supplier) {
    state = supplier;
  }
}
