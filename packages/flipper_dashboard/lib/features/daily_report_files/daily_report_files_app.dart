import 'package:flipper_dashboard/features/daily_report_files/daily_report_files_screen.dart';
import 'package:flutter/material.dart';

class DailyReportFilesApp extends StatelessWidget {
  const DailyReportFilesApp({super.key});

  static const Color _kBlue = Color(0xFF3B82F6);
  static const Color _kTextPrimary = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        brightness: Brightness.light,
        colorScheme: base.colorScheme.copyWith(
          brightness: Brightness.light,
          primary: _kBlue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: _kTextPrimary,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return _kBlue;
            }
            return null;
          }),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: _kBlue,
        ),
      ),
      child: const Material(child: DailyReportFilesScreen()),
    );
  }
}
