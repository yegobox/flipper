import 'package:flipper_ui/riverpod.dart';
import 'package:flipper_ui/style_widget/CouponTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            child: CouponTextField(
              couponController: couponController,
              couponValidationState: couponValidationState,
              onCouponChanged: _onCouponChanged,
            ),
          ),
      ],
    );
  }
}
