import 'package:flutter/material.dart';

/// Create a error message,
/// usually displayed on the page when an error occurs
/// such as no internet error, not found error, and others.
class GErrorMessage extends StatelessWidget {
  const GErrorMessage({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onPressed,
  }) : super(key: key);

  /// An icon to display.
  final Widget icon;

  /// An error title.
  final String title;

  /// A description to explain the error
  final String? subtitle;

  /// Text that describes the button.
  final String? buttonLabel;

  /// A callback after the user click the button.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withOpacity(.1),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        size: 40,
                        color: colorScheme.primary,
                      ),
                    ),
                    child: icon,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  // variant: TextVariant.bodyText1,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    subtitle!,
                    // color: colorScheme.onBackground.withOpacity(.75),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (onPressed != null) const SizedBox(height: 32),
                if (onPressed != null)
                  ElevatedButton(
                    child: Text(
                      buttonLabel ?? "Try again",
                    ),
                    onPressed: onPressed,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
