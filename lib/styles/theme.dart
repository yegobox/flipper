import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class FluentTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const FluentTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// Specifies the color and typography values for descendant widgets.
  final FThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  static FThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FluentTheme>()!.data;
  }

  static FThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FluentTheme>()?.data;
  }

  @override
  Widget build(BuildContext context) {
    return _FluentTheme(
      data: data,
      child: IconTheme(
        data: data.iconTheme,
        child: child,
      ),
    );
  }
}

class _FluentTheme extends InheritedTheme {
  const _FluentTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final FThemeData data;

  @override
  bool updateShouldNotify(covariant _FluentTheme oldWidget) =>
      oldWidget.data != data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return _FluentTheme(child: child, data: data);
  }
}

/// An interpolation between two [FThemeData]s.
///
/// This class specializes the interpolation of [Tween<ThemeData>] to call the
/// [FThemeData.lerp] method.
///
/// See [Tween] for a discussion on how to use interpolation objects.
class ThemeDataTween extends Tween<FThemeData> {
  /// Creates a [FThemeData] tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  ThemeDataTween({FThemeData? begin, FThemeData? end})
      : super(begin: begin, end: end);

  @override
  FThemeData lerp(double t) => FThemeData.lerp(begin!, end!, t);
}

/// Animated version of [Theme] which automatically transitions the colors,
/// etc, over a given duration whenever the given theme changes.
///
/// Here's an illustration of what using this widget looks like, using a [curve]
/// of [Curves.elasticInOut].
/// {@animation 250 266 https://flutter.github.io/assets-for-api-docs/assets/widgets/animated_theme.mp4}
///
/// See also:
///
///  * [FluentTheme], which [AnimatedFluentTheme] uses to actually apply the interpolated
///    theme.
///  * [FThemeData], which describes the actual configuration of a theme.
///  * [FluentApp], which includes an [AnimatedFluentTheme] widget configured via
///    the [FluentApp.theme] argument.
class AnimatedFluentTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated theme.
  ///
  /// By default, the theme transition uses a linear curve. The [data] and
  /// [child] arguments must not be null.
  const AnimatedFluentTheme({
    Key? key,
    required this.data,
    Curve curve = Curves.linear,
    Duration duration = kThemeAnimationDuration,
    VoidCallback? onEnd,
    required this.child,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// Specifies the color and typography values for descendant widgets.
  final FThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  _AnimatedFluentThemeState createState() => _AnimatedFluentThemeState();
}

class _AnimatedFluentThemeState
    extends AnimatedWidgetBaseState<AnimatedFluentTheme> {
  ThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data,
            (dynamic value) => ThemeDataTween(begin: value as FThemeData))!
        as ThemeDataTween;
  }

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      child: widget.child,
      data: _data!.evaluate(animation),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<ThemeDataTween>('data', _data,
        showName: false, defaultValue: null));
  }
}

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}

const standartCurve = Curves.easeInOut;

/// Defines the default theme for a [FluentApp] or [FluentTheme].
@immutable
class FThemeData with Diagnosticable {
  final Typography typography;

  final AccentColor accentColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color inactiveBackgroundColor;
  final Color disabledColor;
  final Color shadowColor;
  final Color scaffoldBackgroundColor;
  final Color acrylicBackgroundColor;
  final Color micaBackgroundColor;

  final Duration fasterAnimationDuration;
  final Duration fastAnimationDuration;
  final Duration mediumAnimationDuration;
  final Duration slowAnimationDuration;
  final Curve animationCurve;

  /// The mouse cursor used by many inputs, such as [Button],
  /// [RadioButton] and [ToggleSwitch]. By default, if the
  /// state is pressing or hovering, [SystemMouseCursors.click]
  /// is used, otherwise [MouseCursor.defer] is used.
  final ButtonState<MouseCursor> inputMouseCursor;

  final Brightness brightness;
  final VisualDensity visualDensity;

  final NavigationPaneThemeData navigationPaneTheme;
  final BottomNavigationThemeData bottomNavigationTheme;
  final BottomSheetThemeData bottomSheetTheme;
  final CheckboxThemeData checkboxTheme;
  final ChipThemeData chipTheme;
  final ContentDialogThemeData dialogTheme;
  final DividerThemeData dividerTheme;
  final FocusThemeData focusTheme;
  final IconThemeData iconTheme;
  final InfoBarThemeData infoBarTheme;
  final PillButtonBarThemeData pillButtonBarTheme;
  final RadioButtonThemeData radioButtonTheme;
  final ScrollbarThemeData scrollbarTheme;
  final SliderThemeData sliderTheme;
  final SplitButtonThemeData splitButtonTheme;
  final SnackbarThemeData snackbarTheme;
  final ToggleButtonThemeData toggleButtonTheme;
  final ToggleSwitchThemeData toggleSwitchTheme;
  final TooltipThemeData tooltipTheme;

  final ButtonThemeData buttonTheme;

  const FThemeData.raw({
    required this.typography,
    required this.accentColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.inactiveBackgroundColor,
    required this.disabledColor,
    required this.shadowColor,
    required this.fasterAnimationDuration,
    required this.fastAnimationDuration,
    required this.mediumAnimationDuration,
    required this.slowAnimationDuration,
    required this.animationCurve,
    required this.brightness,
    required this.visualDensity,
    required this.scaffoldBackgroundColor,
    required this.acrylicBackgroundColor,
    required this.micaBackgroundColor,
    required this.buttonTheme,
    required this.checkboxTheme,
    required this.chipTheme,
    required this.toggleSwitchTheme,
    required this.bottomNavigationTheme,
    required this.iconTheme,
    required this.splitButtonTheme,
    required this.dialogTheme,
    required this.tooltipTheme,
    required this.dividerTheme,
    required this.navigationPaneTheme,
    required this.radioButtonTheme,
    required this.toggleButtonTheme,
    required this.sliderTheme,
    required this.infoBarTheme,
    required this.focusTheme,
    required this.scrollbarTheme,
    required this.inputMouseCursor,
    required this.snackbarTheme,
    required this.pillButtonBarTheme,
    required this.bottomSheetTheme,
  });

  static FThemeData light() {
    return FThemeData(brightness: Brightness.light);
  }

  static FThemeData dark() {
    return FThemeData(brightness: Brightness.dark);
  }

  factory FThemeData({
    Brightness? brightness,
    VisualDensity? visualDensity,
    Typography? typography,
    String? fontFamily,
    AccentColor? accentColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? inactiveBackgroundColor,
    Color? disabledColor,
    Color? scaffoldBackgroundColor,
    Color? acrylicBackgroundColor,
    Color? micaBackgroundColor,
    Color? shadowColor,
    ButtonState<MouseCursor>? inputMouseCursor,
    Duration? fasterAnimationDuration,
    Duration? fastAnimationDuration,
    Duration? mediumAnimationDuration,
    Duration? slowAnimationDuration,
    Curve? animationCurve,
    BottomNavigationThemeData? bottomNavigationTheme,
    BottomSheetThemeData? bottomSheetTheme,
    ButtonThemeData? buttonTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    ToggleSwitchThemeData? toggleSwitchTheme,
    IconThemeData? iconTheme,
    SplitButtonThemeData? splitButtonTheme,
    ContentDialogThemeData? dialogTheme,
    TooltipThemeData? tooltipTheme,
    DividerThemeData? dividerTheme,
    NavigationPaneThemeData? navigationPaneTheme,
    RadioButtonThemeData? radioButtonTheme,
    ToggleButtonThemeData? toggleButtonTheme,
    SliderThemeData? sliderTheme,
    InfoBarThemeData? infoBarTheme,
    PillButtonBarThemeData? pillButtonBarTheme,
    FocusThemeData? focusTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackbarThemeData? snackbarTheme,
  }) {
    brightness ??= Brightness.light;

    final bool isLight = brightness == Brightness.light;

    visualDensity ??= VisualDensity.adaptivePlatformDensity;
    fasterAnimationDuration ??= const Duration(milliseconds: 90);
    fastAnimationDuration ??= const Duration(milliseconds: 150);
    mediumAnimationDuration ??= const Duration(milliseconds: 300);
    slowAnimationDuration ??= const Duration(milliseconds: 500);
    animationCurve ??= standartCurve;
    accentColor ??= Colors.blue;
    activeColor ??= Colors.white;
    inactiveColor ??= isLight ? Colors.black : Colors.white;
    inactiveBackgroundColor ??=
        isLight ? const Color(0xFFd6d6d6) : const Color(0xFF292929);
    disabledColor ??=
        isLight ? const Color(0xFF838383) : Colors.grey[80].withOpacity(0.6);
    shadowColor ??= isLight ? Colors.black : Colors.grey[130];
    scaffoldBackgroundColor ??=
        isLight ? const Color(0xFFf9f9f9) : const Color(0xFF272727);
    acrylicBackgroundColor ??= isLight
        ? const Color.fromARGB(204, 255, 255, 255)
        : const Color(0x7F1e1e1e);
    micaBackgroundColor ??=
        isLight ? const Color(0xFFf3f3f3) : const Color(0xFF202020);
    typography = Typography.standard(brightness: brightness)
        .merge(typography)
        .apply(fontFamily: fontFamily);
    inputMouseCursor ??= ButtonState.resolveWith((states) {
      if (states.isHovering || states.isPressing) {
        return SystemMouseCursors.click;
      } else {
        return MouseCursor.defer;
      }
    });
    focusTheme = FocusThemeData.standard(
      glowColor: accentColor.withOpacity(0.15),
      primaryBorderColor: inactiveColor,
      secondaryBorderColor: scaffoldBackgroundColor,
    ).merge(focusTheme);
    buttonTheme ??= const ButtonThemeData();
    checkboxTheme ??= const CheckboxThemeData();
    chipTheme ??= const ChipThemeData();
    toggleButtonTheme ??= const ToggleButtonThemeData();
    toggleSwitchTheme ??= const ToggleSwitchThemeData();
    iconTheme ??= isLight
        ? const IconThemeData(color: Colors.black, size: 18.0)
        : const IconThemeData(color: Colors.white, size: 18.0);
    splitButtonTheme ??= const SplitButtonThemeData();
    dialogTheme ??= const ContentDialogThemeData();
    tooltipTheme ??= const TooltipThemeData();
    dividerTheme ??= const DividerThemeData();
    navigationPaneTheme ??= NavigationPaneThemeData.standard(
      animationCurve: animationCurve,
      animationDuration: fastAnimationDuration,
      backgroundColor: micaBackgroundColor,
      disabledColor: disabledColor,
      highlightColor: accentColor,
      inputMouseCursor: inputMouseCursor,
      typography: typography,
      inactiveColor: inactiveColor,
    );
    radioButtonTheme ??= const RadioButtonThemeData();
    sliderTheme ??= const SliderThemeData();
    infoBarTheme ??= const InfoBarThemeData();
    pillButtonBarTheme ??= const PillButtonBarThemeData();
    scrollbarTheme ??= const ScrollbarThemeData();
    bottomNavigationTheme ??= const BottomNavigationThemeData();
    snackbarTheme ??= const SnackbarThemeData();
    bottomSheetTheme ??= const BottomSheetThemeData();
    return FThemeData.raw(
      brightness: brightness,
      visualDensity: visualDensity,
      fasterAnimationDuration: fasterAnimationDuration,
      fastAnimationDuration: fastAnimationDuration,
      mediumAnimationDuration: mediumAnimationDuration,
      slowAnimationDuration: slowAnimationDuration,
      animationCurve: animationCurve,
      accentColor: accentColor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      inactiveBackgroundColor: inactiveBackgroundColor,
      disabledColor: disabledColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      acrylicBackgroundColor: acrylicBackgroundColor,
      micaBackgroundColor: micaBackgroundColor,
      shadowColor: shadowColor,
      bottomNavigationTheme: bottomNavigationTheme,
      buttonTheme: buttonTheme,
      checkboxTheme: checkboxTheme,
      chipTheme: chipTheme,
      dialogTheme: dialogTheme,
      dividerTheme: dividerTheme,
      focusTheme: focusTheme,
      iconTheme: iconTheme,
      infoBarTheme: infoBarTheme,
      navigationPaneTheme: navigationPaneTheme,
      radioButtonTheme: radioButtonTheme,
      scrollbarTheme: scrollbarTheme,
      sliderTheme: sliderTheme,
      splitButtonTheme: splitButtonTheme,
      toggleButtonTheme: toggleButtonTheme,
      toggleSwitchTheme: toggleSwitchTheme,
      tooltipTheme: tooltipTheme,
      typography: typography,
      inputMouseCursor: inputMouseCursor,
      snackbarTheme: snackbarTheme,
      pillButtonBarTheme: pillButtonBarTheme,
      bottomSheetTheme: bottomSheetTheme,
    );
  }

  static FThemeData lerp(FThemeData a, FThemeData b, double t) {
    return FThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      visualDensity: t < 0.5 ? a.visualDensity : b.visualDensity,
      accentColor: AccentColor.lerp(a.accentColor, b.accentColor, t),
      typography: Typography.lerp(a.typography, b.typography, t),
      activeColor: Color.lerp(a.activeColor, b.activeColor, t)!,
      inactiveColor: Color.lerp(a.inactiveColor, b.inactiveColor, t)!,
      inactiveBackgroundColor:
          Color.lerp(a.inactiveBackgroundColor, b.inactiveBackgroundColor, t)!,
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t)!,
      scaffoldBackgroundColor:
          Color.lerp(a.scaffoldBackgroundColor, b.scaffoldBackgroundColor, t)!,
      acrylicBackgroundColor:
          Color.lerp(a.acrylicBackgroundColor, b.acrylicBackgroundColor, t)!,
      micaBackgroundColor:
          Color.lerp(a.micaBackgroundColor, b.micaBackgroundColor, t)!,
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t)!,
      fasterAnimationDuration:
          lerpDuration(a.fasterAnimationDuration, b.fasterAnimationDuration, t),
      fastAnimationDuration:
          lerpDuration(a.fastAnimationDuration, b.fastAnimationDuration, t),
      mediumAnimationDuration:
          lerpDuration(a.mediumAnimationDuration, b.mediumAnimationDuration, t),
      slowAnimationDuration:
          lerpDuration(a.slowAnimationDuration, b.slowAnimationDuration, t),
      animationCurve: t < 0.5 ? a.animationCurve : b.animationCurve,
      inputMouseCursor: t < 0.5 ? a.inputMouseCursor : b.inputMouseCursor,
      buttonTheme: ButtonThemeData.lerp(a.buttonTheme, b.buttonTheme, t),
      checkboxTheme:
          CheckboxThemeData.lerp(a.checkboxTheme, b.checkboxTheme, t),
      chipTheme: ChipThemeData.lerp(a.chipTheme, b.chipTheme, t),
      toggleSwitchTheme: ToggleSwitchThemeData.lerp(
          a.toggleSwitchTheme, b.toggleSwitchTheme, t),
      iconTheme: IconThemeData.lerp(a.iconTheme, b.iconTheme, t),
      splitButtonTheme:
          SplitButtonThemeData.lerp(a.splitButtonTheme, b.splitButtonTheme, t),
      dialogTheme: ContentDialogThemeData.lerp(a.dialogTheme, b.dialogTheme, t),
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t),
      dividerTheme: DividerThemeData.lerp(a.dividerTheme, b.dividerTheme, t),
      navigationPaneTheme: NavigationPaneThemeData.lerp(
          a.navigationPaneTheme, b.navigationPaneTheme, t),
      radioButtonTheme:
          RadioButtonThemeData.lerp(a.radioButtonTheme, b.radioButtonTheme, t),
      toggleButtonTheme: ToggleButtonThemeData.lerp(
          a.toggleButtonTheme, b.toggleButtonTheme, t),
      sliderTheme: SliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      infoBarTheme: InfoBarThemeData.lerp(a.infoBarTheme, b.infoBarTheme, t),
      focusTheme: FocusThemeData.lerp(a.focusTheme, b.focusTheme, t),
      scrollbarTheme:
          ScrollbarThemeData.lerp(a.scrollbarTheme, b.scrollbarTheme, t),
      bottomNavigationTheme: BottomNavigationThemeData.lerp(
          a.bottomNavigationTheme, b.bottomNavigationTheme, t),
      snackbarTheme:
          SnackbarThemeData.lerp(a.snackbarTheme, b.snackbarTheme, t),
      pillButtonBarTheme: PillButtonBarThemeData.lerp(
          a.pillButtonBarTheme, b.pillButtonBarTheme, t),
      bottomSheetTheme:
          BottomSheetThemeData.lerp(a.bottomSheetTheme, b.bottomSheetTheme, t),
    );
  }

  FThemeData copyWith({
    Brightness? brightness,
    VisualDensity? visualDensity,
    Typography? typography,
    AccentColor? accentColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? inactiveBackgroundColor,
    Color? disabledColor,
    Color? scaffoldBackgroundColor,
    Color? acrylicBackgroundColor,
    Color? micaBackgroundColor,
    Color? shadowColor,
    Duration? fasterAnimationDuration,
    Duration? fastAnimationDuration,
    Duration? mediumAnimationDuration,
    Duration? slowAnimationDuration,
    Curve? animationCurve,
    ButtonState<MouseCursor>? inputMouseCursor,
    ButtonThemeData? buttonTheme,
    BottomNavigationThemeData? bottomNavigationTheme,
    BottomSheetThemeData? bottomSheetTheme,
    CheckboxThemeData? checkboxTheme,
    ChipThemeData? chipTheme,
    ToggleSwitchThemeData? toggleSwitchTheme,
    IconThemeData? iconTheme,
    SplitButtonThemeData? splitButtonTheme,
    ContentDialogThemeData? dialogTheme,
    TooltipThemeData? tooltipTheme,
    DividerThemeData? dividerTheme,
    NavigationPaneThemeData? navigationPaneTheme,
    RadioButtonThemeData? radioButtonTheme,
    ToggleButtonThemeData? toggleButtonTheme,
    SliderThemeData? sliderTheme,
    InfoBarThemeData? infoBarTheme,
    PillButtonBarThemeData? pillButtonBarTheme,
    FocusThemeData? focusTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackbarThemeData? snackbarTheme,
  }) {
    return FThemeData.raw(
      brightness: brightness ?? this.brightness,
      visualDensity: visualDensity ?? this.visualDensity,
      typography: typography ?? this.typography,
      accentColor: accentColor ?? this.accentColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      shadowColor: shadowColor ?? this.shadowColor,
      inactiveBackgroundColor:
          inactiveBackgroundColor ?? this.inactiveBackgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      acrylicBackgroundColor:
          acrylicBackgroundColor ?? this.acrylicBackgroundColor,
      micaBackgroundColor: micaBackgroundColor ?? this.micaBackgroundColor,
      fasterAnimationDuration:
          fasterAnimationDuration ?? this.fasterAnimationDuration,
      fastAnimationDuration:
          fastAnimationDuration ?? this.fastAnimationDuration,
      mediumAnimationDuration:
          mediumAnimationDuration ?? this.mediumAnimationDuration,
      slowAnimationDuration:
          slowAnimationDuration ?? this.slowAnimationDuration,
      inputMouseCursor: inputMouseCursor ?? this.inputMouseCursor,
      animationCurve: animationCurve ?? this.animationCurve,
      buttonTheme: this.buttonTheme.merge(buttonTheme),
      bottomNavigationTheme:
          this.bottomNavigationTheme.merge(bottomNavigationTheme),
      bottomSheetTheme: this.bottomSheetTheme.merge(bottomSheetTheme),
      checkboxTheme: this.checkboxTheme.merge(checkboxTheme),
      chipTheme: this.chipTheme.merge(chipTheme),
      dialogTheme: this.dialogTheme.merge(dialogTheme),
      dividerTheme: this.dividerTheme.merge(dividerTheme),
      focusTheme: this.focusTheme.merge(focusTheme),
      iconTheme: this.iconTheme.merge(iconTheme),
      infoBarTheme: this.infoBarTheme.merge(infoBarTheme),
      pillButtonBarTheme: this.pillButtonBarTheme.merge(pillButtonBarTheme),
      navigationPaneTheme: this.navigationPaneTheme.merge(navigationPaneTheme),
      radioButtonTheme: this.radioButtonTheme.merge(radioButtonTheme),
      scrollbarTheme: this.scrollbarTheme.merge(scrollbarTheme),
      sliderTheme: this.sliderTheme.merge(sliderTheme),
      splitButtonTheme: this.splitButtonTheme.merge(splitButtonTheme),
      toggleButtonTheme: this.toggleButtonTheme.merge(toggleButtonTheme),
      toggleSwitchTheme: this.toggleSwitchTheme.merge(toggleSwitchTheme),
      tooltipTheme: this.tooltipTheme.merge(tooltipTheme),
      snackbarTheme: this.snackbarTheme.merge(snackbarTheme),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('accentColor', accentColor))
      ..add(ColorProperty('activeColor', activeColor))
      ..add(ColorProperty('inactiveColor', inactiveColor))
      ..add(ColorProperty('inactiveBackgroundColor', inactiveBackgroundColor))
      ..add(ColorProperty('disabledColor', disabledColor))
      ..add(ColorProperty('shadowColor', shadowColor))
      ..add(ColorProperty('scaffoldBackgroundColor', scaffoldBackgroundColor))
      ..add(ColorProperty('acrylicBackgroundColor', acrylicBackgroundColor))
      ..add(ColorProperty('micaBackgroundColor', micaBackgroundColor));
    properties.add(EnumProperty('brightness', brightness));
    properties.add(DiagnosticsProperty<Duration>(
      'slowAnimationDuration',
      slowAnimationDuration,
    ));
    properties.add(DiagnosticsProperty<Duration>(
      'mediumAnimationDuration',
      mediumAnimationDuration,
    ));
    properties.add(DiagnosticsProperty<Duration>(
      'fastAnimationDuration',
      fastAnimationDuration,
    ));
    properties.add(DiagnosticsProperty<Duration>(
      'fasterAnimationDuration',
      fasterAnimationDuration,
    ));
    properties.add(
      DiagnosticsProperty<Curve>('animationCurve', animationCurve),
    );
  }
}
