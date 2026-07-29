import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_services/digital_receipt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Well-designed POS dialog: customer scans to open WhatsApp and message the
/// business so Meta can deliver the queued digital receipt.
Future<void> showWhatsAppMetaOptInDialog(
  BuildContext context,
  WhatsAppOptInPrompt prompt,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => WhatsAppMetaOptInDialog(prompt: prompt),
  );
}

class WhatsAppMetaOptInDialog extends StatelessWidget {
  const WhatsAppMetaOptInDialog({super.key, required this.prompt});

  final WhatsAppOptInPrompt prompt;

  static const _waGreen = Color(0xFF128C7E);
  static const _waGreenDark = Color(0xFF075E54);
  static const _surface = Color(0xFFF7F8FA);

  Uint8List? get _qrBytes {
    final b64 = prompt.qrPngBase64?.trim();
    if (b64 == null || b64.isEmpty) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatUrl = prompt.chatUrl?.trim();
    final qrBytes = _qrBytes;
    final hasQrData =
        (chatUrl != null && chatUrl.isNotEmpty) || qrBytes != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Material(
          color: Colors.white,
          elevation: 12,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_waGreenDark, _waGreen],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scan to receive receipt',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customer must message your WhatsApp business number '
                      'once so we can send their digital receipt.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  children: [
                    if (hasQrData)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            if (qrBytes != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  qrBytes,
                                  width: 220,
                                  height: 220,
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                ),
                              )
                            else if (chatUrl != null && chatUrl.isNotEmpty)
                              QrImageView(
                                data: chatUrl,
                                version: QrVersions.auto,
                                size: 220,
                                backgroundColor: Colors.white,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: _waGreenDark,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              'Open WhatsApp → scan with the camera',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFED7AA)),
                        ),
                        child: Text(
                          'Receipt is queued. Ask the customer to message your '
                          'WhatsApp business number, then the PDF will send '
                          'automatically.',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            height: 1.4,
                            color: const Color(0xFF9A3412),
                          ),
                        ),
                      ),
                    if (chatUrl != null && chatUrl.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: chatUrl));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'WhatsApp link copied',
                                style: GoogleFonts.outfit(),
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.link_rounded,
                                size: 18,
                                color: _waGreen,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  chatUrl,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: _waGreenDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Copy',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _waGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Receipt phone: ${prompt.phone}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: _waGreenDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
