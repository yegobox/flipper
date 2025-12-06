import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/message.model.dart';

/// A wrapper widget that adds swipe-to-reply functionality to messages
///
/// Only enables swipe gesture for WhatsApp messages
class SwipeableMessage extends StatefulWidget {
  final Message message;
  final Widget child;
  final VoidCallback? onReply;

  const SwipeableMessage({
    Key? key,
    required this.message,
    required this.child,
    this.onReply,
  }) : super(key: key);

  @override
  State<SwipeableMessage> createState() => _SwipeableMessageState();
}

class _SwipeableMessageState extends State<SwipeableMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _dragExtent = 0;
  static const double _swipeThreshold = 0.3; // 30% of screen width
  static const double _maxDragExtent = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Only allow swipe for WhatsApp messages
    if (widget.message.messageSource != 'whatsapp') return;

    setState(() {
      _dragExtent += details.primaryDelta ?? 0;
      _dragExtent = _dragExtent.clamp(-_maxDragExtent, _maxDragExtent);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    // Only allow swipe for WhatsApp messages
    if (widget.message.messageSource != 'whatsapp') return;

    final screenWidth = MediaQuery.of(context).size.width;
    final swipeDistance = _dragExtent.abs();
    final threshold = screenWidth * _swipeThreshold;

    if (swipeDistance >= threshold) {
      // Swipe completed - trigger reply
      widget.onReply?.call();
    }

    // Animate back to original position
    _offsetAnimation = Tween<Offset>(
      begin: Offset(_dragExtent / screenWidth, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    setState(() {
      _dragExtent = 0;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // If not a WhatsApp message, just return the child without swipe functionality
    if (widget.message.messageSource != 'whatsapp') {
      return widget.child;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final offset = Offset(_dragExtent / screenWidth, 0);
    final showReplyIcon = _dragExtent.abs() > 20;

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Reply icon that appears during swipe
          if (showReplyIcon)
            Positioned(
              left: _dragExtent > 0 ? 16 : null,
              right: _dragExtent < 0 ? 16 : null,
              child: AnimatedOpacity(
                opacity: (_dragExtent.abs() / _maxDragExtent).clamp(0.0, 1.0),
                duration: const Duration(milliseconds: 100),
                child: Icon(
                  Icons.reply_rounded,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ),
            ),
          // The actual message content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final animatedOffset = _controller.isAnimating
                  ? _offsetAnimation.value
                  : offset;
              return Transform.translate(
                offset: Offset(animatedOffset.dx * screenWidth, 0),
                child: child,
              );
            },
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
