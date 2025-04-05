import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

// final List<Color> colors = [
//   Colors.blue,
//   Colors.green,
//   Colors.red,
//   Colors.orange,
//   Colors.purple,
//   Colors.teal,
//   Colors.pink,
// ];

class GmailLikeLetter extends StatefulWidget {
  const GmailLikeLetter({
    required Key key,
    required this.branch,
    this.size = 100,
    required this.sessionActive,
  }) : super(key: key);

  final Branch branch;
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
    return ClipRRect(
      key: ValueKey(widget.branch.id),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: widget.size! * 2, // Adjust the width as needed
        height: widget.size! * 2, // Adjust the height as needed
        color: Colors.white,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.rectangle, // This makes it a square/rectangle
            ),
            child: Center(
              child: Text(
                widget.sessionActive && widget.branch.name!.isNotEmpty
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
      ),
    );
  }
}
