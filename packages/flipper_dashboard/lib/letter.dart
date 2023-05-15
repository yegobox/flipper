import 'dart:math';

import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

final List<Color> colors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
];

class GmailLikeLetter extends StatefulWidget {
  const GmailLikeLetter({super.key, required this.tenant, this.size = 100});
  final ITenant tenant;
  final double? size;

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
      radius: widget.size,
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: colors[Random().nextInt(colors.length)],
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.tenant.name != null && widget.tenant.name!.length > 0
                  ? widget.tenant.name!.substring(0, 2).toUpperCase()
                  : '',
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
