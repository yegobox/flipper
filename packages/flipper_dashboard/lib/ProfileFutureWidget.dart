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
                height: 40,
                width: 40,
                child: ProfileWidget(
                  branch: branch,
                  sessionActive: true,
                  size: 25,
                  showIcon: false,
                ),
              ),
            );
          },
          loading: () {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 20,
                ),
              ),
            );
          },
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      },
    );
  }
}
