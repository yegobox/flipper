import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/riverpod.dart';
import 'package:flipper_ui/style_widget/CouponTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NumberOfPaymentsToggle extends HookConsumerWidget {
  final TextEditingController paymentController;
  NumberOfPaymentsToggle({Key? key, required this.paymentController})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToggled = useState(false);

    final numberOfPaymentState = ref.watch(couponValidationProvider);

    void _toggleSwitch(bool value) {
      isToggled.value = value;
      if (!isToggled.value) {
        paymentController.clear();
        ref.read(couponValidationProvider.notifier).state =
            const AsyncValue.data(null);
      }
    }

    void _onNumberOfPaymentChanged(String value) {
      ProxyService.box
          .writeInt(key: 'numberOfPayments', value: int.tryParse(value) ?? 1);
      ref.read(couponValidationProvider.notifier).validateCoupon(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Number of Payments'),
            Switch(
              value: isToggled.value,
              onChanged: _toggleSwitch,
              activeThumbColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.blue;
                }
                return Colors.grey;
              }),
            )
          ],
        ),
        if (isToggled.value)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomizableTextField(
              wording: "Number of Payments",
              controller: paymentController,
              validateState: numberOfPaymentState,
              onCouponChanged: _onNumberOfPaymentChanged,
            ),
          ),
      ],
    );
  }
}

class CouponToggle extends HookConsumerWidget {
  final Function(String)? onCodeChanged;
  final String? errorMessage;
  final bool? isValidating;

  const CouponToggle({
    Key? key,
    this.onCodeChanged,
    this.errorMessage,
    this.isValidating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToggled = useState(false);
    final couponController = useTextEditingController();
    final couponValidationState = ref.watch(couponValidationProvider);

    void _toggleSwitch(bool value) {
      isToggled.value = value;
      if (!isToggled.value) {
        couponController.clear();
        onCodeChanged?.call('');
        ref.read(couponValidationProvider.notifier).state =
            const AsyncValue.data(null);
      }
    }

    void _onCouponChanged(String value) {
      onCodeChanged?.call(value);
      ref.read(couponValidationProvider.notifier).validateCoupon(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Apply Discount Code'),
            Switch(
              value: isToggled.value,
              onChanged: _toggleSwitch,
              activeThumbColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.blue;
                }
                return Colors.grey;
              }),
            )
          ],
        ),
        if (isToggled.value)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomizableTextField(
                  controller: couponController,
                  validateState: couponValidationState,
                  onCouponChanged: _onCouponChanged,
                  wording: 'Discount Code',
                ),
                if (isValidating == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Validating code...',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                if (errorMessage != null && errorMessage!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
