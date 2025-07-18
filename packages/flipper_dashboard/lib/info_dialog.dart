import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class InfoDialog extends StatefulWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InfoDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.bounceOut,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _scaleController.forward();
    _bounceController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.request.data?['status'] as InfoDialogStatus? ??
        InfoDialogStatus.info;
    final message =
        widget.request.description ?? 'An unexpected error occurred.';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: _getBackgroundGradient(status),
            boxShadow: [
              BoxShadow(
                color: _getAccentColor(status).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnimatedIcon(status),
              const SizedBox(height: 20),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(_bounceAnimation),
                child: Text(
                  widget.request.title ?? _getPlayfulTitle(status),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _getTextColor(status),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_bounceAnimation),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: _getTextColor(status).withValues(alpha: 0.8),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildGameButton(status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(InfoDialogStatus status) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _getAccentColor(status).withValues(alpha: 0.2),
                _getAccentColor(status).withValues(alpha: 0.1),
                Colors.transparent,
              ],
              stops: [0.3, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: _getAccentColor(status)
                    .withValues(alpha: 0.4 * _glowAnimation.value),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(_bounceAnimation),
            child: RotationTransition(
              turns: Tween<double>(
                begin: 0.0,
                end: status == InfoDialogStatus.success ? 1.0 : 0.0,
              ).animate(_bounceAnimation),
              child: _getPlayfulIcon(status),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameButton(InfoDialogStatus status) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _bounceAnimation.value),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getAccentColor(status),
                  _getAccentColor(status).withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _getAccentColor(status).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => widget.completer(DialogResponse(confirmed: true)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getButtonText(status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getPlayfulIcon(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.shade100,
          ),
          child: const Icon(
            Icons.sentiment_dissatisfied_rounded,
            color: Colors.red,
            size: 40,
          ),
        );
      case InfoDialogStatus.warning:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.shade100,
          ),
          child: const Icon(
            Icons.sentiment_neutral_rounded,
            color: Colors.orange,
            size: 40,
          ),
        );
      case InfoDialogStatus.success:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade100,
          ),
          child: const Icon(
            Icons.celebration_rounded,
            color: Colors.green,
            size: 40,
          ),
        );
      case InfoDialogStatus.info:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade100,
          ),
          child: const Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.blue,
            size: 40,
          ),
        );
    }
  }

  String _getPlayfulTitle(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return 'Oops! Something went wrong';
      case InfoDialogStatus.warning:
        return 'Heads up!';
      case InfoDialogStatus.success:
        return 'Awesome! Well done!';
      case InfoDialogStatus.info:
        return 'Did you know?';
    }
  }

  String _getButtonText(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return 'Try Again';
      case InfoDialogStatus.warning:
        return 'Got It';
      case InfoDialogStatus.success:
        return 'Continue';
      case InfoDialogStatus.info:
        return 'Learn More';
    }
  }

  LinearGradient _getBackgroundGradient(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade50,
            Colors.pink.shade50,
          ],
        );
      case InfoDialogStatus.warning:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50,
            Colors.amber.shade50,
          ],
        );
      case InfoDialogStatus.success:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.teal.shade50,
          ],
        );
      case InfoDialogStatus.info:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
          ],
        );
    }
  }

  Color _getAccentColor(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return Colors.red.shade600;
      case InfoDialogStatus.warning:
        return Colors.orange.shade600;
      case InfoDialogStatus.success:
        return Colors.green.shade600;
      case InfoDialogStatus.info:
        return Colors.blue.shade600;
    }
  }

  Color _getTextColor(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return Colors.red.shade800;
      case InfoDialogStatus.warning:
        return Colors.orange.shade800;
      case InfoDialogStatus.success:
        return Colors.green.shade800;
      case InfoDialogStatus.info:
        return Colors.blue.shade800;
    }
  }
}
