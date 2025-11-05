import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF354A5F),
      ),
      child: Row(
        children: [
          // Left section with hamburger and SAP logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0070F2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SAP',
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
                  icon: const Icon(Icons.location_on, color: Colors.white, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, color: Colors.white, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.apps, color: Colors.white, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.help_outline, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}