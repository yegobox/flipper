import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pay_button_provider.g.dart';

@riverpod
class PayButtonLoading extends _$PayButtonLoading {
  @override
  bool build() {
    return false; // Initial state: not loading
  }

  void startLoading() {
    state = true; // Set loading state to true
  }

  void stopLoading() {
    state = false; // Set loading state to false
  }
}
