import 'dart:async';

import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Handoff `.pe-scan` quick scan row.
class ProductEditorScanSection extends StatefulWidget {
  const ProductEditorScanSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onBarcodeScanned,
    required this.onRequestCamera,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onBarcodeScanned;
  final VoidCallback onRequestCamera;

  @override
  State<ProductEditorScanSection> createState() =>
      _ProductEditorScanSectionState();
}

class _ProductEditorScanSectionState extends State<ProductEditorScanSection> {
  Timer? _inputTimer;

  @override
  void dispose() {
    _inputTimer?.cancel();
    super.dispose();
  }

  void _submit(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    _inputTimer?.cancel();
    _inputTimer = Timer(const Duration(seconds: 1), () {
      widget.onBarcodeScanned(trimmed);
    });
  }

  bool get _showCamera =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.only(left: 16, right: 8),
          decoration: BoxDecoration(
            color: ProductEditorTokens.blueTint,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ProductEditorTokens.blue, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: ProductEditorTokens.blue.withValues(alpha: 0.08),
                blurRadius: 0,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.qr_code_scanner,
                size: 22,
                color: ProductEditorTokens.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  style: GoogleFonts.outfit(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: ProductEditorTokens.ink1,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Scan or type variant name…',
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                      color: ProductEditorTokens.ink3,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: _submit,
                ),
              ),
              if (_showCamera) ...[
                IconButton(
                  onPressed: widget.onRequestCamera,
                  icon: const Icon(
                    Icons.photo_camera_outlined,
                    color: ProductEditorTokens.blue,
                  ),
                  tooltip: 'Scan with camera',
                ),
              ],
              Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _submit(widget.controller.text),
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: ProductEditorTokens.gradBtn,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x402563EB),
                          offset: Offset(0, 3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 16, color: Colors.white),
                        const SizedBox(width: 7),
                        Text(
                          'Add variant',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 13,
              color: ProductEditorTokens.ink4,
            ),
            const SizedBox(width: 6),
            Text(
              'Press ',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: ProductEditorTokens.ink3,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: ProductEditorTokens.surface2,
                borderRadius: BorderRadius.circular(5),
                border: Border(
                  top: BorderSide(color: ProductEditorTokens.line),
                  left: BorderSide(color: ProductEditorTokens.line),
                  right: BorderSide(color: ProductEditorTokens.line),
                  // Flutter requires uniform border colors when using borderRadius.
                  bottom: BorderSide(color: ProductEditorTokens.line, width: 2),
                ),
              ),
              child: Text(
                'Enter',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: ProductEditorTokens.ink2,
                ),
              ),
            ),
            Text(
              ' or tap Add variant',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: ProductEditorTokens.ink3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
