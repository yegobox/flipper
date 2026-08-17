import 'package:flutter/widgets.dart';

/// Builder for the brand panel filling the right half of the shared sign-in and
/// sign-up screens on desktop widths.
///
/// flipper_web leaves this null and keeps Books' own panel (`WebBrandPanel`).
/// Apps that reuse this login flow as a package — e.g. `flipper_hr` — assign
/// their own panel in `main()` before the router is built, so the screens they
/// share still carry their product's identity.
WidgetBuilder? brandPanelBuilder;
