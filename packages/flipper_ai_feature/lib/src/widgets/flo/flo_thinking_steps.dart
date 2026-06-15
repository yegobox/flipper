import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';
import 'flo_icons.dart';

class FloThinkingSteps extends StatelessWidget {
  const FloThinkingSteps({
    super.key,
    required this.steps,
    this.activeIndex,
  });

  final List<String> steps;
  final int? activeIndex;

  /// When [activeIndex] equals [steps.length], every step is shown as complete.
  bool _isDone(int index) =>
      activeIndex != null && index < activeIndex!;

  bool _isActive(int index) =>
      activeIndex != null && index == activeIndex && index < steps.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                _StepIcon(
                  done: _isDone(i),
                  active: _isActive(i),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 13,
                      color: _isDone(i) || _isActive(i)
                          ? FloTheme.ink2
                          : FloTheme.ink4,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({required this.done, required this.active});

  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (done && !active) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: FloTheme.gainTint,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: FloIcons.check(size: 10, color: FloTheme.gainInk),
      );
    }
    if (active) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: FloTheme.blue,
        ),
      );
    }
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border.all(color: FloTheme.lineStrong, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
