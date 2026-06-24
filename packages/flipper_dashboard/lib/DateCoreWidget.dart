// ignore_for_file: unused_result

import 'dart:math' as math;

import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

/// Slate / report chrome (aligned with transaction report cards).
const Color _kChromeBorder = Color(0xFFE5E7EB);
const Color _kChromeHeaderBg = Color(0xFFF1F5F9);
const Color _kTextPrimary = Color(0xFF0F172A);
const Color _kTextMuted = Color(0xFF64748B);

mixin DateCoreWidget<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  static final DatePickerThemeData _reportDateRangeTheme = DatePickerThemeData(
    backgroundColor: Colors.white,
    elevation: 16,
    shadowColor: Color(0x14000000),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: _kChromeBorder, width: 1),
    ),
    rangePickerBackgroundColor: Colors.white,
    rangePickerElevation: 0,
    rangePickerShadowColor: Colors.transparent,
    rangePickerSurfaceTintColor: Colors.transparent,
    rangePickerShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    rangePickerHeaderBackgroundColor: _kChromeHeaderBg,
    rangePickerHeaderForegroundColor: _kTextPrimary,
    rangePickerHeaderHelpStyle: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
      height: 1.2,
    ),
    rangePickerHeaderHeadlineStyle: const TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w800,
      height: 1.15,
      letterSpacing: -0.3,
    ),
    weekdayStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    dayStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return _kTextMuted.withValues(alpha: 0.45);
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return _kTextPrimary;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return PosLayoutBreakpoints.posAccentBlue;
      }
      return null;
    }),
    dayShape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      return PosLayoutBreakpoints.posAccentBlue;
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return PosLayoutBreakpoints.posAccentBlue;
      }
      return PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.08);
    }),
    todayBorder: BorderSide(
      color: PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.85),
      width: 1,
    ),
    rangeSelectionBackgroundColor:
        PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.14),
    rangeSelectionOverlayColor: WidgetStateProperty.all(
      PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.12),
    ),
    subHeaderForegroundColor: _kTextMuted,
    dividerColor: _kChromeBorder,
    cancelButtonStyle: TextButton.styleFrom(
      foregroundColor: _kTextMuted,
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    confirmButtonStyle: FilledButton.styleFrom(
      backgroundColor: PosLayoutBreakpoints.posAccentBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  IconButton datePicker() {
    return IconButton(
      onPressed: handleDateTimePicker,
      icon: Icon(
        Icons.calendar_today_rounded,
        color: PosLayoutBreakpoints.posAccentBlue,
        size: 28,
      ),
      tooltip: 'Select Date',
      splashColor: PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.12),
      highlightColor: PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.08),
      splashRadius: 24,
      padding: const EdgeInsets.all(8),
    );
  }

  void _onDateRangeSelected(DateTimeRange dateRange) {
    ref.read(dateRangeProvider.notifier).setRange(
          start: dateRange.start,
          end: dateRange.end,
        );
  }

  /// Compact range picker (not fullscreen on desktop). See mixin doc on
  /// [MediaQuery] sizing and why we avoid [showDateRangePicker].
  Future<void> handleDateTimePicker() async {
    final providerRange = ref.read(dateRangeProvider);
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: providerRange.startDate ?? now.subtract(const Duration(days: 7)),
      end: providerRange.endDate ?? now,
    );

    final picked = await showDialog<DateTimeRange?>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      animationStyle: AnimationStyle.noAnimation,
      builder: (dialogContext) {
        final screen = MediaQuery.sizeOf(dialogContext);
        final base = MediaQuery.of(dialogContext);
        final w = math.min(428.0, screen.width - 28);
        final h = math.min(600.0, screen.height - 36);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Center(
            child: MediaQuery(
              data: base.copyWith(
                size: Size(w, h),
                padding: EdgeInsets.zero,
                viewPadding: EdgeInsets.zero,
                viewInsets: EdgeInsets.zero,
              ),
              child: Theme(
                data: Theme.of(dialogContext).copyWith(
                  visualDensity: VisualDensity.standard,
                  colorScheme: Theme.of(dialogContext).colorScheme.copyWith(
                        primary: PosLayoutBreakpoints.posAccentBlue,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: _kTextPrimary,
                      ),
                  datePickerTheme: _reportDateRangeTheme,
                ),
                child: DateRangePickerDialog(
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030, 12, 31),
                  initialDateRange: initialRange,
                  currentDate: now,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  helpText: 'REPORT PERIOD',
                  saveText: 'Apply',
                  cancelText: 'Cancel',
                ),
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || picked == null) return;

    // `Navigator.pop` completes before overlay paint/teardown finishes. Yield
    // frames + a timer turn so Ditto/UI rebuild (`setRange`) never shares the
    // main thread with dismissal (avoids wait cursor / blocked Apply).
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 48));
    if (!mounted) return;

    toast('Applying date range…');
    _onDateRangeSelected(picked);
  }
}
