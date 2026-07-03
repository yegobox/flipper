import 'dart:async';
import 'dart:io';
import 'package:flipper_dashboard/features/delegations/delegation_helpers.dart';
import 'package:flipper_dashboard/features/delegations/delegation_tokens.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/brick/models/transaction_delegation.model.dart';

Future<String?> _waitForThisDeviceId({
  int maxAttempts = 10,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    final deviceId = ProxyService.box.getThisDeviceId();
    if (deviceId != null) return deviceId;
    await Future.delayed(retryDelay);
  }
  return ProxyService.box.getThisDeviceId();
}

final delegationsProvider = StreamProvider.autoDispose<List<TransactionDelegation>>((
  ref,
) async* {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.warning(
      '[delegation-ui] delegationsProvider: branchId is null — yielding empty',
    );
    yield [];
    return;
  }

  var deviceId = ProxyService.box.getThisDeviceId();
  if (deviceId == null && !Platform.isAndroid && !Platform.isIOS) {
    deviceId = await _waitForThisDeviceId();
    if (deviceId != null) {
      unawaited(ProxyService.cron.setupDelegationMonitoringIfNeeded());
    }
  }
  if (deviceId == null) {
    talker.warning(
      '[delegation-ui] delegationsProvider: thisDeviceId is null after wait '
      '(branchId=$branchId) — yielding empty. Desktop device registration may '
      'not have finished.',
    );
    yield [];
    return;
  }

  talker.info(
    '[delegation-ui] delegationsProvider params: '
    'branchId=$branchId '
    'thisDeviceId(onDeviceId)=$deviceId '
    'selectedDelegationDeviceId(setting)=${ProxyService.box.selectedDelegationDeviceId()} '
    'dittoReady=${ProxyService.ditto.isReady()}',
  );

  yield* ProxyService.getStrategy(
    Strategy.capella,
  ).delegationsStream(branchId: branchId, onDeviceId: deviceId);
});

class DelegationListScreen extends ConsumerStatefulWidget {
  const DelegationListScreen({super.key});

  @override
  ConsumerState<DelegationListScreen> createState() =>
      _DelegationListScreenState();
}

class _DelegationListScreenState extends ConsumerState<DelegationListScreen> {
  String _filterStatus = 'all';
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';

  static const _filters = [
    ('all', 'All'),
    ('failed', 'Failed'),
    ('delegated', 'Delegated'),
    ('completed', 'Completed'),
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _retryDelegation(TransactionDelegation delegation) async {
    try {
      final updatedDelegation = delegation.copyWith(
        status: 'delegated',
        updatedAt: DateTime.now().toUtc(),
      );
      await repository.upsert<TransactionDelegation>(updatedDelegation);

      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Retry queued. If it fails again, re-send the sale from the POS device.',
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(context, 'Error retrying delegation');
      }
    }
  }

  List<TransactionDelegation> _filterBySearch(
    List<TransactionDelegation> delegations,
  ) {
    final query = _searchQuery.trim();
    if (query.isEmpty) return delegations;

    final q = query.toLowerCase();
    return delegations.where((delegation) {
      final haystack = [
        DelegationHelpers.displayName(
          delegation.customerName,
          delegation.transactionId,
        ),
        delegation.receiptType,
        delegation.paymentType,
        DelegationHelpers.statusLabel(delegation.status),
        DelegationHelpers.formatAmount(delegation.subTotal),
        DelegationHelpers.formatWhen(delegation.delegatedAt),
        delegation.transactionId,
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  int _countForFilter(List<TransactionDelegation> bySearch, String filterKey) {
    if (filterKey == 'all') return bySearch.length;
    return bySearch.where((d) => d.status == filterKey).length;
  }

  List<TransactionDelegation> _applyStatusFilter(
    List<TransactionDelegation> bySearch,
  ) {
    if (_filterStatus == 'all') return bySearch;
    return bySearch.where((d) => d.status == _filterStatus).toList();
  }

  void _showAboutDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DelegationTokens.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DelegationTokens.radiusCard),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DelegationTokens.greenTint,
                borderRadius: BorderRadius.circular(
                  DelegationTokens.radiusIcon,
                ),
              ),
              child: const Icon(
                Icons.print_outlined,
                color: DelegationTokens.green,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'About Delegations',
                style: DelegationHelpers.serif(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: DelegationTokens.ink,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Print Delegation allow mobile devices to send print jobs to '
          'desktop printers. Failed delegations can be retried from this screen.',
          style: DelegationHelpers.sans(
            fontSize: 14,
            height: 1.5,
            color: DelegationTokens.text2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: DelegationHelpers.sans(
                fontWeight: FontWeight.w700,
                color: DelegationTokens.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return Scaffold(
        backgroundColor: DelegationTokens.page,
        body: Center(
          child: Text(
            'No branch selected',
            style: DelegationHelpers.sans(color: DelegationTokens.text2),
          ),
        ),
      );
    }

    final delegationsAsync = ref.watch(delegationsProvider);

    return Scaffold(
      backgroundColor: DelegationTokens.page,
      body: delegationsAsync.when(
        data: (delegations) {
          final bySearch = _filterBySearch(delegations);
          final visible = _applyStatusFilter(bySearch)
            ..sort((a, b) => b.delegatedAt.compareTo(a.delegatedAt));

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: DelegationTokens.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(
                        visibleCount: visible.length,
                        onInfoPressed: _showAboutDialog,
                      ),
                      const SizedBox(height: 26),
                      _SearchField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        showClear: _searchQuery.isNotEmpty,
                      ),
                      const SizedBox(height: 20),
                      _FilterRow(
                        filters: _filters,
                        activeFilter: _filterStatus,
                        countFor: (key) => _countForFilter(bySearch, key),
                        onFilterSelected: (key) =>
                            setState(() => _filterStatus = key),
                      ),
                      const SizedBox(height: 22),
                      if (visible.isEmpty)
                        _EmptyState(
                          showDeviceHint:
                              delegations.isEmpty &&
                              _searchQuery.isEmpty &&
                              _filterStatus == 'all',
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: visible.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) => _DelegationCard(
                            delegation: visible[index],
                            onRetry: visible[index].status == 'failed'
                                ? () => _retryDelegation(visible[index])
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: DelegationTokens.green),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: DelegationHelpers.sans(color: DelegationTokens.red),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.visibleCount, required this.onInfoPressed});

  final int visibleCount;
  final VoidCallback onInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Print Delegation',
                style: DelegationHelpers.serif(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.015 * 30,
                  height: 1.08,
                  color: DelegationTokens.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  style: DelegationHelpers.sans(
                    fontSize: 13.5,
                    color: DelegationTokens.text2,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Track and manage transactions delegated across your tills — ',
                    ),
                    TextSpan(
                      text: '$visibleCount',
                      style: DelegationHelpers.sans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: DelegationTokens.ink,
                      ),
                    ),
                    const TextSpan(text: ' in view.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _IconButton(onPressed: onInfoPressed),
      ],
    );
  }
}

class _IconButton extends StatefulWidget {
  const _IconButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: _hovering
            ? DelegationTokens.iconBtnHoverBg
            : DelegationTokens.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DelegationTokens.radiusIconBtn),
          side: BorderSide(
            color: _hovering
                ? DelegationTokens.hoverBorder
                : DelegationTokens.border,
          ),
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(DelegationTokens.radiusIconBtn),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.info_outline_rounded,
              size: 19,
              color: _hovering
                  ? DelegationTokens.green
                  : DelegationTokens.text2,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.showClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    final focused = focusNode.hasFocus;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DelegationTokens.radiusInput),
        boxShadow: focused
            ? const [
                BoxShadow(color: DelegationTokens.focusRing, spreadRadius: 3),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: DelegationHelpers.sans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: DelegationTokens.ink,
        ),
        decoration: InputDecoration(
          hintText: 'Search delegations, receipt, payment…',
          hintStyle: DelegationHelpers.sans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: DelegationTokens.muted,
          ),
          filled: true,
          fillColor: focused ? DelegationTokens.card : DelegationTokens.tint,
          contentPadding: const EdgeInsets.fromLTRB(48, 16, 18, 16),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 19,
            color: DelegationTokens.green,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          suffixIcon: showClear
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: DelegationTokens.muted,
                  onPressed: onClear,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DelegationTokens.radiusInput),
            borderSide: const BorderSide(color: DelegationTokens.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DelegationTokens.radiusInput),
            borderSide: const BorderSide(color: DelegationTokens.green),
          ),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.activeFilter,
    required this.countFor,
    required this.onFilterSelected,
  });

  final List<(String, String)> filters;
  final String activeFilter;
  final int Function(String key) countFor;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.filter_list_rounded,
              size: 17,
              color: DelegationTokens.text2,
            ),
            const SizedBox(width: 8),
            Text(
              'Filter',
              style: DelegationHelpers.sans(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: DelegationTokens.text2,
              ),
            ),
            const SizedBox(width: 2),
          ],
        ),
        for (final (key, label) in filters)
          _FilterChip(
            label: label,
            count: countFor(key),
            isActive: activeFilter == key,
            onTap: () => onFilterSelected(key),
          ),
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: active ? DelegationTokens.green : DelegationTokens.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DelegationTokens.radiusChip),
          side: BorderSide(
            color: active
                ? DelegationTokens.green
                : (_hovering
                      ? DelegationTokens.hoverBorder
                      : DelegationTokens.border),
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(DelegationTokens.radiusChip),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: DelegationHelpers.sans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : DelegationTokens.text2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0x38FFFFFF)
                        : DelegationTokens.hairline,
                    borderRadius: BorderRadius.circular(
                      DelegationTokens.radiusBadge,
                    ),
                  ),
                  child: Text(
                    '${widget.count}',
                    textAlign: TextAlign.center,
                    style: DelegationHelpers.sans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : DelegationTokens.text2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DelegationCard extends StatefulWidget {
  const _DelegationCard({required this.delegation, this.onRetry});

  final TransactionDelegation delegation;
  final VoidCallback? onRetry;

  @override
  State<_DelegationCard> createState() => _DelegationCardState();
}

class _DelegationCardState extends State<_DelegationCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final delegation = widget.delegation;
    final status = delegation.status;
    final name = DelegationHelpers.displayName(
      delegation.customerName,
      delegation.transactionId,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovering ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: DelegationTokens.card,
          borderRadius: BorderRadius.circular(DelegationTokens.radiusCard),
          border: Border.all(color: DelegationTokens.hairline),
          boxShadow: _hovering
              ? DelegationTokens.shadowHover
              : DelegationTokens.shadowCard,
        ),
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: DelegationTokens.statusIconBg(status),
                    borderRadius: BorderRadius.circular(
                      DelegationTokens.radiusIcon,
                    ),
                  ),
                  child: Icon(
                    DelegationHelpers.statusIcon(status),
                    size: 22,
                    color: DelegationTokens.statusIconColor(status),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: DelegationHelpers.sans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: DelegationTokens.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: DelegationTokens.text2,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DelegationHelpers.formatWhen(
                              delegation.delegatedAt,
                            ),
                            style: DelegationHelpers.sans(
                              fontSize: 13,
                              color: DelegationTokens.text2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DelegationTokens.statusBadgeBg(status),
                    borderRadius: BorderRadius.circular(
                      DelegationTokens.radiusBadge,
                    ),
                  ),
                  child: Text(
                    DelegationHelpers.statusLabel(status).toUpperCase(),
                    style: DelegationHelpers.sans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.09 * 11,
                      color: DelegationTokens.statusBadgeText(status),
                    ),
                  ),
                ),
                if (widget.onRetry != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    color: DelegationTokens.green,
                    tooltip: 'Retry delegation',
                    onPressed: widget.onRetry,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: DelegationTokens.tint,
                borderRadius: BorderRadius.circular(
                  DelegationTokens.radiusPanel,
                ),
                border: Border.all(color: DelegationTokens.hairline),
              ),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final twoColumn = constraints.maxWidth >= 420;
                      final receipt = _DetailRow(
                        icon: Icons.receipt_long_outlined,
                        label: 'Receipt Type',
                        value: delegation.receiptType,
                      );
                      final payment = _DetailRow(
                        icon: Icons.credit_card_outlined,
                        label: 'Payment',
                        value: delegation.paymentType,
                      );

                      if (twoColumn) {
                        return Row(
                          children: [
                            Expanded(child: receipt),
                            const SizedBox(width: 24),
                            Expanded(child: payment),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          receipt,
                          const SizedBox(height: 12),
                          payment,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: DelegationTokens.hairline),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 12),
                    child: _DetailRow(
                      icon: Icons.payments_outlined,
                      label: 'Amount',
                      value: DelegationHelpers.formatAmount(
                        delegation.subTotal,
                      ),
                      iconColor: DelegationTokens.green,
                      valueStyle: DelegationHelpers.serif(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.01 * 19,
                        color: DelegationTokens.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.valueStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: iconColor ?? DelegationTokens.muted),
        const SizedBox(width: 9),
        Text(
          label,
          style: DelegationHelpers.sans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: DelegationTokens.text2,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style:
              valueStyle ??
              DelegationHelpers.sans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: DelegationTokens.ink,
              ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.showDeviceHint});

  final bool showDeviceHint;

  @override
  Widget build(BuildContext context) {
    final thisDeviceId = ProxyService.box.getThisDeviceId();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      decoration: BoxDecoration(
        color: DelegationTokens.card,
        borderRadius: BorderRadius.circular(DelegationTokens.radiusCard),
        border: Border.all(color: DelegationTokens.hairline),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0x1A12B76A),
              borderRadius: BorderRadius.circular(
                DelegationTokens.radiusEmptyIcon,
              ),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 26,
              color: DelegationTokens.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No delegations found',
            style: DelegationHelpers.serif(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: DelegationTokens.ink,
            ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Text(
              showDeviceHint
                  ? 'Delegations sent to this device will appear here. '
                        'Senders must target this device ID in delegation settings.'
                  : 'Try a different search term or switch the filter above to see more results.',
              textAlign: TextAlign.center,
              style: DelegationHelpers.sans(
                fontSize: 13.5,
                color: DelegationTokens.text2,
              ),
            ),
          ),
          if (showDeviceHint && thisDeviceId != null) ...[
            const SizedBox(height: 16),
            SelectableText(
              thisDeviceId,
              textAlign: TextAlign.center,
              style: DelegationHelpers.mono(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: DelegationTokens.ink,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
