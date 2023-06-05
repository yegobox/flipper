import 'package:flutter/material.dart';

class AnimatedRowItem extends StatefulWidget {
  Widget item;
  AnimatedRowItem({required this.item});

  @override
  _AnimatedRowItemState createState() => _AnimatedRowItemState();
}

class _AnimatedRowItemState extends State<AnimatedRowItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _animation.value) * 20),
            child: child,
          ),
        );
      },
      child: widget.item,
    );
  }
}
