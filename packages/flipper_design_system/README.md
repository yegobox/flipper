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
- **Theme extension:** `FlipperThemeExtension.of(context)` for borders, tints, scrollbars, and table row/header states (`tableHeaderColor`, `tableRowHoverColor`, `tableRowSelectedColor`, `tableRowAltColor`)
- **Chart colors:** `FlipperChartColors.of(context)` / `.forSeries(context, index)` — an 8-slot categorical palette validated for colorblind-safe adjacent separation (see `dataviz` skill). Fixed order, never cycle past slot 8 — fold extra series into "Other" instead.
- **Sync status:** `FlipperSyncStatus` enum (`synced` / `syncing` / `offline` / `error`) with `.color(context)`, `.icon`, `.label`

## Components

- Primitives: `FlipperButton`, `FlowyTextField`, `Flippertext`, `FlipperDivider`, `FlipperImageIcon`
- `FlipperDataTable` — dense table for accounting/inventory screens (journal, ledger, stock lists). `Table`-based, not Material `DataTable`, so it renders the same across mobile/desktop/web. Use `FlipperFonts.mono` for numeric columns.
- `FlipperStatTile` — dashboard stat card with an optional trend delta (icon + color, never color alone).
- `FlipperSyncStatusBadge` — icon+label indicator for an offline-first record's sync state.

## Rules

1. Do not hardcode brand hex values in feature packages—use `FlipperColors` or `Theme.of(context).colorScheme`.
2. Prefer `FlipperTheme.light()` / `.dark()` in app `main.dart` instead of local `ThemeData` copies.
3. Composite widgets (dialogs, Wolt sheets, Flowy SVG icons) stay in `flipper_ui`.
4. Chart series colors always come from `FlipperChartColors`, in slot order, never a generated/one-off hue. Every chart needs a legend for 2+ series; <=4 series also gets direct labels — color is never the only way to tell series apart.

## Known debt (not yet acted on)

An audit (2026-08-20) found most of `FlipperThemeExtension`'s AppFlowy-inherited fields
(`tint1`-`tint9`, `greySelect`, `toggleOffFill`, `calloutBGColor`, `tableCellBGColor`,
`calendarWeekendBGColor`, `progressBarBGColor`, `toggleButtonBGColor`, `gridRowCountColor`,
`code`, `callout`, `textColor`, `secondaryTextColor`, `strongText`, `background`,
`onBackground`, `warning`, `success`) have zero real call sites in `packages/` or `apps/` —
confirmed via `FlipperThemeExtension.of(context).<field>` grep, not left in on principle.
They were left in place rather than deleted, since this package isn't the place to make
that call unilaterally — flag before removing.

`packages/flipper_ui/lib/style_widget/button.dart` and `text_field.dart` are already
deprecation shims re-exporting this package (not real duplicates). The genuine remaining
duplication is `packages/demo_ui_components/` (29 importing files, unaudited) and
`packages/flipper_ui/lib/widget/buttons/fluent_button.dart` (used only for OAuth
provider buttons, which intentionally need non-brand colors — not a migration
candidate).

## Fonts

The main Flipper app bundles Outfit under `google_fonts/` assets. Pass `allowRuntimeFontFetching: false` in release builds.

## Migration

Legacy imports from `flipper_infra` (`Insets`, `AFThemeExtension`) and `flipper_ui` (`kcPrimaryColor`, `style_widget/button.dart`) re-export this package with deprecation shims.
