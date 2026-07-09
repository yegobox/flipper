import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

class BarTabBottomSheet extends StatelessWidget {
  const BarTabBottomSheet({
    super.key,
    required this.tableBadge,
    required this.zoneName,
    required this.lines,
    required this.grouped,
    required this.staff,
    required this.cashier,
    required this.isManager,
    required this.total,
    required this.lineCount,
    required this.serverCount,
    required this.myLines,
    required this.onClose,
    required this.onQtyDelta,
    required this.onSaveToTab,
    required this.onBackToTables,
    required this.onSettle,
  });

  final String tableBadge;
  final String zoneName;
  final List<TransactionItem> lines;
  final Map<String, List<TransactionItem>> grouped;
  final List<Tenant> staff;
  final Tenant cashier;
  final bool isManager;
  final double total;
  final int lineCount;
  final int serverCount;
  final int myLines;
  final VoidCallback onClose;
  final void Function(TransactionItem line, int delta) onQtyDelta;
  final VoidCallback onSaveToTab;
  final VoidCallback onBackToTables;
  final VoidCallback onSettle;

  @override
  Widget build(BuildContext context) {
    final footNote = serverCount > 1
        ? 'Logged by $serverCount staff · you added $myLines'
        : "You've logged $myLines line${myLines == 1 ? '' : 's'} on this tab";
    final needsManagerPin =
        !isManager && BarModeSettings.managerSettle && lineCount > 0;

    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(color: const Color(0x6B0B1220)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: BarTokens.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(BarTokens.mobileSheetRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.88,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: BarTokens.lineStrong,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: BarTokens.blue,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Text(
                            tableBadge,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Running tab',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$zoneName · $lineCount item${lineCount == 1 ? '' : 's'}',
                                style: GoogleFonts.outfit(
                                  fontSize: 11.5,
                                  color: BarTokens.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: BarTokens.surface2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: BarTokens.line),
                  Flexible(
                    child: lines.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Tap products to add the first round',
                              style: GoogleFonts.outfit(color: BarTokens.ink3),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            children: [
                              for (final entry in grouped.entries) ...[
                                _groupHeader(entry.key, entry.value, staff),
                                for (final line in entry.value)
                                  _lineRow(line, cashier, isManager),
                              ],
                            ],
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: BarTokens.line)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Tab total',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: BarTokens.ink2,
                              ),
                            ),
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'RWF ',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12,
                                      color: BarTokens.ink3,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: NumberFormat('#,###').format(total),
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: BarTokens.ink1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.people_outline,
                                size: 14, color: BarTokens.ink3),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                footNote,
                                style: GoogleFonts.outfit(
                                  fontSize: 11.5,
                                  color: BarTokens.ink3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _outlineBtn('Back to tables', onBackToTables),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _primaryBtn('Save to tab', onSaveToTab),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _outlineBtn(
                          needsManagerPin
                              ? 'Settle bill · manager PIN'
                              : 'Settle bill & close table',
                          lineCount == 0 ? null : onSettle,
                          icon: needsManagerPin
                              ? Icons.verified_user_outlined
                              : Icons.account_balance_wallet_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _groupHeader(
    String tenantId,
    List<TransactionItem> lines,
    List<Tenant> staff,
  ) {
    Tenant? tenant;
    for (final t in staff) {
      if (t.id == tenantId) {
        tenant = t;
        break;
      }
    }
    final name = tenant?.name ?? lines.first.loggedByName ?? 'Staff';
    final initials = barTenantInitials(name);
    final color = barColorForTenant(tenantId, staff);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 7),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              initials,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            (barFirstName(name) ?? name).toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.03,
              color: BarTokens.ink4,
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(child: Divider(color: BarTokens.line)),
        ],
      ),
    );
  }

  Widget _lineRow(TransactionItem line, Tenant cashier, bool isManager) {
    final editable = isManager || line.loggedByTenantId == cashier.id;
    final thumbColor = barColorForName(line.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: thumbColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              barAbbrevForName(line.name),
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'RWF ${NumberFormat('#,###').format(line.price)} each',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    color: BarTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          if (editable)
            _stepper(
              qty: line.qty.toInt(),
              onMinus: () => onQtyDelta(line, -1),
              onPlus: () => onQtyDelta(line, 1),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '×${line.qty.toInt()}',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.lock_outline, size: 14, color: BarTokens.ink4),
              ],
            ),
          const SizedBox(width: 8),
          Text(
            NumberFormat('#,###').format(line.price * line.qty),
            style: GoogleFonts.jetBrainsMono(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepper({
    required int qty,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepBtn(Icons.remove, onMinus),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '$qty',
            style: GoogleFonts.jetBrainsMono(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        _stepBtn(Icons.add, onPlus),
      ],
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: BarTokens.line, width: 1.5),
          ),
          child: Icon(icon, size: 15),
        ),
      ),
    );
  }

  Widget _outlineBtn(String label, VoidCallback? onTap, {IconData? icon}) {
    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BarTokens.lineStrong, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17, color: BarTokens.ink3),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryBtn(String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
        child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: BarTokens.gradBtn,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
