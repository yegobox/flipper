import 'package:flipper_dashboard/features/tickets/providers/handover_staff_provider.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Right-side panel: pick a Stock Handover staff member to receive the order
/// form PDF on WhatsApp while the ticket list stays visible.
class HandoverStaffPickerPanel extends ConsumerWidget {
  const HandoverStaffPickerPanel({
    super.key,
    required this.ticket,
    required this.onClose,
    required this.onStaffSelected,
    this.isSending = false,
  });

  final ITransaction ticket;
  final VoidCallback onClose;
  final ValueChanged<HandoverStaffMember> onStaffSelected;
  final bool isSending;

  static const Color _whatsapp = Color(0xFF16A34A);
  static const Color _whatsappTint = Color(0xFFDCFCE7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(handoverStaffProvider);
    final displayRef = _ticketDisplayRef(ticket);
    final customer =
        (ticket.customerName ?? ticket.ticketName ?? 'Walk-in').trim();

    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 8, 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _whatsappTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chat_rounded,
                    size: 22,
                    color: _whatsapp,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send via WhatsApp',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: PosTokens.ink1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ticket #$displayRef · ${customer.isEmpty ? 'Walk-in' : customer}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: PosTokens.ink3,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: isSending ? null : onClose,
                  icon: const Icon(Icons.close_rounded, size: 22),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Text(
              'STOCK HANDOVER STAFF',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: PosTokens.ink3,
              ),
            ),
          ),
          if (isSending)
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(_whatsapp),
            ),
          Expanded(
            child: staffAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Could not load handover staff.',
                  style: GoogleFonts.outfit(color: PosTokens.ink2),
                  textAlign: TextAlign.center,
                ),
              ),
              data: (staff) {
                if (staff.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No staff with Stock Handover access and a phone number '
                      'on file. Add a phone on their tenant profile and grant '
                      'StockHandover access.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: PosTokens.ink2,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                  itemCount: staff.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final member = staff[index];
                    return _StaffMemberTile(
                      member: member,
                      enabled: !isSending,
                      onTap: () => onStaffSelected(member),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffMemberTile extends StatelessWidget {
  const _StaffMemberTile({
    required this.member,
    required this.onTap,
    required this.enabled,
  });

  final HandoverStaffMember member;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.surface2,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: member.avatarColor,
                child: Text(
                  member.initials,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: PosTokens.ink1,
                      ),
                    ),
                    Text(
                      member.phoneNumber,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: PosTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.send_rounded,
                size: 18,
                color: enabled ? HandoverStaffPickerPanel._whatsapp : PosTokens.ink3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _ticketDisplayRef(ITransaction ticket) {
  final r = ticket.reference?.trim();
  if (r != null && r.isNotEmpty) return r.toUpperCase();
  if (ticket.id.length >= 6) {
    return ticket.id.substring(0, 6).toUpperCase();
  }
  return ticket.id.toUpperCase();
}
