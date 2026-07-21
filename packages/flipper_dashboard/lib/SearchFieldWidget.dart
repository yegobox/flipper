import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchFieldWidget extends ConsumerWidget {
  const SearchFieldWidget({
    Key? key,
    required this.controller,
    this.hintText,
    this.densePadding = false,
    this.showTrailingToolbar = true,
    this.showNoticesButton = true,
    this.showOrderButton = true,
    this.showIncomingButton = true,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final bool densePadding;
  final bool showTrailingToolbar;
  final bool showNoticesButton;
  final bool showOrderButton;
  final bool showIncomingButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDatePicker = ref.watch(buttonIndexProvider) == 1;

    return Padding(
      padding: densePadding
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
          : const EdgeInsets.all(8),
      child: SearchField(
        controller: controller,
        showAddButton: true,
        showDatePicker: showDatePicker,
        showIncomingButton: showIncomingButton,
        showOrderButton: showOrderButton,
        showNoticesButton: showNoticesButton,
        hintText: hintText ?? 'Search products, transactions...',
        showTrailingToolbar: showTrailingToolbar,
      ),
    );
  }
}
