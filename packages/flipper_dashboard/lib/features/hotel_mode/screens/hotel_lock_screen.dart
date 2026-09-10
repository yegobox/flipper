import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_lock_desktop.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_lock_mobile.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HotelLockScreen extends ConsumerWidget {
  const HotelLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (HotelLayoutBreakpoints.isHotelMobileLayout(constraints.maxWidth)) {
          return const HotelLockMobileScreen();
        }
        return const HotelLockDesktopScreen();
      },
    );
  }
}
