import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_rooms_desktop.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_rooms_mobile.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HotelRoomsScreen extends ConsumerWidget {
  const HotelRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (HotelLayoutBreakpoints.isHotelMobileLayout(constraints.maxWidth)) {
          return const HotelRoomsMobileScreen();
        }
        return const HotelRoomsDesktopScreen();
      },
    );
  }
}
