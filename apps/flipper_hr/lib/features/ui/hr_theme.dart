/// Flipper HR's Material theme, and how overlays keep it.
///
/// The pages built on [HrTokens] (the shell, the overview, payroll) and the
/// ones that use plain Material (`Card`, `FilledButton`, `TextField`) used to
/// look like two apps: the design system's cyan primary and tinted card
/// surfaces against HR's blue and white. [hrTheme] maps Material's slots onto
/// the HR tokens, so a `Card` *is* an HR panel and a `FilledButton` *is* the HR
/// primary button, on web and inside the mobile app alike.
library;

import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ThemeData hrTheme(ThemeData base) {
  final scheme = base.colorScheme.copyWith(
    primary: HrTokens.accent,
    onPrimary: Colors.white,
    primaryContainer: HrTokens.accentTint,
    onPrimaryContainer: HrTokens.accent,
    secondary: HrTokens.accent,
    onSecondary: Colors.white,
    secondaryContainer: HrTokens.accentTint,
    onSecondaryContainer: HrTokens.accent,
    surface: HrTokens.surface,
    onSurface: HrTokens.ink1,
    onSurfaceVariant: HrTokens.ink2,
    surfaceContainerLowest: HrTokens.surface,
    surfaceContainerLow: HrTokens.surface,
    surfaceContainer: HrTokens.surface2,
    surfaceContainerHigh: HrTokens.surface2,
    surfaceContainerHighest: HrTokens.surface2,
    surfaceTint: Colors.transparent,
    outline: HrTokens.border,
    outlineVariant: HrTokens.line,
    error: HrTokens.danger,
  );

  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusSm),
        borderSide: BorderSide(color: color, width: width),
      );

  return base.copyWith(
    colorScheme: scheme,
    // Page titles on the Material pages read like the rest of HR.
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineSmall?.merge(HrType.display),
    ),
    scaffoldBackgroundColor: HrTokens.workspaceBg,
    dividerTheme: const DividerThemeData(color: HrTokens.line, space: 1),
    cardTheme: CardThemeData(
      color: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusLg),
        side: const BorderSide(color: HrTokens.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(style: hrPrimaryButtonStyle()),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: hrSecondaryButtonStyle(),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HrTokens.accent,
        textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: HrTokens.surface2,
      labelStyle: const TextStyle(color: HrTokens.ink3),
      floatingLabelStyle: const TextStyle(color: HrTokens.accent),
      hintStyle: const TextStyle(color: HrTokens.ink4),
      border: border(HrTokens.border),
      enabledBorder: border(HrTokens.border),
      focusedBorder: border(HrTokens.accent, 1.5),
      errorBorder: border(HrTokens.danger),
      focusedErrorBorder: border(HrTokens.danger, 1.5),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusLg),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HrTokens.radiusLg),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusMd),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: HrTokens.surface,
      selectedColor: HrTokens.accentTint,
      side: const BorderSide(color: HrTokens.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: HrTokens.accent,
      linearTrackColor: HrTokens.surface2,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

/// Wraps an overlay's content so it keeps HR's theme and provider scope.
///
/// Overlays open on the root navigator so their barrier covers the whole
/// screen, app bar and bottom bar included. Inside the mobile app that
/// navigator is the host's, which sits above HR's [Theme] and nested
/// [ProviderScope]; this carries both across.
Widget hrOverlay(BuildContext context, Widget child) {
  return UncontrolledProviderScope(
    container: ProviderScope.containerOf(context, listen: false),
    child: Theme(data: Theme.of(context), child: child),
  );
}

/// [showDialog] for HR: themed, scoped, and over the whole screen.
Future<T?> showHrDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => hrOverlay(context, builder(dialogContext)),
  );
}
