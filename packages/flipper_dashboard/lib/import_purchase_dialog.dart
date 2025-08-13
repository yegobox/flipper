import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_dashboard/ImportPurchasePage.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_dashboard/kafka_service.dart';
import 'package:overlay_support/overlay_support.dart';

class ImportPurchaseDialog extends StatefulWidget {
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
  State<ImportPurchaseDialog> createState() => _ImportPurchaseDialogState();
}

class _ImportPurchaseDialogState extends State<ImportPurchaseDialog> {
  late StreamSubscription _kafkaSubscription;

  @override
  void initState() {
    super.initState();
    _kafkaSubscription = KafkaService().messages.listen((message) {
      toast(
        message,
      );
    });
  }

  @override
  void dispose() {
    _kafkaSubscription.cancel();
    super.dispose();
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
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minWidth: MediaQuery.of(context).size.width * 0.9,
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
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(importPurchaseViewModelProvider);
        final isImport = state.when(
          data: (s) => s.isImport,
          loading: () => true,
          error: (_, __) => true,
        );
        final isExporting = state.when(
          data: (s) => s.isExporting,
          loading: () => false,
          error: (_, __) => false,
        );

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
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
              Row(
                children: [
                  IconButton(
                    icon: isExporting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          )
                        : const Icon(Icons.file_download,
                            color: Colors.black87),
                    tooltip: 'Export',
                    onPressed: isExporting
                        ? null
                        : () {
                            if (isImport) {
                              ref
                                  .read(
                                      importPurchaseViewModelProvider.notifier)
                                  .exportImport();
                            } else {
                              ref
                                  .read(
                                      importPurchaseViewModelProvider.notifier)
                                  .exportPurchase();
                            }
                          },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
