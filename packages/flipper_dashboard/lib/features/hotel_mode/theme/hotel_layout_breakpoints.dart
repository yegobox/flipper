import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flutter/widgets.dart';

/// Hotel Mode layout breakpoints — aligned with the dashboard mobile threshold.
abstract final class HotelLayoutBreakpoints {
  static const double mobileMaxWidth =
      PosLayoutBreakpoints.mobileLayoutMaxWidth;

  static bool isHotelMobileLayout(double width) => width < mobileMaxWidth;
}

/// The mobile flag [HotelModeHost] picked from its own pane constraints.
///
/// The host sits beside the dashboard side menu, so its pane can be narrower
/// than the window. Widgets that must agree with the host on which screen is
/// drawn (the desk nav hiding Today) read this rather than the window width.
class HotelLayoutScope extends InheritedWidget {
  const HotelLayoutScope({
    super.key,
    required this.mobile,
    required super.child,
  });

  final bool mobile;

  /// The host's flag, or null outside a [HotelModeHost].
  static bool? maybeMobileOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HotelLayoutScope>()?.mobile;

  @override
  bool updateShouldNotify(HotelLayoutScope oldWidget) =>
      mobile != oldWidget.mobile;
}
