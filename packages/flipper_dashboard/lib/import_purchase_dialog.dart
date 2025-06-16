import 'package:flutter/material.dart';
import 'package:flipper_dashboard/ImportPurchasePage.dart';

class ImportPurchaseDialog extends StatelessWidget {
  const ImportPurchaseDialog({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final deviceType = _getDeviceType(context);
    if (deviceType == "Phone" || deviceType == "Phablet") {
      return;
    }

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ImportPurchaseDialog(),
    );
  }

  static String _getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 480) return "Phone";
    if (width < 768) return "Phablet";
    if (width < 1024) return "Tablet";
    return "Desktop";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: ImportPurchasePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Import & Purchase Management',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
