import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_text_drawable/src/color_generator.dart';
import 'package:flutter_text_drawable/src/contrast_helper.dart';

// ignore: must_be_immutable
class TextDrawable extends StatefulWidget {
  /// The text supplied. Only first character will be displayed.
  final String text;

  /// Height of the [TextDrawable] widget.
  final double height;

  /// Width of the [TextDrawable] widget.
  final double width;

  /// `TextStyle` for the `text` to be displayed.
  final TextStyle? textStyle;

  /// Background color to for the widget.
  /// If not specified, a random color will be generated.
  final Color? backgroundColor;

  /// Shape of the widget.
  /// Defaults to `BoxShape.circle`.
  final BoxShape boxShape;

  /// Border radius of the widget.
  /// Only specify this if `boxShape == BoxShape.circle`.
  final BorderRadiusGeometry? borderRadius;

  /// Specify duration of animation when flipping between text and checked icon.
  /// Defaults to current theme animation duration.
  final Duration duration;

  /// Set to `true` when you want the widget to recognize taps.
  /// Typical selection behaviour found in the Gmail app.
  final bool isTappable;

  /// Callback received when widget is tapped.
  /// It emits its current selected status.
  final Function(bool)? onTap;

  bool isSelected;

  /// Creates a customizable [TextDrawable] widget.
  TextDrawable({
    Key? key,
    required this.text,
    this.height = 48,
    this.width = 48,
    this.textStyle,
    this.backgroundColor,
    this.boxShape = BoxShape.circle,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 500),
    this.isTappable = false,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key) {
    assert(
      boxShape == BoxShape.rectangle || borderRadius == null,
      "Set boxShape = BoxShape.rectangle when borderRadius is specified",
    );
    assert(
      onTap == null || isTappable,
      "isTappable must be true to receive onTapped callback",
    );
  }

  @override
  _TextDrawableState createState() => _TextDrawableState();
}

class _TextDrawableState extends State<TextDrawable> {
  Color? backgroundColor;

  @override
  void initState() {
    backgroundColor =
        widget.backgroundColor ?? ColorGenerator().getRandomColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double contrast = ContrastHelper.contrast([
      backgroundColor!.red,
      backgroundColor!.green,
      backgroundColor!.blue,
    ], [
      255,
      255,
      255
    ] /** white text */);

    return GestureDetector(
      onTap: () {
        if (widget.isTappable) {
          setState(() {
            widget.isSelected = !widget.isSelected;
          });

          if (widget.isTappable && widget.onTap != null)
            widget.onTap!(widget.isSelected);
        }
      },
      child: _Flippy(
        duration: widget.duration,
        isSelected: widget.isSelected,
        front: _getSide(contrast),
        back: _getSide(contrast),
      ),
    );
  }

  Widget _getSide(double contrast) {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: !widget.isSelected ? backgroundColor : Colors.lightBlue,
        shape: widget.boxShape,
        borderRadius: widget.borderRadius,
      ),
      child: widget.isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
            )
          : Text(
              widget.text.isNotEmpty
                  ? widget.text.substring(0, 2).toUpperCase()
                  : '', // Use the first two letters of the name or an empty string if name is empty
              style: widget.textStyle?.copyWith(
                    color: contrast > 1.8 ? Colors.white : Colors.black,
                  ) ??
                  TextStyle(
                    fontSize: 18,
                    color: contrast > 1.8 ? Colors.white : Colors.black,
                  ),
            ),
    );
  }
}

class _Flippy extends StatelessWidget {
  final bool isSelected;
  final Widget front;
  final Widget back;
  final Duration? duration;

  const _Flippy({
    this.isSelected = false,
    this.duration,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration!,
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0, end: isSelected ? 180 : 0),
      builder: (context, dynamic value, child) {
        var content = value >= 90 ? back : front;
        return _RotationY(
          rotationY: value,
          child: _RotationY(
            rotationY: value >= 90 ? 180 : 0,
            child: content,
          ),
        );
      },
    );
  }
}

class _RotationY extends StatelessWidget {
  static const double degrees2Radians = pi / 180;

  final Widget child;
  final double rotationY;

  const _RotationY({Key? key, required this.child, this.rotationY = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(rotationY * degrees2Radians),
      child: child,
    );
  }
}
