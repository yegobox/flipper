import 'dart:convert';

import 'package:flipper_dashboard/features/admin/sections/admin_style.dart';
import 'package:flipper_dashboard/utils/pick_image_base64.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// The logo printed at the top of receipts.
///
/// [compact] puts the buttons under the preview, full width, for phones.
class ReceiptLogoCard extends StatefulWidget {
  const ReceiptLogoCard({super.key, this.compact = false});

  final bool compact;

  @override
  State<ReceiptLogoCard> createState() => _ReceiptLogoCardState();
}

class _ReceiptLogoCardState extends State<ReceiptLogoCard> {
  Uint8List? receiptLogoBytes;
  bool isUpdatingReceiptLogo = false;
  bool isRemovingReceiptLogo = false;

  @override
  void initState() {
    super.initState();
    final logoBase64 = ProxyService.box.receiptLogoBase64();
    if (logoBase64 != null && logoBase64.isNotEmpty) {
      try {
        receiptLogoBytes = base64Decode(logoBase64);
      } catch (_) {
        receiptLogoBytes = null;
      }
    }
  }

  Future<void> _pickReceiptLogo() async {
    try {
      setState(() {
        isUpdatingReceiptLogo = true;
      });

      final picked = await pickImageAsBase64(
        maxSizeBytes: 295 * 1024, // plenty for a thermal receipt logo
      );

      if (!mounted) return;

      if (picked.image == null) {
        setState(() {
          isUpdatingReceiptLogo = false;
        });
        // Dismissing the picker is not a failure worth a red banner.
        if (!picked.cancelled) {
          showErrorNotification(context, picked.message!);
        }
        return;
      }

      await ProxyService.box.setReceiptLogoBase64(picked.image!.base64);

      if (!mounted) return;

      setState(() {
        receiptLogoBytes = picked.image!.bytes;
        isUpdatingReceiptLogo = false;
      });

      showSuccessNotification(context, context.flipperL10n.adminLogoUpdated);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isUpdatingReceiptLogo = false;
      });
      showErrorNotification(
        context,
        context.flipperL10n.adminLogoUpdateFailed('$e'),
      );
    }
  }

  Future<void> _removeReceiptLogo() async {
    try {
      setState(() {
        isRemovingReceiptLogo = true;
      });

      await ProxyService.box.clearReceiptLogo();

      if (!mounted) return;

      setState(() {
        receiptLogoBytes = null;
        isRemovingReceiptLogo = false;
      });

      showSuccessNotification(context, context.flipperL10n.adminLogoRemoved);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isRemovingReceiptLogo = false;
      });
      showErrorNotification(
        context,
        context.flipperL10n.adminLogoRemoveFailed('$e'),
      );
    }
  }

  Widget _logoPreview() {
    return CustomPaint(
      foregroundPainter: _ReceiptLogoDashedBorderPainter(
        color: Colors.grey.shade400,
      ),
      child: Container(
        width: 88,
        height: 88,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        child: receiptLogoBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(receiptLogoBytes!, fit: BoxFit.contain),
              )
            : AdminDashboardSvgs.picture(
                AdminDashboardSvgs.receiptLogoPlaceholder,
                size: 36,
              ),
      ),
    );
  }

  Widget _actions(BuildContext context, ThemeData theme, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: isUpdatingReceiptLogo ? null : _pickReceiptLogo,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isUpdatingReceiptLogo)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                SvgPicture.string(
                  AdminDashboardSvgs.uploadIconWhite,
                  width: 16,
                  height: 16,
                ),
              const SizedBox(width: 8),
              Text(
                isUpdatingReceiptLogo
                    ? context.flipperL10n.adminUploading
                    : context.flipperL10n.adminUploadLogo,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: receiptLogoBytes != null && !isRemovingReceiptLogo
              ? _removeReceiptLogo
              : null,
          child: isRemovingReceiptLogo
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  context.flipperL10n.adminRemoveLogo,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: kAdminSubtitleText,
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final hint = Expanded(
      child: Text(
        context.flipperL10n.adminReceiptLogoHint,
        style: GoogleFonts.outfit(
          fontSize: 13,
          color: kAdminSubtitleText,
          height: 1.45,
        ),
      ),
    );
    return Container(
      decoration: adminCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.flipperL10n.adminReceiptLogo,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kAdminTitleText,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kAdminCardBorder),
            ),
            child: widget.compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _logoPreview(),
                          const SizedBox(width: 18),
                          hint,
                        ],
                      ),
                      const SizedBox(height: 16),
                      _actions(context, theme, primary),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _logoPreview(),
                      const SizedBox(width: 18),
                      hint,
                      const SizedBox(width: 16),
                      _actions(context, theme, primary),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Light dashed border for receipt logo drop zone (matches reference UI).
class _ReceiptLogoDashedBorderPainter extends CustomPainter {
  _ReceiptLogoDashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final extract = metric.extractPath(d, d + 5);
        canvas.drawPath(extract, paint);
        d += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ReceiptLogoDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
