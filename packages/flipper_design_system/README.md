# flipper_design_system

Shared design tokens, `ThemeData`, and primitive widgets for the Flipper monorepo.

## Usage

```dart
import 'package:flipper_design_system/flipper_design_system.dart';

MaterialApp(
  theme: FlipperTheme.light(allowRuntimeFontFetching: false),
  darkTheme: FlipperTheme.dark(),
  home: ...,
);
```

## Tokens

- **Brand:** `FlipperColors.primary` (`0xFF00C2E8`)
- **Spacing:** `Insets` / `FlipperSpacing`
- **Typography:** `FontSizes`, `heading1Style`, etc.
- **Theme extension:** `FlipperThemeExtension.of(context)` for borders, tints, scrollbars

## Rules

1. Do not hardcode brand hex values in feature packages—use `FlipperColors` or `Theme.of(context).colorScheme`.
2. Prefer `FlipperTheme.light()` / `.dark()` in app `main.dart` instead of local `ThemeData` copies.
3. Composite widgets (dialogs, Wolt sheets, Flowy SVG icons) stay in `flipper_ui`.

## Fonts

The main Flipper app bundles Outfit under `google_fonts/` assets. Pass `allowRuntimeFontFetching: false` in release builds.

## Migration

Legacy imports from `flipper_infra` (`Insets`, `AFThemeExtension`) and `flipper_ui` (`kcPrimaryColor`, `style_widget/button.dart`) re-export this package with deprecation shims.
