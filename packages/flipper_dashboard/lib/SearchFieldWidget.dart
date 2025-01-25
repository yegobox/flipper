import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchFieldWidget extends ConsumerWidget {
  const SearchFieldWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDatePicker = ref.watch(buttonIndexProvider) == 1;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchField(
        controller: controller,
        showAddButton: true,
        showDatePicker: showDatePicker,
        showIncomingButton: true,
        showOrderButton: true,
      ),
    );
  }
}
