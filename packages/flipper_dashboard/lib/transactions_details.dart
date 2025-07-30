import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'widgets/transaction_status_widget.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulHookConsumerWidget {
  const TransactionDetail({Key? key, required this.transaction})
      : super(key: key);

  final ITransaction transaction;

  @override
  ConsumerState<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends ConsumerState<TransactionDetail>
    with TickerProviderStateMixin {
  bool _transactionItemListIsExpanded = false;
  bool _transactionStatusWidgetIsExpanded = false;
  bool _moreActionsIsPressed = false;

  late AnimationController _heroAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _heroAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroAnimation = CurvedAnimation(
      parent: _heroAnimationController,
      curve: Curves.elasticOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _heroAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {
        final activeBranch = await ProxyService.strategy.activeBranch();
        List<TransactionItem> items =
            await ProxyService.strategy.transactionItems(
          branchId: activeBranch.id,
          transactionId: widget.transaction.id,
          fetchRemote: true,
        );
        model.completedTransactionItemsList = items;
      },
      builder: (context, model, child) {
        final transactionType = widget.transaction.transactionType == 'Cash Out'
            ? 'Expense'
            : 'Income';

        return Scaffold(
          backgroundColor:
              const Color(0xFFF8F9FA), // Microsoft-inspired light background
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with Fluent Design
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          transactionType == 'Income'
                              ? const Color(0xFF16C784)
                              : const Color(0xFFEA3943),
                          transactionType == 'Income'
                              ? const Color(0xFF0FAE6E)
                              : const Color(0xFFD63384),
                        ],
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                  onPressed: () => locator<RouterService>().back(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.more_vert,
                          color: Colors.white, size: 18),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                ],
                title: Text(
                  transactionType,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Hero Amount Card with Duolingo-inspired celebration
                    AnimatedBuilder(
                      animation: _heroAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _heroAnimation.value,
                          child: _HeroAmountCard(
                            transaction: widget.transaction,
                            transactionType: transactionType,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Animated Cards
                    SlideTransition(
                      position: _slideAnimation,
                      child: AnimatedBuilder(
                        animation: _cardAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _cardAnimationController.value,
                            child: Column(
                              children: [
                                if (model
                                    .completedTransactionItemsList.isNotEmpty)
                                  _ModernTransactionItemList(
                                    items: model.completedTransactionItemsList,
                                    onExpansionChanged: (expanded) {
                                      setState(() {
                                        _transactionItemListIsExpanded =
                                            expanded;
                                      });
                                    },
                                    isExpanded: _transactionItemListIsExpanded,
                                  ),
                                const SizedBox(height: 16),
                                if (model
                                    .completedTransactionItemsList.isNotEmpty)
                                  _ModernTransactionTimeline(
                                    transaction: widget.transaction,
                                    onExpansionChanged: (expanded) {
                                      setState(() {
                                        _transactionStatusWidgetIsExpanded =
                                            expanded;
                                      });
                                    },
                                    isExpanded:
                                        _transactionStatusWidgetIsExpanded,
                                  ),
                                const SizedBox(height: 24),
                                if (model
                                    .completedTransactionItemsList.isNotEmpty)
                                  _FluentActionButtons(
                                    transaction: widget.transaction,
                                    moreActionsIsPressed: _moreActionsIsPressed,
                                    onMoreActionsPressedChanged: (pressed) {
                                      setState(() {
                                        _moreActionsIsPressed = pressed;
                                      });
                                    },
                                  ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Hero Amount Card with Microsoft Fluent Design principles
class _HeroAmountCard extends StatelessWidget {
  const _HeroAmountCard({
    required this.transaction,
    required this.transactionType,
  });

  final ITransaction transaction;
  final String transactionType;

  @override
  Widget build(BuildContext context) {
    final status = transaction.status?.toUpperCase() ?? 'N/A';
    final isIncome = transactionType == 'Income';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(status).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(status),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Amount with Currency
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ProxyService.box.defaultCurrency(),
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      NumberFormat('#,###').format(transaction.subTotal),
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                        height: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Transaction Type Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? const Color(0xFF16C784).withOpacity(0.1)
                        : const Color(0xFFEA3943).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isIncome ? Icons.trending_up : Icons.trending_down,
                    color: isIncome
                        ? const Color(0xFF16C784)
                        : const Color(0xFFEA3943),
                    size: 24,
                  ),
                ),

                const SizedBox(height: 20),

                // Date Information
                Column(
                  children: [
                    Text(
                      'Created ${DateFormat('MMM dd, yyyy').format(transaction.createdAt!)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(transaction.createdAt!),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFFF9500);
      case "parked":
        return const Color(0xFF007AFF);
      case "completed":
        return const Color(0xFF16C784);
      default:
        return Colors.grey;
    }
  }
}

// Modern Transaction Item List with QuickBooks-inspired layout
class _ModernTransactionItemList extends StatelessWidget {
  const _ModernTransactionItemList({
    required this.items,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  final List<TransactionItem> items;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    double total =
        items.fold(0.0, (sum, item) => sum + (item.price * item.qty));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => onExpansionChanged(!isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF007AFF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '${items.length} items',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, color: Color(0xFFE5E5E7)),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: Color(0xFFE5E5E7),
                          indent: 20,
                          endIndent: 20,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.qty.toInt().toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      Text(
                                        '${ProxyService.box.defaultCurrency()}${item.price.toStringAsFixed(2)} each',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  (item.qty * item.price).toCurrencyFormatted(
                                    symbol: ProxyService.box.defaultCurrency(),
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Total Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              total.toCurrencyFormatted(
                                symbol: ProxyService.box.defaultCurrency(),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// Modern Timeline with Fluent Design
class _ModernTransactionTimeline extends StatelessWidget {
  const _ModernTransactionTimeline({
    required this.transaction,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  final ITransaction transaction;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    List<TransactionStatus> statuses = _getTransactionStatuses(transaction);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => onExpansionChanged(!isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16C784).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.timeline,
                      color: Color(0xFF16C784),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Timeline',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '${statuses.length} events',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: TransactionStatusWidget(statuses: statuses),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  List<TransactionStatus> _getTransactionStatuses(ITransaction transaction) {
    List<TransactionStatus> statuses = [];
    if (transaction.createdAt != null) {
      statuses.add(TransactionStatus(
        status: PENDING.toUpperCase(),
        dateTime: transaction.createdAt!,
      ));
    }

    String currentStatus = transaction.status ?? '';
    if (currentStatus != PENDING && transaction.updatedAt != null) {
      statuses.add(TransactionStatus(
        status:
            "${currentStatus.toUpperCase()}${transaction.paymentType != null ? ': ${transaction.paymentType!.toUpperCase()}' : ''}",
        dateTime: transaction.updatedAt!,
      ));
    }
    return statuses;
  }
}

// Fluent Design Action Buttons
class _FluentActionButtons extends StatelessWidget {
  const _FluentActionButtons({
    required this.transaction,
    required this.moreActionsIsPressed,
    required this.onMoreActionsPressedChanged,
  });

  final ITransaction transaction;
  final bool moreActionsIsPressed;
  final ValueChanged<bool> onMoreActionsPressedChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: !moreActionsIsPressed
            ? _PrimaryActions(
                key: const ValueKey('primary'),
                onMorePressed: () => onMoreActionsPressedChanged(true),
                transaction: transaction,
              )
            : _SecondaryActions(
                key: const ValueKey('secondary'),
                onBackPressed: () => onMoreActionsPressedChanged(false),
                transaction: transaction,
              ),
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({
    super.key,
    required this.onMorePressed,
    required this.transaction,
  });

  final VoidCallback onMorePressed;
  final ITransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FluentButton(
            icon: Icons.more_horiz,
            label: 'More Actions',
            onPressed: onMorePressed,
            variant: FluentButtonVariant.secondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FluentButton(
            icon: Icons.receipt_long,
            label: 'Invoice',
            onPressed: () => locator<RouterService>().navigateTo(
              PaymentConfirmationRoute(transaction: transaction),
            ),
            variant: FluentButtonVariant.primary,
          ),
        ),
      ],
    );
  }
}

class _SecondaryActions extends StatelessWidget {
  const _SecondaryActions({
    super.key,
    required this.onBackPressed,
    required this.transaction,
  });

  final VoidCallback onBackPressed;
  final ITransaction transaction;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.edit_note,
        label: 'Edit Note',
        color: const Color(0xFF007AFF),
        onTap: () => _showSnackbar(context, 'Edit Note tapped!'),
      ),
      _ActionItem(
        icon: Icons.check_circle_outline,
        label: 'Approve Transaction',
        color: const Color(0xFF16C784),
        onTap: () => _showSnackbar(context, 'Transaction approved!'),
      ),
      _ActionItem(
        icon: Icons.share_outlined,
        label: 'Share',
        color: const Color(0xFF007AFF),
        onTap: () => _showSnackbar(context, 'Share tapped!'),
      ),
      _ActionItem(
        icon: Icons.print_outlined,
        label: 'Print Receipt',
        color: const Color(0xFF5856D6),
        onTap: () => _showSnackbar(context, 'Print Receipt tapped!'),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ...actions.map((action) => _ActionTile(action: action)).toList(),
          const Divider(height: 1),
          _ActionTile(
            action: _ActionItem(
              icon: Icons.arrow_back,
              label: 'Back to Primary Actions',
              color: Colors.grey.shade600,
              onTap: onBackPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});

  final _ActionItem action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  action.label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum FluentButtonVariant { primary, secondary }

class _FluentButton extends StatelessWidget {
  const _FluentButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.variant,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final FluentButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: variant == FluentButtonVariant.primary
            ? const Color(0xFF66AAFF)
            : Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
