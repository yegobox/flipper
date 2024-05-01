import 'dart:math';

import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

final List<Color> colors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
];

class GmailLikeLetter extends StatefulWidget {
  const GmailLikeLetter({
    required Key key,
    required this.branch,
    this.size = 100,
    required this.sessionActive,
  }) : super(key: key);

  final IBranch branch;
  final double? size;
  final bool sessionActive;

  @override
  State<GmailLikeLetter> createState() => _GmailLikeLetterState();
}

class _GmailLikeLetterState extends State<GmailLikeLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      key: ValueKey(widget.branch.id), // Use a unique key for each instance
      radius: widget.size,
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Container(
          width: 100,
          height: 100,
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: colors[Random().nextInt(colors.length)],
            shadows: [],
          ),
          child: Center(
            child: Text(
              widget.sessionActive && widget.branch.name!.length > 0
                  ? widget.branch.name!.substring(0, 2).toUpperCase()
                  : 'O',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
