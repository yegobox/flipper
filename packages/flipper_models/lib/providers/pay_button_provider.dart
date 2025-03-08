import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pay_button_provider.g.dart';

enum ButtonType {
  pay,
  completeNow,
}

@riverpod
class PayButtonState extends _$PayButtonState {
  @override
  Map<ButtonType, bool> build() {
    return {
      ButtonType.pay: false, // Initial state: not loading
      ButtonType.completeNow: false, // Initial state: not loading
    };
  }

  void startLoading(ButtonType buttonType) {
    state = {...state, buttonType: true}; // Set specific button to loading
  }

  void stopLoading([ButtonType? buttonType]) {
    if (buttonType == null) {
      // Stop loading for all buttons
      state = {
        for (var key in state.keys) key: false,
      };
    } else {
      // Stop loading for a specific button
      state = {...state, buttonType: false};
    }
  }

  bool isLoading(ButtonType buttonType) {
    return state[buttonType] ?? false;
  }
}

@riverpod
class SelectedButtonType extends _$SelectedButtonType {
  @override
  ButtonType build() {
    return ButtonType.pay; // Default to "Pay" button
  }

  void setButtonType(ButtonType type) {
    state = type;
  }
}
