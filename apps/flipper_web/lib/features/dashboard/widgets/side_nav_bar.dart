import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sideNavCollapsedProvider = StateProvider<bool>((ref) => false);
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);

class SideNavBar extends ConsumerWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sideNavCollapsedProvider);
    final selectedIndex = ref.watch(selectedNavIndexProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 48 : 48,
      decoration: const BoxDecoration(
        color: Color(0xFF354A5F),
      ),
      child: Column(
        children: [
          // Navigation items
          _buildNavItem(
            Icons.home,
            'Home',
            0,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.folder,
            'Folder',
            1,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.chat_bubble_outline,
            'Chat',
            2,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.star_outline,
            'Favorites',
            3,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.share,
            'Share',
            4,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.send,
            'Send',
            5,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.video_camera_back,
            'Video',
            6,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.extension,
            'Extensions',
            7,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.calendar_today,
            'Calendar',
            8,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.people,
            'People',
            9,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.description,
            'Documents',
            10,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.lock,
            'Security',
            11,
            selectedIndex,
            ref,
          ),
          _buildNavItem(
            Icons.settings,
            'Settings',
            12,
            selectedIndex,
            ref,
          ),
          
          const Spacer(),
          
          // Bottom icon
          _buildNavItem(
            Icons.info_outline,
            'Info',
            13,
            selectedIndex,
            ref,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String tooltip,
    int index,
    int selectedIndex,
    WidgetRef ref,
  ) {
    final isSelected = selectedIndex == index;
    
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref.read(selectedNavIndexProvider.notifier).state = index;
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0070F2) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}