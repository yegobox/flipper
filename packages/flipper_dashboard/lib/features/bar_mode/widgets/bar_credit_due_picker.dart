import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "When will they pay?" — one tap on a preset, the same ones the POS loan
/// form offers, or a date from the calendar.
class BarCreditDuePicker extends StatelessWidget {
  const BarCreditDuePicker({super.key, required this.customerName});

  final String customerName;

  /// The chosen due date in UTC, or null when dismissed.
  static Future<DateTime?> show(
    BuildContext context, {
    required String customerName,
    required bool mobile,
  }) {
    final picker = BarCreditDuePicker(customerName: customerName);
    if (mobile) {
      return showModalBottomSheet<DateTime>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => picker,
      );
    }
    return showDialog<DateTime>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: picker,
        ),
      ),
    );
  }

  static DateTime _inDays(int days) =>
      DateTime.now().toUtc().add(Duration(days: days));

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null || !context.mounted) return;
    Navigator.of(context).pop(picked.toUtc());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.barCreditDueTitle(customerName),
                style: GoogleFonts.outfit(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: BarTokens.ink1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.uiTicketDueDate,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: BarTokens.ink3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _option(
                context,
                l10n.uiTicketOneWeek,
                () => Navigator.of(context).pop(_inDays(7)),
              ),
              _option(
                context,
                l10n.uiTicketTwoWeeks,
                () => Navigator.of(context).pop(_inDays(14)),
              ),
              _option(
                context,
                l10n.uiTicketOneMonth,
                () => Navigator.of(context).pop(_inDays(30)),
              ),
              _option(
                context,
                l10n.uiTicketSelectDate,
                () => _pickDate(context),
                icon: Icons.calendar_today_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(
    BuildContext context,
    String label,
    VoidCallback onTap, {
    IconData icon = Icons.event_outlined,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(BarTokens.radiusMd),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BarTokens.radiusMd),
              border: Border.all(color: BarTokens.line, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: BarTokens.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: BarTokens.ink1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: BarTokens.ink3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
