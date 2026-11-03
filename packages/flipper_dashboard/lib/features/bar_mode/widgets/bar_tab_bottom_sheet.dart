import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

class BarTabBottomSheet extends StatelessWidget {
  const BarTabBottomSheet({
    super.key,
    required this.tableName,
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
    this.onChargeToRoom,
    this.onPutOnCredit,
    this.onPrint,
  });

  final String tableName;
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

  /// Null when the branch has no hotel guest to charge — the bar-only case.
  final VoidCallback? onChargeToRoom;

  /// Null when this cashier needs a manager PIN to settle; credit then goes
  /// through Settle like any other tender.
  final VoidCallback? onPutOnCredit;

  /// Prints the tab for the guest (not a fiscal receipt). Null hides it.
  final VoidCallback? onPrint;

  /// Below this the footer scrolls with the lines instead of being pinned:
  /// with every action showing it is about 430 tall. Set at the default text
  /// size and scaled with the system text size (see [build]).
  static const double _pinnedFooterMinSheetHeight = 640;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final footNote = serverCount > 1
        ? l10n.barLoggedByStaff('$serverCount', '$myLines')
        : l10n.barYouLoggedLines(myLines);
    final needsManagerPin =
        !isManager && BarModeSettings.managerSettle && lineCount > 0;

    final emptyLines = Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        l10n.barTapProductsFirstRound,
        style: GoogleFonts.outfit(color: BarTokens.ink3),
        textAlign: TextAlign.center,
      ),
    );
    // Group headers and lines as one flat list, so either layout can build
    // just the rows on screen: a long tab has many.
    final rows = <Object>[
      for (final entry in grouped.entries) ...[entry, ...entry.value],
    ];
    Widget rowAt(int i) {
      final row = rows[i];
      return row is MapEntry<String, List<TransactionItem>>
          ? _groupHeader(l10n, row.key, row.value, staff)
          : _lineRow(l10n, row as TransactionItem, cashier, isManager);
    }

    const linesPadding = EdgeInsets.symmetric(horizontal: 18);
    final footer = Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BarTokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Under large system text the label shortens and the total
          // shrinks rather than overflow; at normal sizes neither changes.
          LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.barTabTotal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: BarTokens.ink2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.7,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
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
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.people_outline, size: 14, color: BarTokens.ink3),
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
                child: _outlineBtn(l10n.barBackToTables, onBackToTables),
              ),
              const SizedBox(width: 10),
              Expanded(child: _primaryBtn(l10n.barSaveToTab, onSaveToTab)),
            ],
          ),
          const SizedBox(height: 10),
          _outlineBtn(
            needsManagerPin ? l10n.barSettleManagerPin : l10n.barSettleAndClose,
            lineCount == 0 ? null : onSettle,
            icon: needsManagerPin
                ? Icons.verified_user_outlined
                : Icons.account_balance_wallet_outlined,
          ),
          if (onPutOnCredit != null) ...[
            const SizedBox(height: 10),
            KeyedSubtree(
              key: const ValueKey('bar_tab_sheet_credit'),
              child: _outlineBtn(
                l10n.barPutOnCredit,
                lineCount == 0 ? null : onPutOnCredit,
                icon: Icons.schedule_outlined,
              ),
            ),
          ],
          if (onPrint != null) ...[
            const SizedBox(height: 10),
            KeyedSubtree(
              key: const ValueKey('bar_tab_sheet_print'),
              child: _outlineBtn(
                l10n.ticketPrint,
                lineCount == 0 ? null : onPrint,
                icon: Icons.print_outlined,
              ),
            ),
          ],
          // Moves the tab onto a resident guest's folio instead
          // of taking money for it now.
          if (onChargeToRoom != null) ...[
            const SizedBox(height: 10),
            _outlineBtn(
              l10n.barChargeToRoom,
              lineCount == 0 ? null : onChargeToRoom,
              icon: Icons.hotel_outlined,
              accent: lineCount == 0 ? null : BarTokens.violet,
            ),
          ],
        ],
      ),
    );

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
            // The host's SafeArea, not the whole screen: 0.88 of the screen
            // ran under the status bar and the gesture bar.
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxHeight = constraints.maxHeight * 0.88;
                // Larger system text makes the header and the footer's text
                // rows taller, so a pinned footer could outgrow the sheet and
                // be clipped. The whole threshold scales, though the 48pt
                // buttons do not, so the scroll layout takes over early.
                final textScale = math.max(
                  1.0,
                  MediaQuery.textScalerOf(context).scale(14) / 14,
                );
                final scrollFooter =
                    maxHeight < _pinnedFooterMinSheetHeight * textScale;
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
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
                              child: BarTableBadgeText(tableName, fontSize: 15),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.barRunningTab,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    l10n.barZoneItemCount(zoneName, lineCount),
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
                      if (scrollFooter)
                        // A short phone cannot pin a footer of up to six actions
                        // under the lines: they scroll together instead.
                        Flexible(
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              if (lines.isEmpty)
                                SliverToBoxAdapter(child: emptyLines)
                              else
                                SliverPadding(
                                  padding: linesPadding,
                                  sliver: SliverList.builder(
                                    itemCount: rows.length,
                                    itemBuilder: (_, i) => rowAt(i),
                                  ),
                                ),
                              SliverToBoxAdapter(child: footer),
                            ],
                          ),
                        )
                      else ...[
                        Flexible(
                          child: lines.isEmpty
                              ? emptyLines
                              : ListView.builder(
                                  padding: linesPadding,
                                  itemCount: rows.length,
                                  itemBuilder: (_, i) => rowAt(i),
                                ),
                        ),
                        footer,
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _groupHeader(
    FlipperAppLocalizations l10n,
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
    final name =
        tenant?.name ?? lines.first.loggedByName ?? l10n.barStaffFallback;
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

  Widget _lineRow(
    FlipperAppLocalizations l10n,
    TransactionItem line,
    Tenant cashier,
    bool isManager,
  ) {
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
                  l10n.barPriceEach(
                    'RWF ${NumberFormat('#,###').format(line.price)}',
                  ),
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
        // 40: this sheet only ever shows on a phone, under a thumb.
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: BarTokens.line, width: 1.5),
          ),
          child: Icon(icon, size: 17),
        ),
      ),
    );
  }

  Widget _outlineBtn(
    String label,
    VoidCallback? onTap, {
    IconData? icon,
    Color? accent,
  }) {
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
            border: Border.all(
              color: accent ?? BarTokens.lineStrong,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17, color: accent ?? BarTokens.ink3),
                const SizedBox(width: 8),
              ],
              // Long labels (translations, narrow phones) ellipsize, not overflow.
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: accent ?? BarTokens.ink1,
                  ),
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
