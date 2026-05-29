import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_dashboard/widgets/custom_segmented_button.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const Color _kSheetAccent = PosLayoutBreakpoints.posAccentBlue;

Future<void> persistSaleAgentAttribution(
  WidgetRef ref,
  ITransaction transaction, {
  Tenant? agent,
  SaleAgentCommissionType? commissionType,
  num? commissionValue,
  bool clear = false,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final txn = transaction;

  if (clear) {
    txn.attributedAgentUserId = null;
    txn.agentCommissionType = null;
    txn.agentCommissionValue = null;
    txn.agentCommissionAmount = null;
  } else if (agent != null &&
      commissionType != null &&
      commissionValue != null) {
    final typeDb = saleAgentCommissionTypeToDb(commissionType);
    txn.attributedAgentUserId = agent.userId;
    txn.agentCommissionType = typeDb;
    txn.agentCommissionValue = commissionValue;
    txn.agentCommissionAmount = commissionType == SaleAgentCommissionType.fixed
        ? commissionValue
        : null;
  }

  await capella.updateTransaction(transaction: txn, transactionId: txn.id);
  ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
}

Future<void> showSaleAgentAssignmentSheet({
  required BuildContext context,
  required WidgetRef ref,
  required ITransaction transaction,
}) async {
  final List<Tenant> agents =
      await FlipperBaseModel.fetchAgentTenantsFromSupabase();

  Tenant? selectedAgent;
  final initialUid = transaction.attributedAgentUserId;
  if (initialUid != null && initialUid.isNotEmpty) {
    for (final a in agents) {
      if (a.userId == initialUid) {
        selectedAgent = a;
        break;
      }
    }
  }

  var commissionType =
      saleAgentCommissionTypeFromDb(transaction.agentCommissionType) ??
      SaleAgentCommissionType.fixed;
  final valueController = TextEditingController(
    text: transaction.agentCommissionValue != null
        ? transaction.agentCommissionValue.toString()
        : '',
  );
  var filtered = List<Tenant>.from(agents);

  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalContext) {
      return [
        WoltModalSheetPage(
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const ModalSheetTopBarTitle('Assign agent'),
          pageTitle: const ModalSheetTitle('Assign agent'),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              void filterAgents(String q) {
                final query = q.trim().toLowerCase();
                setModalState(() {
                  if (query.isEmpty) {
                    filtered = List<Tenant>.from(agents);
                  } else {
                    filtered = agents.where((t) {
                      final name = tenantDisplayName(t).toLowerCase();
                      final email = (t.email ?? t.phoneNumber ?? '')
                          .toLowerCase();
                      return name.contains(query) || email.contains(query);
                    }).toList();
                  }
                });
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SheetSectionLabel(title: 'AGENTS', count: agents.length),
                    const SizedBox(height: 12),
                    TicketSearchBar(
                      hintText: 'Search agents...',
                      onChanged: filterAgents,
                    ),
                    const SizedBox(height: 14),
                    if (agents.isEmpty)
                      _SheetEmptyMessage(
                        text:
                            'No agents found for this business. Add agents in User Management.',
                      )
                    else if (filtered.isEmpty)
                      _SheetEmptyMessage(text: 'No agents match your search.')
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 240),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final agent = filtered[index];
                              final selected =
                                  selectedAgent?.userId == agent.userId;
                              return _AgentSelectTile(
                                agent: agent,
                                selected: selected,
                                onTap: () {
                                  setModalState(() => selectedAgent = agent);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const _SheetSectionLabel(title: 'COMMISSION'),
                    const SizedBox(height: 12),
                    CustomSegmentedButton<SaleAgentCommissionType>(
                      segments: const [
                        ButtonSegment(
                          value: SaleAgentCommissionType.fixed,
                          label: Text('Fixed (RWF)'),
                        ),
                        ButtonSegment(
                          value: SaleAgentCommissionType.percent,
                          label: Text('Percent (%)'),
                        ),
                      ],
                      selected: {commissionType},
                      selectedBackgroundColor: _kSheetAccent,
                      borderColor: _kSheetAccent,
                      unselectedForegroundColor: _kSheetAccent,
                      borderRadius: 12,
                      onSelectionChanged: (selection) {
                        setModalState(() {
                          commissionType = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: valueController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: GoogleFonts.outfit(fontSize: 15),
                      decoration: _sheetFieldDecoration(
                        label: commissionType == SaleAgentCommissionType.fixed
                            ? 'Amount (RWF)'
                            : 'Rate (%)',
                        hint: commissionType == SaleAgentCommissionType.fixed
                            ? 'e.g. 500'
                            : 'e.g. 5',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[800],
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              await persistSaleAgentAttribution(
                                ref,
                                transaction,
                                clear: true,
                              );
                              if (modalContext.mounted) {
                                Navigator.of(modalContext).pop();
                              }
                            },
                            child: Text(
                              'Clear',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: _kSheetAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              if (selectedAgent == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Select an agent',
                                      style: GoogleFonts.outfit(),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              final raw = valueController.text.trim();
                              final value = num.tryParse(raw);
                              if (value == null || value <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Enter a valid commission',
                                      style: GoogleFonts.outfit(),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              if (commissionType ==
                                      SaleAgentCommissionType.percent &&
                                  value > 100) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Percent cannot exceed 100',
                                      style: GoogleFonts.outfit(),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              await persistSaleAgentAttribution(
                                ref,
                                transaction,
                                agent: selectedAgent,
                                commissionType: commissionType,
                                commissionValue: value,
                              );
                              if (modalContext.mounted) {
                                Navigator.of(modalContext).pop();
                              }
                            },
                            child: Text(
                              'Apply',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ];
    },
  );

  valueController.dispose();
}

class _SheetSectionLabel extends StatelessWidget {
  const _SheetSectionLabel({required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: Colors.grey[600],
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SheetEmptyMessage extends StatelessWidget {
  const _SheetEmptyMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
      ),
    );
  }
}

class _AgentSelectTile extends StatelessWidget {
  const _AgentSelectTile({
    required this.agent,
    required this.selected,
    required this.onTap,
  });

  final Tenant agent;
  final bool selected;
  final VoidCallback onTap;

  static String _initials(Tenant tenant) {
    final name = (tenant.name ?? '').trim();
    if (name.isEmpty) return '?';
    final parts = name
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      final a = parts[0].isNotEmpty ? parts[0][0] : '';
      final b = parts[1].isNotEmpty ? parts[1][0] : '';
      return ('$a$b').toUpperCase();
    }
    final single = parts[0];
    if (single.length >= 2) return single.substring(0, 2).toUpperCase();
    return single[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = agent.email?.trim().isNotEmpty == true
        ? agent.email!
        : (agent.phoneNumber ?? 'No contact');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? _kSheetAccent : Colors.grey[300]!,
              width: selected ? 1.8 : 1,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: _kSheetAccent.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _kSheetAccent,
                child: Text(
                  _initials(agent),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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
                      tenantDisplayName(agent),
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EA2).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6B4EA2).withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Agent',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B4EA2),
                  ),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle, color: _kSheetAccent, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _sheetFieldDecoration({required String label, String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: GoogleFonts.outfit(color: Colors.grey[700]),
    hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[500]),
    filled: true,
    fillColor: const Color(0xFFF3F4F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kSheetAccent, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
