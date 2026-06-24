import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;

class OrderingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrderingAppBar({Key? key, required this.isOrdering}) : super(key: key);

  final bool isOrdering;

  @override
  Widget build(BuildContext context) {
    // Web-safe platform detection
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      return AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          isOrdering ? 'New Order' : 'Point of Sale',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (!isOrdering)
            IconButton(
              icon: const Icon(Icons.receipt_long_outlined),
              onPressed: () => null,
              tooltip: 'Transaction History',
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => null,
            tooltip: 'More Options',
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Size get preferredSize {
    // Match the platform check in build()
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    return isMobile ? const Size.fromHeight(kToolbarHeight) : Size.zero;
  }
}
