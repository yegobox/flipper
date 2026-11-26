/// Flipper's single-date picker: a compact calendar panel that opens under the
/// field that asked for it (desktop/tablet) or as a bottom sheet (phones).
///
/// It replaces Material's `showDatePicker`, whose full-height dialog with an
/// OK/Cancel step looked out of place next to the POS chrome. Tapping a day
/// picks it and closes the panel. Colours follow the POS register tokens
/// (`PosTokens` in flipper_dashboard), copied here because the design system
/// sits below that package.
library;

import 'dart:math' as math;

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

// PosTokens values (flipper_dashboard/lib/theme/pos_tokens.dart).
const Color _kInk1 = Color(0xFF0B1220);
const Color _kInk2 = Color(0xFF4A5567);
const Color _kInk3 = Color(0xFF7E8AA0);
const Color _kInk4 = Color(0xFFAEB8CA);
const Color _kLine = Color(0xFFE6ECF5);
const Color _kLineStrong = Color(0xFFD6DEEA);
const Color _kSurface = Color(0xFFFFFFFF);
const Color _kSurface2 = Color(0xFFF7F9FE);
const Color _kBlue = Color(0xFF2563EB);

const List<BoxShadow> _kPanelShadow = [
  BoxShadow(
    color: Color(0x24103240),
    offset: Offset(0, 6),
    blurRadius: 18,
    spreadRadius: -6,
  ),
  BoxShadow(color: Color(0x0F103240), offset: Offset(0, 2), blurRadius: 6),
];

/// Width of the floating panel on desktop/tablet.
const double kFlipperDatePickerPanelWidth = 320;

/// Below this window width the picker opens as a bottom sheet.
const double kFlipperDatePickerSheetBreakpoint = 600;

const double _kGap = 6;
const double _kScreenMargin = 8;
const double _kDayCellHeight = 36;

/// A one-tap choice shown above the calendar ("Today", "Tomorrow", …).
@immutable
class FlipperDatePreset {
  const FlipperDatePreset({required this.label, required this.date});

  final String label;
  final DateTime date;

  /// Today, Tomorrow and the coming Monday, in the app's language.
  static List<FlipperDatePreset> defaults(
    BuildContext context, {
    DateTime? now,
  }) {
    final l10n = _l10n(context);
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final daysToMonday = (DateTime.monday - today.weekday + 7) % 7;
    return [
      FlipperDatePreset(label: l10n.datePickerToday, date: today),
      FlipperDatePreset(
        label: l10n.datePickerTomorrow,
        date: DateUtils.addDaysToDate(today, 1),
      ),
      FlipperDatePreset(
        label: l10n.datePickerNextMonday,
        date: DateUtils.addDaysToDate(
          today,
          daysToMonday == 0 ? 7 : daysToMonday,
        ),
      ),
    ];
  }
}

/// Strings work in tests and screens that never installed the Flipper
/// delegate: fall back to the last loaded (or English) bundle.
FlipperAppLocalizations _l10n(BuildContext context) =>
    Localizations.of<FlipperAppLocalizations>(
      context,
      FlipperAppLocalizations,
    ) ??
    FlipperL10n.current;

/// Shows the Flipper calendar and returns the picked day (date only, local),
/// or null when it is dismissed.
///
/// A drop-in replacement for `showDatePicker`: the same three dates, and
/// [initialDate] is clamped into the range. Pass [anchorContext] (the field's
/// context) to open the panel right under that field; without it the panel is
/// centred. On windows narrower than [kFlipperDatePickerSheetBreakpoint] it is
/// always a bottom sheet.
///
/// [presets] defaults to [FlipperDatePreset.defaults]; choices outside the
/// range are hidden, and `const []` hides the row. [helpText] is a short
/// caption above the calendar ("Change departure"). [initialYearMode] opens
/// on the year grid, for dates years away (a loan's end, a birth date); the
/// month title toggles it either way.
Future<DateTime?> showFlipperDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  BuildContext? anchorContext,
  List<FlipperDatePreset>? presets,
  String? helpText,
  bool initialYearMode = false,
  Color? accent,
  bool useRootNavigator = true,
}) {
  final first = DateUtils.dateOnly(firstDate);
  final last = DateUtils.dateOnly(lastDate);
  assert(!last.isBefore(first), 'lastDate must be on or after firstDate');
  final initial = _clampDate(DateUtils.dateOnly(initialDate), first, last);
  final choices = (presets ?? FlipperDatePreset.defaults(context))
      .where((p) => _inRange(DateUtils.dateOnly(p.date), first, last))
      .toList(growable: false);

  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final isPhone =
      MediaQuery.sizeOf(context).width < kFlipperDatePickerSheetBreakpoint;

  // Pop through the panel's own context: the caller's may be gone by the
  // time a day is tapped.
  Widget panel({required bool inSheet}) => Builder(
    builder: (panelContext) => FlipperCalendarPanel(
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      presets: choices,
      helpText: helpText,
      initialYearMode: initialYearMode,
      accent: accent ?? _kBlue,
      inSheet: inSheet,
      onPicked: (date) => Navigator.of(panelContext).pop<DateTime>(date),
      onCancel: () => Navigator.of(panelContext).maybePop(),
    ),
  );

  if (isPhone) {
    return showModalBottomSheet<DateTime>(
      context: context,
      useRootNavigator: useRootNavigator,
      backgroundColor: _kSurface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          child: panel(inSheet: true),
        ),
      ),
    );
  }

  Rect? anchor;
  final anchorBox = anchorContext?.findRenderObject();
  final overlayBox = navigator.overlay?.context.findRenderObject();
  if (anchorBox is RenderBox &&
      anchorBox.hasSize &&
      anchorBox.attached &&
      overlayBox is RenderBox) {
    final topLeft = anchorBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    anchor = topLeft & anchorBox.size;
  }

  return navigator.push<DateTime>(
    _FlipperDatePanelRoute<DateTime>(
      anchor: anchor,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      child: panel(inSheet: false),
    ),
  );
}

bool _inRange(DateTime d, DateTime first, DateTime last) =>
    !d.isBefore(first) && !d.isAfter(last);

DateTime _clampDate(DateTime d, DateTime first, DateTime last) =>
    d.isBefore(first) ? first : (d.isAfter(last) ? last : d);

class _FlipperDatePanelRoute<T> extends PopupRoute<T> {
  _FlipperDatePanelRoute({
    required this.anchor,
    required this.barrierLabel,
    required this.capturedThemes,
    required this.child,
  });

  final Rect? anchor;
  final CapturedThemes capturedThemes;
  final Widget child;

  @override
  final String? barrierLabel;

  @override
  Color? get barrierColor => anchor == null ? const Color(0x33000000) : null;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 140);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final padding = MediaQuery.paddingOf(context);
    return capturedThemes.wrap(
      CustomSingleChildLayout(
        delegate: _PanelLayout(anchor: anchor, safeArea: padding),
        child: child,
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Places the panel under [anchor] (above it when there is no room below),
/// kept inside the screen; centred when there is no anchor.
class _PanelLayout extends SingleChildLayoutDelegate {
  const _PanelLayout({required this.anchor, required this.safeArea});

  final Rect? anchor;
  final EdgeInsets safeArea;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final maxW = math.max(
      0.0,
      math.min(
        kFlipperDatePickerPanelWidth,
        constraints.maxWidth - 2 * _kScreenMargin,
      ),
    );
    final maxH = math.max(
      0.0,
      constraints.maxHeight - safeArea.vertical - 2 * _kScreenMargin,
    );
    return BoxConstraints(maxWidth: maxW, maxHeight: maxH);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final top = safeArea.top + _kScreenMargin;
    final bottom = size.height - safeArea.bottom - _kScreenMargin;
    const left = _kScreenMargin;
    final right = size.width - _kScreenMargin;
    double clampX(double x) =>
        x.clamp(left, math.max(left, right - childSize.width)).toDouble();
    double clampY(double y) =>
        y.clamp(top, math.max(top, bottom - childSize.height)).toDouble();

    final a = anchor;
    if (a == null) {
      return Offset(
        clampX((size.width - childSize.width) / 2),
        clampY((size.height - childSize.height) / 2),
      );
    }
    final below = a.bottom + _kGap;
    final above = a.top - _kGap - childSize.height;
    final fitsBelow = below + childSize.height <= bottom;
    final y = (!fitsBelow && above >= top) ? above : clampY(below);
    return Offset(clampX(a.left), y);
  }

  @override
  bool shouldRelayout(_PanelLayout oldDelegate) =>
      anchor != oldDelegate.anchor || safeArea != oldDelegate.safeArea;
}

/// The calendar itself: preset chips, month header and a 6-row day grid.
///
/// Public so screens can embed it inline (and for tests); most code should
/// call [showFlipperDatePicker].
class FlipperCalendarPanel extends StatefulWidget {
  const FlipperCalendarPanel({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onPicked,
    this.onCancel,
    this.helpText,
    this.initialYearMode = false,
    this.presets = const [],
    this.accent = _kBlue,
    this.inSheet = false,
    this.today,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onPicked;

  /// Escape calls this; null leaves Escape to the enclosing route.
  final VoidCallback? onCancel;
  final String? helpText;
  final bool initialYearMode;
  final List<FlipperDatePreset> presets;
  final Color accent;

  /// Drawn without its own card when it already sits in a bottom sheet.
  final bool inSheet;

  /// Overrides "today" (tests).
  final DateTime? today;

  @override
  State<FlipperCalendarPanel> createState() => _FlipperCalendarPanelState();
}

class _FlipperCalendarPanelState extends State<FlipperCalendarPanel> {
  late DateTime _month = DateTime(
    widget.initialDate.year,
    widget.initialDate.month,
  );
  late DateTime _focused = DateUtils.dateOnly(widget.initialDate);

  /// The focus ring only shows once the keyboard has been used.
  bool _keyboardActive = false;

  /// Year grid instead of days (the month title toggles it).
  late bool _yearMode = widget.initialYearMode;

  void _pickYear(int year) {
    final firstMonth = DateTime(_first.year, _first.month);
    final lastMonth = DateTime(_last.year, _last.month);
    var month = DateTime(year, _month.month);
    if (month.isBefore(firstMonth)) month = firstMonth;
    if (month.isAfter(lastMonth)) month = lastMonth;
    setState(() {
      _yearMode = false;
      _month = month;
      final day = math.min(
        _focused.day,
        DateUtils.getDaysInMonth(month.year, month.month),
      );
      _focused = _clampDate(
        DateTime(month.year, month.month, day),
        _first,
        _last,
      );
    });
  }

  DateTime get _first => DateUtils.dateOnly(widget.firstDate);
  DateTime get _last => DateUtils.dateOnly(widget.lastDate);
  DateTime get _today => DateUtils.dateOnly(widget.today ?? DateTime.now());

  bool get _canGoBack => DateTime(
    _month.year,
    _month.month,
  ).isAfter(DateTime(_first.year, _first.month));
  bool get _canGoForward => DateTime(
    _month.year,
    _month.month,
  ).isBefore(DateTime(_last.year, _last.month));

  void _showMonth(int delta) {
    final next = DateUtils.addMonthsToMonthDate(_month, delta);
    if (next.isBefore(DateTime(_first.year, _first.month)) ||
        next.isAfter(DateTime(_last.year, _last.month))) {
      return;
    }
    setState(() {
      _month = next;
      final day = math.min(
        _focused.day,
        DateUtils.getDaysInMonth(next.year, next.month),
      );
      _focused = _clampDate(
        DateTime(next.year, next.month, day),
        _first,
        _last,
      );
    });
  }

  void _moveFocus(int days) {
    final next = _clampDate(
      DateUtils.addDaysToDate(_focused, days),
      _first,
      _last,
    );
    setState(() {
      _keyboardActive = true;
      _focused = next;
      _month = DateTime(next.year, next.month);
    });
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (_yearMode) {
      if (key == LogicalKeyboardKey.escape) {
        setState(() => _yearMode = false);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      _moveFocus(-1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _moveFocus(1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _moveFocus(-7);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _moveFocus(7);
    } else if (key == LogicalKeyboardKey.pageUp) {
      setState(() => _keyboardActive = true);
      _showMonth(-1);
    } else if (key == LogicalKeyboardKey.pageDown) {
      setState(() => _keyboardActive = true);
      _showMonth(1);
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      widget.onPicked(_focused);
    } else if (key == LogicalKeyboardKey.escape && widget.onCancel != null) {
      widget.onCancel!();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final body = Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Padding(
        padding: EdgeInsets.all(widget.inSheet ? 0 : 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.helpText != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  widget.helpText!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kInk3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (widget.presets.isNotEmpty) ...[
              _PresetRow(
                presets: widget.presets,
                selected: widget.initialDate,
                accent: widget.accent,
                onPicked: widget.onPicked,
              ),
              const SizedBox(height: 10),
            ],
            _MonthHeader(
              month: _month,
              yearMode: _yearMode,
              onToggleYears: _first.year == _last.year
                  ? null
                  : () => setState(() => _yearMode = !_yearMode),
              onPrevious: !_yearMode && _canGoBack
                  ? () => _showMonth(-1)
                  : null,
              onNext: !_yearMode && _canGoForward ? () => _showMonth(1) : null,
            ),
            const SizedBox(height: 4),
            if (_yearMode)
              _YearGrid(
                firstYear: _first.year,
                lastYear: _last.year,
                shownYear: _month.year,
                selectedYear: widget.initialDate.year,
                accent: widget.accent,
                onPicked: _pickYear,
              )
            else ...[
              const _WeekdayRow(),
              _DayGrid(
                month: _month,
                first: _first,
                last: _last,
                selected: DateUtils.dateOnly(widget.initialDate),
                today: _today,
                focused: _keyboardActive ? _focused : null,
                accent: widget.accent,
                onPicked: widget.onPicked,
              ),
            ],
          ],
        ),
      ),
    );

    final content = Material(
      type: MaterialType.transparency,
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: _kInk1),
        child: body,
      ),
    );

    if (widget.inSheet) return content;
    return Container(
      key: const ValueKey('flipper-date-picker-panel'),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kLine),
        boxShadow: _kPanelShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(child: content),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.presets,
    required this.selected,
    required this.accent,
    required this.onPicked,
  });

  final List<FlipperDatePreset> presets;
  final DateTime selected;
  final Color accent;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final p in presets)
          _Pill(
            label: p.label,
            selected: DateUtils.isSameDay(p.date, selected),
            accent: accent,
            onTap: () => onPicked(DateUtils.dateOnly(p.date)),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? accent.withValues(alpha: 0.10) : _kSurface2,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected ? accent.withValues(alpha: 0.45) : _kLine,
          ),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: selected ? accent : _kInk2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.yearMode,
    required this.onToggleYears,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final bool yearMode;
  final VoidCallback? onToggleYears;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final title = Text(
      loc.formatMonthYear(month),
      key: const ValueKey('flipper-date-picker-month'),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: _kInk1,
      ),
    );
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: onToggleYears == null
                ? Padding(padding: const EdgeInsets.only(left: 4), child: title)
                : Semantics(
                    button: true,
                    label: yearMode
                        ? loc.selectYearSemanticsLabel
                        : loc.datePickerHelpText,
                    child: InkWell(
                      key: const ValueKey('flipper-date-picker-year-toggle'),
                      borderRadius: BorderRadius.circular(8),
                      onTap: onToggleYears,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            title,
                            AnimatedRotation(
                              turns: yearMode ? 0.5 : 0,
                              duration: const Duration(milliseconds: 150),
                              child: const Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 22,
                                color: _kInk2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        _NavButton(
          icon: Icons.chevron_left_rounded,
          tooltip: loc.previousMonthTooltip,
          onPressed: onPrevious,
        ),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          tooltip: loc.nextMonthTooltip,
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      color: _kInk2,
      disabledColor: _kInk4,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final firstDay = loc.firstDayOfWeekIndex;
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: SizedBox(
              height: 28,
              child: Center(
                child: ExcludeSemantics(
                  child: Text(
                    loc.narrowWeekdays[(firstDay + i) % 7],
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: _kInk3,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Years in the range, four to a row; the panel keeps the day grid's height.
class _YearGrid extends StatefulWidget {
  const _YearGrid({
    required this.firstYear,
    required this.lastYear,
    required this.shownYear,
    required this.selectedYear,
    required this.accent,
    required this.onPicked,
  });

  final int firstYear;
  final int lastYear;
  final int shownYear;
  final int selectedYear;
  final Color accent;
  final ValueChanged<int> onPicked;

  static const double _rowHeight = 40;
  static const double height = 28 + 6 * _kDayCellHeight;

  @override
  State<_YearGrid> createState() => _YearGridState();
}

class _YearGridState extends State<_YearGrid> {
  late final ScrollController _controller = ScrollController(
    // Shown year on the third row, so earlier years are a short scroll up.
    initialScrollOffset: math.max(
      0,
      ((widget.shownYear - widget.firstYear) ~/ 4 - 2) * _YearGrid._rowHeight,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final count = widget.lastYear - widget.firstYear + 1;
    return SizedBox(
      height: _YearGrid.height,
      child: GridView.builder(
        controller: _controller,
        padding: EdgeInsets.zero,
        itemCount: count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: _YearGrid._rowHeight,
        ),
        itemBuilder: (context, i) {
          final year = widget.firstYear + i;
          final shown = year == widget.shownYear;
          final selected = year == widget.selectedYear;
          final radius = BorderRadius.circular(8);
          return Padding(
            padding: const EdgeInsets.all(3),
            child: Semantics(
              button: true,
              selected: shown,
              child: Material(
                color: shown ? widget.accent : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: radius,
                  side: selected && !shown
                      ? BorderSide(color: widget.accent.withValues(alpha: 0.55))
                      : BorderSide.none,
                ),
                child: InkWell(
                  key: ValueKey('flipper-date-picker-year-$year'),
                  borderRadius: radius,
                  hoverColor: widget.accent.withValues(alpha: 0.08),
                  onTap: () => widget.onPicked(year),
                  child: Center(
                    child: Text(
                      loc.formatYear(DateTime(year)),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: shown ? FontWeight.w700 : FontWeight.w500,
                        color: shown ? Colors.white : _kInk1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DayGrid extends StatelessWidget {
  const _DayGrid({
    required this.month,
    required this.first,
    required this.last,
    required this.selected,
    required this.today,
    required this.focused,
    required this.accent,
    required this.onPicked,
  });

  final DateTime month;
  final DateTime first;
  final DateTime last;
  final DateTime selected;
  final DateTime today;
  final DateTime? focused;
  final Color accent;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final offset = DateUtils.firstDayOffset(month.year, month.month, loc);
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final rows = <Widget>[];
    // Always six rows so the panel never changes height between months.
    for (var row = 0; row < 6; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final dayNumber = row * 7 + col - offset + 1;
        if (dayNumber < 1 || dayNumber > days) {
          cells.add(const Expanded(child: SizedBox(height: _kDayCellHeight)));
          continue;
        }
        final date = DateTime(month.year, month.month, dayNumber);
        cells.add(
          Expanded(
            child: _DayCell(
              date: date,
              enabled: _inRange(date, first, last),
              selected: DateUtils.isSameDay(date, selected),
              today: DateUtils.isSameDay(date, today),
              focused: focused != null && DateUtils.isSameDay(date, focused),
              accent: accent,
              onTap: () => onPicked(date),
            ),
          ),
        );
      }
      rows.add(Row(children: cells));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.enabled,
    required this.selected,
    required this.today,
    required this.focused,
    required this.accent,
    required this.onTap,
  });

  final DateTime date;
  final bool enabled;
  final bool selected;
  final bool today;
  final bool focused;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final radius = BorderRadius.circular(8);
    final Color fg;
    if (selected) {
      fg = Colors.white;
    } else if (!enabled) {
      fg = _kInk4;
    } else if (today) {
      fg = accent;
    } else {
      fg = _kInk1;
    }
    BorderSide side = BorderSide.none;
    if (focused) {
      side = BorderSide(color: selected ? _kInk1 : accent, width: 2);
    } else if (today && !selected) {
      side = BorderSide(color: accent.withValues(alpha: 0.55));
    }

    return Semantics(
      label: loc.formatFullDate(date),
      button: true,
      enabled: enabled,
      selected: selected,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Material(
          color: selected ? accent : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: radius, side: side),
          child: InkWell(
            key: ValueKey(
              'flipper-date-picker-day-${date.year}-${date.month}-${date.day}',
            ),
            borderRadius: radius,
            onTap: enabled ? onTap : null,
            hoverColor: accent.withValues(alpha: 0.08),
            child: SizedBox(
              height: _kDayCellHeight - 3,
              child: Center(
                child: Text(
                  loc.formatDecimal(date.day),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected || today
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: fg,
                    decoration: enabled ? null : TextDecoration.lineThrough,
                    decorationColor: _kInk4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The locale's short weekday + date + year ("Thu, Nov 26, 2026",
/// "jeu. 26 nov. 2026"). Falls back to the numeric date for a locale intl has
/// no data for (rw).
String flipperFormatDate(BuildContext context, DateTime date) {
  try {
    return DateFormat.yMMMEd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(date);
  } catch (_) {
    return MaterialLocalizations.of(context).formatCompactDate(date);
  }
}

/// A read-only field that shows a date and opens [showFlipperDatePicker]
/// right under itself. Replaces hand-built `InkWell` + `InputDecorator` date
/// fields so every form formats dates in the user's locale.
class FlipperDateField extends StatelessWidget {
  const FlipperDateField({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.label,
    this.hintText,
    this.errorText,
    this.enabled = true,
    this.presets,
    this.format,
    this.prefixIcon = Icons.event_outlined,
  });

  final DateTime? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final String? label;
  final String? hintText;
  final String? errorText;
  final bool enabled;
  final List<FlipperDatePreset>? presets;

  /// Defaults to [flipperFormatDate] ("Thu, Nov 26, 2026").
  final String Function(DateTime date)? format;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    final v = value;
    final text = v == null
        ? null
        : (format?.call(v) ?? flipperFormatDate(context, v));

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: c, width: w),
    );

    return Builder(
      builder: (fieldContext) => InkWell(
        borderRadius: radius,
        onTap: !enabled
            ? null
            : () async {
                final now = DateTime.now();
                final picked = await showFlipperDatePicker(
                  context: fieldContext,
                  anchorContext: fieldContext,
                  initialDate: v ?? now,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  presets: presets,
                );
                if (picked != null) onChanged(picked);
              },
        child: InputDecorator(
          isEmpty: text == null,
          isFocused: false,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            errorText: errorText,
            enabled: enabled,
            filled: true,
            fillColor: enabled ? _kSurface : _kSurface2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 18, color: _kInk3),
            suffixIcon: const Icon(
              Icons.expand_more_rounded,
              size: 20,
              color: _kInk3,
            ),
            border: border(_kLineStrong),
            enabledBorder: border(_kLineStrong),
            disabledBorder: border(_kLine),
            focusedBorder: border(_kBlue, 1.5),
            labelStyle: const TextStyle(color: _kInk2, fontSize: 13),
          ),
          child: Text(
            text ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _kInk1,
            ),
          ),
        ),
      ),
    );
  }
}
