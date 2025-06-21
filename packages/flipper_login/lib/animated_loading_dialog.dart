import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A loading dialog with custom fade animation support
class AnimatedLoadingDialog extends StatefulWidget {
  final String message;
  final Duration animationDuration;
  final Function? onDismissComplete;

  // Create with GlobalKey to access state
  const AnimatedLoadingDialog({
    Key? key,
    required this.message,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onDismissComplete,
  }) : super(key: key);

  @override
  AnimatedLoadingDialogState createState() => AnimatedLoadingDialogState();
}

class AnimatedLoadingDialogState extends State<AnimatedLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    // Start the fade-in animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Dismiss the dialog with a fade-out animation
  Future<void> dismissWithAnimation() async {
    // Reverse the animation (fade out)
    await _animationController.reverse();

    // Call the onDismissComplete callback if provided
    if (widget.onDismissComplete != null) {
      widget.onDismissComplete!();
    }

    // Pop the dialog if context is still valid
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                widget.message,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
