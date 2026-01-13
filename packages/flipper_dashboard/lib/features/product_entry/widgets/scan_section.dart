import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ScanSection extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onBarcodeScanned;
  final VoidCallback onRequestCamera;

  const ScanSection({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onBarcodeScanned,
    required this.onRequestCamera,
  }) : super(key: key);

  @override
  State<ScanSection> createState() => _ScanSectionState();
}

class _ScanSectionState extends State<ScanSection> {
  Timer? _inputTimer;

  @override
  void dispose() {
    _inputTimer?.cancel();
    super.dispose();
  }

  void _handleSubmission(String value) {
    if (value.isEmpty) return;

    // We assume validation is handled by the parent or we validate here if needed.
    // Ideally, we should check Form.of(context)?.validate() ?? false
    if (Form.of(context).validate()) {
      _inputTimer?.cancel();
      _inputTimer = Timer(const Duration(seconds: 1), () {
        widget.onBarcodeScanned(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quick Scan",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                labelText: 'Scan or Type Barcode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                filled: true,
                fillColor: Colors.grey.shade50,
                suffixIcon: (Platform.isAndroid || Platform.isIOS)
                    ? IconButton(
                        icon: const Icon(
                          FluentIcons.camera_20_regular,
                          color: Colors.blue,
                        ),
                        onPressed: widget.onRequestCamera,
                      )
                    : null,
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: _handleSubmission,
            ),
          ],
        ),
      ),
    );
  }
}
