import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_range_provider.g.dart';

/// Represents a date range with optional start and end dates.
class DateRangeModel {
  final DateTime? startDate;
  final DateTime? endDate;

  DateRangeModel({
    DateTime? startDate,
    DateTime? endDate,
  })  : startDate = startDate ?? _todayAtStartOfDay(),
        endDate = endDate ?? _todayAtEndOfDay();

  static DateTime _todayAtStartOfDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime _todayAtEndOfDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// Creates a copy of the current model with updated properties.
  DateRangeModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DateRangeModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// A provider for managing date range state.
@riverpod
class DateRange extends _$DateRange {
  /// Initializes the date range with today's date by default.
  @override
  DateRangeModel build() => DateRangeModel();

  /// Updates the start date in the date range.
  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  /// Updates the end date in the date range.
  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }
}
