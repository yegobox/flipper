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

class _InfoDialogState extends State<InfoDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status =
        widget.request.data?['status'] as InfoDialogStatus? ??
        InfoDialogStatus.info;
    final message =
        widget.request.description ?? 'An unexpected error occurred.';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconContainer(status),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.request.title ?? _getTitle(status),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          widget.completer(DialogResponse(confirmed: false)),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        widget.completer(DialogResponse(confirmed: true)),
                    style: FilledButton.styleFrom(
                      backgroundColor: _getColor(status),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.request.data?['mainButtonText'] ??
                          _getButtonText(status),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(InfoDialogStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_getIcon(status), color: _getColor(status), size: 24),
    );
  }

  IconData _getIcon(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return Icons.error_outline_rounded;
      case InfoDialogStatus.warning:
        return Icons.warning_amber_rounded;
      case InfoDialogStatus.success:
        return Icons.check_circle_outline_rounded;
      case InfoDialogStatus.info:
        return Icons.info_outline_rounded;
    }
  }

  Color _getColor(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return Colors.red;
      case InfoDialogStatus.warning:
        return Colors.orange;
      case InfoDialogStatus.success:
        return Colors.green;
      case InfoDialogStatus.info:
        return Colors.blue;
    }
  }

  String _getTitle(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return 'Error';
      case InfoDialogStatus.warning:
        return 'Warning';
      case InfoDialogStatus.success:
        return 'Success';
      case InfoDialogStatus.info:
        return 'Information';
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
        return 'Dismiss';
    }
  }
}
