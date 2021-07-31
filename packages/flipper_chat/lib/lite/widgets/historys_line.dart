import 'package:flutter/material.dart';

class HistoryLine extends StatelessWidget {
  const HistoryLine(
      {Key? key,
      required this.numPost,
      this.height = 3.0,
      this.spacing = 5.0,
      this.enableRadius = true,
      this.color = Colors.grey,
      this.padding = const EdgeInsets.all(5.0)})
      : super(key: key);

  final int numPost;
  final double spacing;
  final double height;
  final bool enableRadius;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final newNumPost = (numPost - 1) < 0 ? 0 : (numPost - 1);
    double br = enableRadius ? (height / 2) : 0.0;
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final w = constraints.maxWidth;
          final width = (w - (spacing * newNumPost)) / numPost;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                numPost,
                (i) => Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(br),
                    color: color,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
