import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileFutureWidget extends StatelessWidget {
  const ProfileFutureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final activeBranch = ref.watch(activeBranchProvider);
        return activeBranch.when(
          data: (branch) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SizedBox(
                height: 48,
                width: 48,
                child: ProfileWidget(
                  branch: branch,
                  sessionActive: true,
                  size: 25,
                  showIcon: false,
                ),
              ),
            );
          },
          // Keep the header balanced while loading or if the branch can't be
          // read: a placeholder avatar rather than an empty slot.
          loading: _placeholder,
          error: (_, __) => _placeholder(),
        );
      },
    );
  }

  // 48dp slot (touch target) around a 40dp avatar; 12 + 4 = 16dp from the
  // edge, matching the leading side.
  static Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: SizedBox(
        height: 48,
        width: 48,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 20,
          ),
        ),
      ),
    );
  }
}
