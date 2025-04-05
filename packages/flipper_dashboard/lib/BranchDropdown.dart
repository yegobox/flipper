// ignore_for_file: unused_result

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/style_widget/text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BranchDropdown extends ConsumerWidget {
  const BranchDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBranches = ref.watch(branchesProvider((includeSelf: true)));

    return DropdownButtonHideUnderline(
      child: asyncBranches.when(
        data: (branches) {
          return DropdownButton<Branch>(
            value: ref.watch(selectedBranchProvider),
            hint: const Flippertext(
              'Select Branch',
              color: Colors.black,
            ),
            onChanged: (Branch? newBranch) {
              if (newBranch != null) {
                ref.read(selectedBranchProvider.notifier).state = newBranch;
              }
            },
            items: branches.map<DropdownMenuItem<Branch>>((Branch branch) {
              return DropdownMenuItem<Branch>(
                value: branch,
                child: Text(
                  branch.name ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black, // Text color to match the AppBar theme
                  ),
                ),
              );
            }).toList(),
          );
        },
        loading: () => CircularProgressIndicator(), // Show loading indicator
        error: (error, stackTrace) =>
            Text('Error: $error'), // Show error message
      ),
    );
  }
}
