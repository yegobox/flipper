import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Define the StateProvider
final isCompositeProvider = StateProvider<bool>((ref) => false);

class ToggleButtonWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the current toggle state
    final isToggled = ref.watch(isCompositeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CompositeItem',
            style: TextStyle(fontSize: 18),
          ),
          Switch.adaptive(
            value: isToggled,
            onChanged: (value) {
              // Update the state when the toggle is switched
              ref.read(isCompositeProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }
}
