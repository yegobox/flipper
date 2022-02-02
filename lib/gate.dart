import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flipper_routing/routes.dart';
// import 'package:flipper/flipper_options.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:flipper_models/models/view_models/business_home_viewmodel.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localize/localize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// DEFAULT EXAMPLE - Hot Reload Playground
///
/// This example shows how you can define custom colors, use [FlexColorScheme]
/// to theme your app with them, or use a predefined theme.
///
/// It offers a playground you can use to experiment with all its
/// theming properties and optional opinionated sub-theming.
///
/// It also demonstrates how to use a [GoogleFonts] based font as the default
/// font for your app theme, and how to customize the used [TextTheme].
///
/// To learn more about how to use [FlexColorScheme] and all its features,
/// please go through the five tutorial examples in the readme documentation.

// This default example contains a long list of const and final property values
// that are just passed in to the corresponding properties in
// FlexThemeData.light() and FlexThemeData.dark() convenience extension on
// ThemeData to FlexColorScheme.light().toTheme and
// FlexColorScheme.dark().toTheme.
//
// The purpose is to provide any easy to use in-code based playground that
// you can experiment with and use as quick starter template to start using
// FlexColorScheme to make beautiful Flutter themes for your applications.
// It is also a code and comment based quick guide for devs that don't read
// long documentation.
//
// This setup is convenient since you can edit the values for both the light
// and dark theme mode via shared property values on observer the changes
// in the built via hot reload.
// In a real app you might tuck away your color definitions and FlexColorScheme
// settings in a static class with const and final values and static functions
// as required. The other tutorials show one possible example of this as well.
//
// To learn more about using FlexColorScheme, it is recommended to go through
// the step-by-step tutorial that uses examples 1 to 5 to explain and
// demonstrate the features with increasing complexity. Example 5 represents
// the full bonanza where pretty much everything can be changed dynamically
// while running the app.

// For our custom color scheme we define primary and secondary colors,
// but no variant or other colors.
final FlexSchemeColor _schemeLight = FlexSchemeColor.from(
  primary: const Color(0xFF00296B),
  // If you do not want to define secondary, primaryVariant and
  // secondaryVariant, error and appBar colors you do not have to,
  // they will get defined automatically when using the FlexSchemeColor.from()
  // factory. When using FlexSchemeColor.from() you only have to define the
  // primary color, anything not defined will get derived automatically from
  // the primary color and you get a theme that is based just on shades of
  // the provided primary color.
  //
  // With the default constructor FlexSchemeColor() you have to define
  // all 4 main color properties required for a complete color scheme. If you
  // do define them all, then prefer using it, since it can be const.
  //
  // Here we define a secondary color, but if you don't it will get a
  // default shade based on the primary color. When you do define a secondary
  // color, but not a secondaryVariant color, the secondary variant will get
  // derived from the secondary color, instead of from the primary color.
  secondary: const Color(0xFFFF7B00),
);

// These are custom defined matching dark mode colors. Further below we show
// how to compute them based on the light color scheme. You can swap them in the
// code example further below and compare the result of these manually defined
// matching dark mode colors, to the ones computed via the "lazy" designer
// matching dark colors.
final FlexSchemeColor _schemeDark = FlexSchemeColor.from(
  primary: const Color(0xFF6B8BC3),
  secondary: const Color(0xffff7155),
);

// To use a pre-defined color scheme, don't assign any FlexSchemeColor to
// `colors` instead, just pick a FlexScheme and assign it to the `scheme`.
// Try eg the new "Blue Whale" color scheme.
const FlexScheme _scheme = FlexScheme.blueWhale;

// To make it easy to toggle between using the above custom colors, or the
// selected predefined scheme in this example, set _useScheme to true to use the
// selected predefined scheme above, change to false to use the custom colors.
const bool _useScheme = false;

// A quick setting for the themed app bar elevation, it defaults to 0.
// A very low, like 0.5 is pretty nice too, since it gives an underline effect
// visible with e.g. white or light app bars.
const double _appBarElevation = 0.5;

// There is quick setting to put an opacity value on the app bar, so we can
// see content scroll behind it, if we extend the Scaffold behind the AppBar.
const double _appBarOpacity = 0.94;

// If you set _computeDarkTheme below to true, the dark scheme will be computed
// both for the selected scheme and the custom colors, from the light scheme.
// There is a bit of logic hoops below to make it happen via these bool toggles.
//
// Going "toDark()" on your light FlexSchemeColor definition is just a quick
// way you can make a dark scheme from a light color scheme definition, without
// figuring out usable color values yourself. Useful during development, when
// you test custom colors, but usually you probably want to fine tune your
// final custom dark color scheme colors to const values.
const bool _computeDarkTheme = true;

// When you use _computeDarkTheme, use this desaturation % level to calculate
// the dark scheme from the light scheme colors. The default is 35%, but values
// from 20% might work on less saturated light scheme colors. For more
// deep and colorful starting values, you can try 40%. Trivia: The default
// red dark error color in the Material design guide, is computed from the light
// theme error color value, by using 40% with the same algorithm used here.
const int _toDarkLevel = 30;

// To swap primaries and secondaries, set to true. With some color schemes
// interesting and even useful inverted primary-secondary themes can be obtained
// by only swapping the colors on your dark scheme, some where even designed
// with this usage in mind, but not all look so well when using it.
const bool _swapColors = false;

// Use a GoogleFonts, font as default font for your theme.  Not used by default
// in the demo setup, but you can uncomment its usage, further below.
// ignore: unused_element
late String? _fontFamily = GoogleFonts.notoSans().fontFamily;

// Define a custom text theme for the app. Here we have decided that
// Headline1..3 are too big to be useful for us, so we make them a bit smaller
// and that overline is a bit too small and have weird letter spacing.
const TextTheme _textTheme = TextTheme(
  headline1: TextStyle(fontSize: 57),
  headline2: TextStyle(fontSize: 45),
  headline3: TextStyle(fontSize: 36),
  overline: TextStyle(fontSize: 11, letterSpacing: 0.5),
);

// FlexColorScheme before version 4 used the `surfaceStyle` property to
// define the surface color blend mode. If you are migrating from an earlier
// version, no worries it still works as before, but we won't be using it in
// this example anymore.
// When you define a value for the new `surfaceMode` property used below,
// it will also override any defined `surfaceStyle`.
// It is recommended to use this method to make alpha blended surfaces
// starting with version 4.
// The mode `scaffoldSurfaceBackground` is similar to all the previous
// `surfaceStyle` settings, but its blend level is set separately in finer and
// more increments via `blendLevel`. Additionally there are several new surface
// blend mode strategies in version 4, instead of just one.
const FlexSurfaceMode _surfaceMode = FlexSurfaceMode.highBackgroundLowScaffold;

// The alpha blend level strength can be defined separately from the
// SurfaceMode strategy, and has 40 alpha blend level strengths.
const int _blendLevel = 15;

// The `useSubThemes` sets weather you want to opt-in or not on additional
// opinionated sub-theming. By default FlexColorScheme as before does very
// little styling on widgets, other than a few important adjustments, described
// in detail in the readme. By using the sub-theme opt-in, it now also offers
// easy to use additional out-of the box opinionated styling of SDK UI Widgets.
// One key feature is the rounded corners on Widgets that support it.
const bool _useSubThemes = true;

// The opt-in opinionated sub-theming offers easy to use consistent corner
// radius rounding setting on all sub-themes and a ToggleButtons design that
// matches the normal buttons style and size.
// It comes with Material You like rounded defaults, but you can adjust
// its configuration via simple parameters in a passed in configuration class
// called FlexSubThemesData.
// Here are some some configuration examples:
const FlexSubThemesData _subThemesData = FlexSubThemesData(
  // Opt in for themed hover, focus, highlight and splash effects.
  // New buttons use primary themed effects by default, this setting makes
  // the general ThemeData hover, focus, highlight and splash match that.
  // True by default when opting in on sub themes, but you can turn it off.
  interactionEffects: true,

  // When it is null = undefined, the sub themes will use their default style
  // behavior that aims to follow new Material 3 (M3) standard for all widget
  // corner roundings. Current Flutter SDK corner radius is 4, as defined by
  // the Material 2 design guide. M3 uses much higher corner radius, and it
  // varies by widget type.
  //
  // When you set [defaultRadius] to a value, it will override these defaults
  // with this global default. You can still set and lock each individual
  // border radius back for these widget sub themes to some specific value, or
  // to its Material3 standard, which is mentioned in each theme as the used
  // default when its value is null.
  //
  // Set global corner radius. Default is null, resulting in M3 styles, but make
  // it whatever you like, even 0 for a hip to be square style.
  defaultRadius: 0,
  // You can also override individual corner radius for each sub-theme to make
  // it different from the global `cornerRadius`. Here eg. the bottom sheet
  // radius is defined to always be 24:
  bottomSheetRadius: 24,
  // Select input decorator type, only SDK options outline and underline
  // supported no, but custom ones may be added later.
  // TODOcommented this out, as it is causing me issue within app
  // inputDecoratorBorderType: FlexInputBorderType.outline,
  // For a primary color tinted background on the input decorator set to true.
  inputDecoratorIsFilled: true,
  // If you do not want any underline/outline on the input decorator when it is
  // not in focus, then set this to false.
  inputDecoratorUnfocusedHasBorder: true,
  // inputDecorationTheme:
  // Elevations have easy override values as well.
  elevatedButtonElevation: 1,
  // Widgets that use outline borders can be easily adjusted via these
  // properties, they affect the outline input decorator, outlined button and
  // toggle buttons.
  thickBorderWidth: 0, // Default is 2.0.
  thinBorderWidth: 0.0, // Default is 1.5.
);

// If true, the top part of the Android AppBar has no scrim, it then becomes
// one colored like on iOS.
const bool _transparentStatusBar = true;

// Usually the TabBar is used in an AppBar. This style themes it right for
// that, regardless of what FlexAppBarStyle you use for the `appBarStyle`.
// If you will use the TabBar on Scaffold or other background colors, then
// use the style FlexTabBarStyle.forBackground.
const FlexTabBarStyle _tabBarForAppBar = FlexTabBarStyle.forAppBar;

// If true, tooltip background brightness is same as background brightness.
// False by default, which is inverted background brightness compared to theme.
// Setting this to true is more Windows desktop like.
const bool _tooltipsMatchBackground = true;

// The visual density setting defaults to same as SDK default value,
// which is `VisualDensity.adaptivePlatformDensity`. You can define a fixed one
// or try `FlexColorScheme.comfortablePlatformDensity`.
// The `comfortablePlatformDensity` is an alternative adaptive density to the
// default `adaptivePlatformDensity`. It makes the density `comfortable` on
// desktops, instead of `compact` as the `adaptivePlatformDensity` does.
// This is useful on desktop with touch screens, since it keeps tap targets
// a bit larger but not as large as `standard` intended for phones and tablets.
final VisualDensity _visualDensity = FlexColorScheme.comfortablePlatformDensity;

// This is just standard `platform` property in `ThemeData`, handy to have as
// a direct property, you can use it to test how things changes on different
// platforms without using `copyWith` on the resulting theme data.
final TargetPlatform _platform = defaultTargetPlatform;

class Gate extends StatefulWidget {
  const Gate({Key? key}) : super(key: key);

  @override
  State<Gate> createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      viewModelBuilder: () => BusinessHomeViewModel(),
      onModelReady: (model) async {
        String? defaultLanguage = model.getSetting();

        defaultLanguage == null ? const Locale('en') : Locale(defaultLanguage);
      },
      builder: (context, model, child) {
        return OverlaySupport.global(
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: () => MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'flipper',
                // Define the light theme for the app, based on defined colors and
                // properties above.
                theme: FlexThemeData.light(
                  // Want to use a built in scheme? Don't assign any value to colors.
                  // We just use the _useScheme bool toggle here from above, only for easy
                  // switching via code params so you can try options handily.
                  colors: _useScheme ? null : _schemeLight,
                  scheme: _scheme,
                  swapColors:
                      _swapColors, // If true, swap primary and secondaries.
                  // For an optional white look set lightIsWhite to true.
                  // This is the counterpart to darkIsTrueBlack mode in dark theme mode,
                  // which is much more useful than this feature.
                  lightIsWhite: false,

                  // If you provide a color value to a direct color property, the color
                  // value will override anything specified via the other properties.
                  // The priority from lowest to highest order is:
                  // 1. scheme 2. colors 3. Individual color values. Normally you would
                  // make a custom scheme using the colors property, but if you want to
                  // override just one or two colors in a pre-existing scheme, this can
                  // be handy way to do it. Uncomment a color property below on
                  // the light theme to try it:

                  // primary: FlexColor.indigo.light.primary,
                  // primaryVariant: FlexColor.greenLightPrimaryVariant,
                  // secondary: FlexColor.indigo.light.secondary,
                  // secondaryVariant: FlexColor.indigo.light.secondaryVariant,
                  // surface: FlexColor.lightSurface,
                  // background: FlexColor.lightBackground,
                  // error: FlexColor.materialLightErrorHc,
                  // scaffoldBackground: FlexColor.lightScaffoldBackground,
                  // dialogBackground: FlexColor.lightSurface,
                  // appBarBackground: FlexColor.barossaLightPrimary,

                  // The default style of AppBar in Flutter SDK light mode uses scheme
                  // primary color as its background color. The appBarStyle
                  // FlexAppBarStyle.primary, results in this too, and is the default in
                  // light mode. You can also choose other themed styles. Like
                  // FlexAppBarStyle.background, that gets active color blend from used
                  // surfaceMode or surfaceStyle, depending on which one is being used.
                  // You may often want a different style on the app bar in dark and
                  // light theme mode, therefore it was not set via a shared value
                  // above in this template.
                  appBarStyle: FlexAppBarStyle.primary,
                  appBarElevation: _appBarElevation,
                  appBarOpacity: _appBarOpacity,
                  transparentStatusBar: _transparentStatusBar,
                  tabBarStyle: _tabBarForAppBar,
                  surfaceMode: _surfaceMode,
                  blendLevel: _blendLevel,
                  tooltipsMatchBackground: _tooltipsMatchBackground,
                  // You can try another font too, not set by default in the demo.
                  // Prefer using fully defined TextThemes when using fonts, rather than
                  // just setting the fontFamily name, even with GoogleFonts. For
                  // quick tests this is fine too, but if the same font style is good
                  // as it is, for all the styles in the TextTheme just the fontFamily
                  // works well too.
                  // fontFamily: _fontFamily,
                  textTheme: _textTheme,
                  primaryTextTheme: _textTheme,
                  useSubThemes: _useSubThemes,
                  subThemesData: _subThemesData,
                  visualDensity: _visualDensity,
                  platform: _platform,
                ),
                // Define the corresponding dark theme for the app.
                darkTheme: FlexThemeData.dark(
                  // If you want to base the dark scheme on your light colors,
                  // you can also compute it from the light theme's FlexSchemeColors.
                  // Here you can do so by setting _computeDarkTheme above to true.
                  // The FlexSchemeColors class has a toDark() method that can convert
                  // a color scheme designed for a light theme, to corresponding colors
                  // suitable for a dark theme. For the built in themes there is no
                  // need to do so, they all have hand tuned dark scheme colors.
                  // Regardless, below we anyway demonstrate how you can do that too.
                  //
                  // Normally you would not do things like this logic, this is just here
                  // so you can toggle the two booleans earlier above to try the options.
                  colors: (_useScheme && _computeDarkTheme)
                      // If we use predefined schemes and want to compute a dark
                      // theme from its light colors, we can grab the light scheme colors
                      // for _schemes from the FlexColor.schemes map and use toDark(),
                      // that takes a white blend saturation %, where 0 is same colors as
                      // the input light scheme colors, and 100% makes it white.
                      ? FlexColor.schemes[_scheme]!.light.toDark(_toDarkLevel)
                      // If we use a predefined scheme, then pass, null so we get
                      // selected _scheme via the scheme property.
                      : _useScheme
                          ? null
                          // If we compute a scheme from our custom data, then use the
                          // toDark() method on our custom light FlexSchemeColor data.
                          : _computeDarkTheme
                              ? _schemeLight.toDark(_toDarkLevel)
                              // And finally, use the defined custom dark colors.
                              : _schemeDark,
                  // To use a built-in scheme based on enum, don't assign colors above.
                  scheme: _scheme,
                  swapColors: _swapColors,
                  // For an optional ink black dark mode, set darkIsTrueBlack to true.
                  darkIsTrueBlack: false,

                  // The SDK default style of the AppBar in dark mode uses a fixed dark
                  // background color, defined via colorScheme.surface color. The
                  // appBarStyle FlexAppBarStyle.material results in the same color value.
                  // It is also the default if you do not define the style.
                  // You can also use other themed styles. Here we use background, that
                  // also gets active color blend from used SurfaceMode or SurfaceStyle.
                  // You may often want a different style on the AppBar in dark and light
                  // theme mode, therefore it was not set via a shared value value
                  // above in this template.
                  appBarStyle: FlexAppBarStyle.background,
                  appBarElevation: _appBarElevation,
                  appBarOpacity: _appBarOpacity,
                  transparentStatusBar: _transparentStatusBar,
                  tabBarStyle: _tabBarForAppBar,
                  surfaceMode: _surfaceMode,
                  blendLevel: _blendLevel,
                  tooltipsMatchBackground: _tooltipsMatchBackground,
                  // fontFamily: _fontFamily,
                  textTheme: _textTheme,
                  primaryTextTheme: _textTheme,
                  useSubThemes: _useSubThemes,
                  subThemesData: _subThemesData,
                  visualDensity: _visualDensity,
                  platform: _platform,
                ),
                localizationsDelegates: [
                  FlutterFireUILocalizations.withDefaultOverrides(
                      const LabelOverrides()),
                  const FlipperLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'), // English
                  Locale('es', 'ES'), // Spanish
                ],
                locale: model.languageService
                    .locale, //french == rwanda language in our app
                themeMode: model.settingService.themeMode.value,
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate),
          ),
        );
      },
    );
  }
}
