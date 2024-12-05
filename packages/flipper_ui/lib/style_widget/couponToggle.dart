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
          .writeInt(key: 'numberOfPayments', value: int.parse(value));
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
            ),
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToggled = useState(false);
    final couponController = useTextEditingController();
    final couponValidationState = ref.watch(couponValidationProvider);

    void _toggleSwitch(bool value) {
      isToggled.value = value;
      if (!isToggled.value) {
        couponController.clear();
        ref.read(couponValidationProvider.notifier).state =
            const AsyncValue.data(null);
      }
    }

    void _onCouponChanged(String value) {
      ref.read(couponValidationProvider.notifier).validateCoupon(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Apply Coupon'),
            Switch(
              value: isToggled.value,
              onChanged: _toggleSwitch,
            ),
          ],
        ),
        if (isToggled.value)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomizableTextField(
              controller: couponController,
              validateState: couponValidationState,
              onCouponChanged: _onCouponChanged,
            ),
          ),
      ],
    );
  }
}
