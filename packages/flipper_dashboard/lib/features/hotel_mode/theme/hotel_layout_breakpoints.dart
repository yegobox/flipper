import 'package:flipper_dashboard/pos_layout_breakpoints.dart';

/// Hotel Mode layout breakpoints — aligned with the dashboard mobile threshold.
abstract final class HotelLayoutBreakpoints {
  static const double mobileMaxWidth = PosLayoutBreakpoints.mobileLayoutMaxWidth;

  static bool isHotelMobileLayout(double width) => width < mobileMaxWidth;
}
