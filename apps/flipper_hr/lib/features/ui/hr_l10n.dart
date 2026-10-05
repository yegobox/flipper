/// Localized calendar names and day counts shared by HR's pages.
///
/// Written out from the ARB rather than taken from `intl`: `intl` needs its
/// date symbols initialised per locale and has none for Kinyarwanda.
library;

import 'package:flipper_localize/flipper_localize.dart';

/// `Monday` … `Sunday` for [DateTime.weekday] (1 = Monday).
String hrWeekdayName(FlipperAppLocalizations l10n, int weekday) =>
    switch (weekday) {
      DateTime.monday => l10n.hrWeekdayMonday,
      DateTime.tuesday => l10n.hrWeekdayTuesday,
      DateTime.wednesday => l10n.hrWeekdayWednesday,
      DateTime.thursday => l10n.hrWeekdayThursday,
      DateTime.friday => l10n.hrWeekdayFriday,
      DateTime.saturday => l10n.hrWeekdaySaturday,
      _ => l10n.hrWeekdaySunday,
    };

/// `Mon` … `Sun` for [DateTime.weekday] (1 = Monday).
String hrWeekdayShortName(FlipperAppLocalizations l10n, int weekday) =>
    switch (weekday) {
      DateTime.monday => l10n.hrWeekdayShortMon,
      DateTime.tuesday => l10n.hrWeekdayShortTue,
      DateTime.wednesday => l10n.hrWeekdayShortWed,
      DateTime.thursday => l10n.hrWeekdayShortThu,
      DateTime.friday => l10n.hrWeekdayShortFri,
      DateTime.saturday => l10n.hrWeekdayShortSat,
      _ => l10n.hrWeekdayShortSun,
    };

/// `January` … `December` for [DateTime.month] (1 = January).
String hrMonthName(FlipperAppLocalizations l10n, int month) => switch (month) {
  1 => l10n.hrMonthJanuary,
  2 => l10n.hrMonthFebruary,
  3 => l10n.hrMonthMarch,
  4 => l10n.hrMonthApril,
  5 => l10n.hrMonthMay,
  6 => l10n.hrMonthJune,
  7 => l10n.hrMonthJuly,
  8 => l10n.hrMonthAugust,
  9 => l10n.hrMonthSeptember,
  10 => l10n.hrMonthOctober,
  11 => l10n.hrMonthNovember,
  _ => l10n.hrMonthDecember,
};

/// `Jan` … `Dec` for [DateTime.month] (1 = January).
String hrMonthShortName(FlipperAppLocalizations l10n, int month) =>
    switch (month) {
      1 => l10n.hrMonthShortJan,
      2 => l10n.hrMonthShortFeb,
      3 => l10n.hrMonthShortMar,
      4 => l10n.hrMonthShortApr,
      5 => l10n.hrMonthShortMay,
      6 => l10n.hrMonthShortJun,
      7 => l10n.hrMonthShortJul,
      8 => l10n.hrMonthShortAug,
      9 => l10n.hrMonthShortSep,
      10 => l10n.hrMonthShortOct,
      11 => l10n.hrMonthShortNov,
      _ => l10n.hrMonthShortDec,
    };

/// `1 day`, `3 days`, `1.5 days` — whole counts without a trailing `.0`.
String hrDayCount(FlipperAppLocalizations l10n, num days) {
  if (days == days.roundToDouble()) return l10n.hrDaysCount(days.round());
  return l10n.hrDaysFractional(days.toStringAsFixed(1));
}
