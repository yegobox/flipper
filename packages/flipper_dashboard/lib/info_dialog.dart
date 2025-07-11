import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class InfoDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InfoDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status =
        request.data?['status'] as InfoDialogStatus? ?? InfoDialogStatus.info;
    final message = request.description ?? 'An unexpected error occurred.';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 24,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(status),
            const SizedBox(height: 16),
            Text(
              request.title ?? _getTitle(status),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => completer(DialogResponse(confirmed: true)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(status),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(InfoDialogStatus status) {
    switch (status) {
      case InfoDialogStatus.error:
        return const Icon(Icons.error_outline, color: Colors.red, size: 48);
      case InfoDialogStatus.warning:
        return const Icon(Icons.warning_amber_outlined,
            color: Colors.orange, size: 48);
      case InfoDialogStatus.success:
        return const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 48);
      case InfoDialogStatus.info:
        return const Icon(Icons.info_outline, color: Colors.blue, size: 48);
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

  Color _getButtonColor(InfoDialogStatus status) {
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
}
