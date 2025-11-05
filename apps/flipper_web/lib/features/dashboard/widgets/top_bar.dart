import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/dashboard/widgets/side_nav_bar.dart';
import 'package:flipper_web/features/dashboard/widgets/branch_selection_modal.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(color: Color(0xFF354A5F)),
      child: Row(
        children: [
          // Left section with hamburger and Flipper's TAP logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(sideNavCollapsedProvider.notifier).state = !ref
                        .read(sideNavCollapsedProvider);
                  },
                  icon: const Icon(Icons.menu, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0070F2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'TAP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.home, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Right section with icons and user
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.white, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.apps, color: Colors.white, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, child) {
                    final selectedBranch = ref.watch(selectedBranchProvider);
                    final branchInitials =
                        selectedBranch?.name
                            .split(' ')
                            .take(2)
                            .map(
                              (word) =>
                                  word.isNotEmpty ? word[0].toUpperCase() : '',
                            )
                            .join('') ??
                        'BR';

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const BranchSelectionModal(),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF0070F2),
                          child: Text(
                            branchInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
