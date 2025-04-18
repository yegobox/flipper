import 'package:flutter/material.dart';

/// A reusable segmented button widget that can be used throughout the app.
/// 
/// This widget wraps Flutter's SegmentedButton with customizable styling and behavior.
class CustomSegmentedButton<T> extends StatelessWidget {
  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T>) onSelectionChanged;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color? unselectedForegroundColor;
  final Color? borderColor;
  final double borderRadius;
  
  const CustomSegmentedButton({
    Key? key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor = Colors.white,
    this.selectedForegroundColor = Colors.white,
    this.unselectedForegroundColor,
    this.borderColor,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SegmentedButton<T>(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return selectedBackgroundColor ?? theme.colorScheme.primary;
            }
            return unselectedBackgroundColor ?? Colors.white;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return selectedForegroundColor ?? Colors.white;
            }
            return unselectedForegroundColor ?? theme.colorScheme.primary;
          },
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: borderColor ?? theme.colorScheme.primary),
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
    );
  }
}
