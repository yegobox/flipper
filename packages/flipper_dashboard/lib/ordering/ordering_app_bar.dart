import 'dart:io';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class OrderingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrderingAppBar({Key? key, required this.isOrdering}) : super(key: key);

  final bool isOrdering;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          isOrdering ? 'New Order' : 'Point of Sale',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
