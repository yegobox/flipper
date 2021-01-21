
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


String formatTime(BuildContext context, DateTime date) {
  try {
    DateFormat dateFormat;
    if (MediaQuery.of(context).alwaysUse24HourFormat) {
      dateFormat = DateFormat.Hm(Localizations.localeOf(context).languageCode);
    } else {
      dateFormat = DateFormat.jm(Localizations.localeOf(context).languageCode);
    }
    return dateFormat.format(date);
  } catch (error) {
    // Logger.e('Error with time format: $error', e: error, s: StackTrace.current);
    return '';
  }
}

String formatDate(BuildContext context, DateTime date) {
  try {
    const String datePattern = 'EEE, MMM d';
    final DateFormat dateFormat = DateFormat(datePattern, Localizations.localeOf(context).languageCode);
    return dateFormat.format(date);
  } catch (error) {
    // Logger.e('Error with date format: $error', e: error, s: StackTrace.current);
    return '';
  }
}

String formatDateShort(BuildContext context, DateTime date) {
  try {
    final DateFormat dateFormat = DateFormat.yMd(Localizations.localeOf(context).languageCode);
    return dateFormat.format(date);
  } catch (error) {
    // Logger.e('Error with date format: $error', e: error, s: StackTrace.current);
    return '';
  }
}

String formatCalendarDate(BuildContext context, DateTime date) {
  try {
        const String datePattern = 'EEEE d. MMM';
        final DateFormat dateFormat = DateFormat(datePattern, Localizations.localeOf(context).languageCode);
        return dateFormat.format(date);
  } catch (error) {
    // Logger.e('Error with calendar date format: $error', e: error, s: StackTrace.current);
    return '';
  }
}