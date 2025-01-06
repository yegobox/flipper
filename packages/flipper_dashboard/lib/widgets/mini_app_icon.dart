import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A customizable icon widget that supports both IconData and SVG assets with
/// gradient background and optional label.
class MiniAppIcon extends StatelessWidget {
  const MiniAppIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.page,
    this.showPageName = true,
    this.sideSize = 72.0,
    this.iconSize = 32.0,
    this.textStyle,
    this.shadows = const [
      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))
    ],
    this.gradientColors,
    this.gradientStops,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.borderRadius,
    this.iconColor = Colors.white,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.padding,
  });

  /// The icon to display (IconData or String path to SVG asset)
  final Object? icon;

  /// Primary color used for gradient if gradientColors not provided
  final Color color;

  /// Size of the container
  final double sideSize;

  /// Label text shown below icon if showPageName is true
  final String page;

  /// Whether to show the page name label
  final bool showPageName;

  /// Size of the icon
  final double iconSize;

  /// Style for the label text
  final TextStyle? textStyle;

  /// List of shadows for the container
  final List<BoxShadow> shadows;

  /// Custom gradient colors (defaults to [color.withAlpha(0.8), color])
  final List<Color>? gradientColors;

  /// Gradient stops for custom color positions
  final List<double>? gradientStops;

  /// Starting position of gradient
  final Alignment gradientBegin;

  /// Ending position of gradient
  final Alignment gradientEnd;

  /// Border radius of container (defaults to 16.0)
  final BorderRadius? borderRadius;

  /// Color of the icon (defaults to white)
  final Color iconColor;

  /// Callback when icon is tapped
  final VoidCallback? onTap;

  /// Optional background color (overrides gradient if provided)
  final Color? backgroundColor;

  /// Optional border for the container
  final BoxBorder? border;

  /// Optional padding around the icon
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(16.0),
          child: Container(
            height: sideSize,
            width: sideSize,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              gradient: backgroundColor == null
                  ? LinearGradient(
                      colors: gradientColors ??
                          [color.withValues(alpha: 0.8), color],
                      stops: gradientStops,
                      begin: gradientBegin,
                      end: gradientEnd,
                    )
                  : null,
              shape: BoxShape.rectangle,
              borderRadius: borderRadius ?? BorderRadius.circular(16.0),
              boxShadow: shadows,
              border: border,
            ),
            child: Center(
              child: _buildIcon(),
            ),
          ),
        ),
        if (showPageName)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              page,
              style: textStyle ??
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
    );
  }

  Widget _buildIcon() {
    if (icon == null) {
      return const SizedBox.shrink();
    }

    Widget iconWidget;

    if (icon is IconData) {
      iconWidget = Icon(
        icon as IconData,
        color: iconColor,
        size: iconSize,
        semanticLabel: page,
      );
    } else if (icon is String) {
      iconWidget = SvgPicture.asset(
        icon as String,
        package: 'flipper_dashboard',
        height: iconSize,
        width: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        semanticsLabel: page,
      );
    } else {
      return const SizedBox.shrink();
    }

    return iconWidget;
  }
}

// Example usage with some of the new features:
/*
MiniAppIcon(
  icon: Icons.shopping_cart,
  color: Colors.blue,
  page: "Shop",
  sideSize: 64,
  iconSize: 28,
  gradientColors: [Colors.blue.shade300, Colors.blue.shade600],
  gradientStops: [0.0, 1.0],
  borderRadius: BorderRadius.circular(12),
  iconColor: Colors.white,
  onTap: () => print("Icon tapped!"),
  border: Border.all(color: Colors.blue.shade200),
  padding: EdgeInsets.all(8),
)
*/
