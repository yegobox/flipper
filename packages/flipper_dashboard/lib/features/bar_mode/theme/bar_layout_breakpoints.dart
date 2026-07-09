import 'package:flipper_dashboard/pos_layout_breakpoints.dart';

/// Bar Mode layout breakpoints — aligned with dashboard mobile threshold.
abstract final class BarLayoutBreakpoints {
  static const double mobileMaxWidth = PosLayoutBreakpoints.mobileLayoutMaxWidth;

  static bool isBarMobileLayout(double width) => width < mobileMaxWidth;
}
