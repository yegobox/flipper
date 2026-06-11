import 'dart:async';

import 'package:flipper_dashboard/ImportPurchasePage.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
import 'package:flipper_dashboard/features/import_purchase/record_purchase_modal.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/import_purchase_dates_provider.dart';
import 'package:flipper_services/kafka_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

/// Full-page wrapper around [ImportPurchasePage], shown as a dashboard page
/// (DashboardPage.purchases). Header + subbar match design_handoff_import_purchase.
class ImportPurchasePageView extends StatefulHookConsumerWidget {
  const ImportPurchasePageView({Key? key}) : super(key: key);

  @override
  ConsumerState<ImportPurchasePageView> createState() =>
      _ImportPurchasePageViewState();
}

class _ImportPurchasePageViewState
    extends ConsumerState<ImportPurchasePageView> {
  late StreamSubscription<String> _kafkaSubscription;

  @override
  void initState() {
    super.initState();
    _kafkaSubscription = KafkaService().messages.listen((message) {
      toast(message);
    });
  }

  @override
  void dispose() {
    _kafkaSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importPurchaseViewModelProvider);
    final isImport = state.when(
      data: (s) => s.isImport,
      loading: () => false,
      error: (_, __) => false,
    );
    final isExporting = state.when(
      data: (s) => s.isExporting,
      loading: () => false,
      error: (_, __) => false,
    );
    final width = MediaQuery.sizeOf(context).width;
    final gutter = ImportPurchaseTokens.gutter(width);

    return IpmScreenBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: gutter),
            decoration: const BoxDecoration(
              color: ImportPurchaseTokens.surface,
              border: Border(bottom: BorderSide(color: ImportPurchaseTokens.line)),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Import & Purchase Management',
              style: ImportPurchaseHelpers.text(
                size: width <= ImportPurchaseTokens.mobileBreakpoint ? 16.5 : 19,
                weight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
          _buildSubbar(
            context,
            isImport: isImport,
            isExporting: isExporting,
            gutter: gutter,
          ),
          Expanded(child: ImportPurchasePage()),
        ],
      ),
    );
  }

  Widget _buildSubbar(
    BuildContext context, {
    required bool isImport,
    required bool isExporting,
    required double gutter,
  }) {
    final requestType = isImport ? 'IMPORT' : 'PURCHASE';
    final activeBranchAsync = ref.watch(activeBranchProvider);

    Widget dateWidget = activeBranchAsync.when(
      data: (branch) {
        final lastDateAsync = ref.watch(
          importPurchaseDatesProvider(
            branchId: branch.id,
            requestType: requestType,
          ),
        );
        return lastDateAsync.when(
          data: (lastDate) => _dateField(
            isImport: isImport,
            date: lastDate ?? DateTime.now(),
          ),
          loading: () => _dateField(
            isImport: isImport,
            date: DateTime.now(),
            loading: true,
          ),
          error: (_, __) => _dateField(
            isImport: isImport,
            date: DateTime.now(),
          ),
        );
      },
      loading: () => _dateField(isImport: isImport, date: DateTime.now()),
      error: (_, __) => _dateField(isImport: isImport, date: DateTime.now()),
    );

    final modeControl = IpmSegmentedControl(
      isImport: isImport,
      onChanged: (value) {
        ref.read(importPurchaseViewModelProvider.notifier).toggleImportPurchase(value);
      },
    );

    return Container(
      decoration: const BoxDecoration(
        color: ImportPurchaseTokens.surface,
        border: Border(bottom: BorderSide(color: ImportPurchaseTokens.line)),
      ),
      padding: EdgeInsets.fromLTRB(gutter, 14, gutter, 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile =
              constraints.maxWidth <= ImportPurchaseTokens.mobileBreakpoint;

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Flexible(child: dateWidget),
                    const SizedBox(width: 12),
                    _SubbarIconButton(
                      icon: Icons.file_download_outlined,
                      label: 'Export',
                      variant: _SubbarButtonVariant.ghost,
                      showLabel: false,
                      loading: isExporting,
                      onPressed: isExporting ? null : () => _export(isImport),
                    ),
                    const SizedBox(width: 8),
                    _SubbarIconButton(
                      icon: Icons.post_add_outlined,
                      label: 'Record Purchase',
                      variant: _SubbarButtonVariant.primary,
                      showLabel: false,
                      onPressed: () => showRecordPurchaseModal(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                modeControl,
              ],
            );
          }

          return Row(
            children: [
              dateWidget,
              const SizedBox(width: 16),
              _SubbarIconButton(
                icon: Icons.file_download_outlined,
                label: 'Export',
                variant: _SubbarButtonVariant.ghost,
                showLabel: true,
                loading: isExporting,
                onPressed: isExporting ? null : () => _export(isImport),
              ),
              const SizedBox(width: 12),
              _SubbarIconButton(
                icon: Icons.post_add_outlined,
                label: 'Record Purchase',
                variant: _SubbarButtonVariant.primary,
                showLabel: true,
                onPressed: () => showRecordPurchaseModal(context, ref),
              ),
              const Spacer(),
              modeControl,
            ],
          );
        },
      ),
    );
  }

  Widget _dateField({
    required bool isImport,
    required DateTime date,
    bool loading = false,
  }) {
    final label = isImport ? 'Import from' : 'Purchase from';
    final formatted = DateFormat('yyyy-MM-dd').format(date);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: ImportPurchaseHelpers.text(
            size: 13.5,
            weight: FontWeight.w600,
            color: ImportPurchaseTokens.ink2,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ImportPurchaseTokens.surface,
            borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
            border: Border.all(color: ImportPurchaseTokens.line2),
          ),
          child: loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  formatted,
                  style: ImportPurchaseHelpers.text(
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  void _export(bool isImport) {
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    if (isImport) {
      notifier.exportImport();
    } else {
      notifier.exportPurchase();
    }
  }
}

enum _SubbarButtonVariant { primary, ghost }

/// Subbar action buttons — 38px tall per design handoff §5.
class _SubbarIconButton extends StatelessWidget {
  const _SubbarIconButton({
    required this.icon,
    required this.label,
    required this.variant,
    required this.showLabel,
    this.loading = false,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final _SubbarButtonVariant variant;
  final bool showLabel;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final isPrimary = variant == _SubbarButtonVariant.primary;
    final bg = isPrimary ? ImportPurchaseTokens.accent : ImportPurchaseTokens.surface;
    final fg = isPrimary ? Colors.white : ImportPurchaseTokens.ink2;
    final border = isPrimary ? ImportPurchaseTokens.accent : ImportPurchaseTokens.line2;

    return Material(
      color: enabled ? bg : bg.withValues(alpha: 0.6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
        child: SizedBox(
          height: 38,
          width: showLabel ? null : 38,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: showLabel ? 16 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: fg,
                    ),
                  )
                else
                  Icon(
                    icon,
                    size: 18,
                    color: enabled ? fg : fg.withValues(alpha: 0.5),
                  ),
                if (showLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: ImportPurchaseHelpers.text(
                      size: 14,
                      weight: FontWeight.w700,
                      color: enabled ? fg : fg.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
