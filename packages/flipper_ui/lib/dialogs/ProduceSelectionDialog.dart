import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;

/// ─────────────────────────────────────────────
/// Fluent Tokens (design system)
/// ─────────────────────────────────────────────

class FluentTheme {
  static const radiusSmall = 6.0;
  static const radiusMedium = 8.0;

  static const animFast = Duration(milliseconds: 140);
  static const animMedium = Duration(milliseconds: 300);

  static const Color accent = Color(0xFF0078D4);
  static const Color accentLight = Color(0xFF60CDFF);

  static const Color surfaceBase = Color(0xFFFAFAFA);
  static const Color surfaceCard = Colors.white;
  static const Color surfaceHover = Color(0xFFF4F4F4);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textTertiary = Color(0xFF9E9E9E);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  static const Color successGreen = Color(0xFF58D68D);
  static const Color warningOrange = Color(0xFFE67E22);
}

/// ─────────────────────────────────────────────
/// Dialog launcher with master-detail pattern
/// ─────────────────────────────────────────────

/// Callback signature for when an item is submitted for production
typedef OnProduceCallback = Future<void> Function(
  models.TransactionItem item,
  Map<String, dynamic> formData,
);

/// Shows the produce selection dialog with master-detail layout.
///
/// The [onProduce] callback is invoked when an item is submitted for production.
/// The [formBuilder] parameter allows injecting a custom form widget for the detail panel.
Future<void> showProduceSelectionDialog({
  required BuildContext context,
  required List<models.TransactionItem> items,
  required OnProduceCallback onProduce,
  required Widget Function({
    String? initialVariantId,
    String? initialVariantName,
    double? initialPlannedQuantity,
    Future<void> Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
  }) formBuilder,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (context) => _ProduceSelectionDialogContent(
      items: items,
      onProduce: onProduce,
      formBuilder: formBuilder,
    ),
  );
}

/// ─────────────────────────────────────────────
/// Dialog Content with Master-Detail Layout
/// ─────────────────────────────────────────────

class _ProduceSelectionDialogContent extends StatefulWidget {
  final List<models.TransactionItem> items;
  final OnProduceCallback onProduce;
  final Widget Function({
    String? initialVariantId,
    String? initialVariantName,
    double? initialPlannedQuantity,
    Future<void> Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
  }) formBuilder;

  const _ProduceSelectionDialogContent({
    required this.items,
    required this.onProduce,
    required this.formBuilder,
  });

  @override
  State<_ProduceSelectionDialogContent> createState() =>
      _ProduceSelectionDialogContentState();
}

class _ProduceSelectionDialogContentState
    extends State<_ProduceSelectionDialogContent> {
  models.TransactionItem? _selectedItem;
  final Set<String> _producedItemIds = {};
  bool _isExpanded = false;

  void _selectItem(models.TransactionItem item) {
    if (_producedItemIds.contains(item.id)) return;

    setState(() {
      _selectedItem = item;
      _isExpanded = true;
    });
  }

  void _collapseDetail() {
    setState(() {
      _selectedItem = null;
      _isExpanded = false;
    });
  }

  Future<void> _handleFormSubmit(Map<String, dynamic> formData) async {
    if (_selectedItem == null) return;

    final item = _selectedItem!;
    await widget.onProduce(item, formData);

    if (!mounted) return;

    setState(() {
      _producedItemIds.add(item.id);
      _selectedItem = null;
      _isExpanded = false;
    });

    // Check if all items are produced
    if (_producedItemIds.length == widget.items.length) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    // Calculate modal dimensions - key change: significantly different widths
    final listOnlyWidth = isMobile ? screenWidth * 0.95 : 450.0;
    final expandedWidth = isMobile ? screenWidth * 0.95 : 950.0;
    final maxHeight = isMobile ? screenHeight * 0.85 : 600.0;

    final currentWidth = _isExpanded ? expandedWidth : listOnlyWidth;

    return Center(
      child: AnimatedContainer(
        duration: FluentTheme.animMedium,
        curve: Curves.easeInOut,
        width: currentWidth,
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          color: FluentTheme.surfaceBase,
          borderRadius: BorderRadius.circular(16),
          elevation: 24,
          shadowColor: Colors.black26,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _Header(onClose: () => Navigator.of(context).pop()),

                // Content
                Flexible(
                  child: _isExpanded && !isMobile
                      ? _buildExpandedLayout()
                      : _buildListOnlyLayout(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOnlyLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Description(),
        _ItemCountBadge(
          totalCount: widget.items.length,
          producedCount: _producedItemIds.length,
        ),
        const SizedBox(height: 8),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
            itemCount: widget.items.length,
            itemBuilder: (_, i) => _ItemTile(
              item: widget.items[i],
              isSelected: _selectedItem?.id == widget.items[i].id,
              isProduced: _producedItemIds.contains(widget.items[i].id),
              onTap: () => _selectItem(widget.items[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Master panel (item list)
        SizedBox(
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Description(),
              _ItemCountBadge(
                totalCount: widget.items.length,
                producedCount: _producedItemIds.length,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
                child: Text(
                  'Items',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: FluentTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                  itemCount: widget.items.length,
                  itemBuilder: (_, i) => _ItemTile(
                    item: widget.items[i],
                    isSelected: _selectedItem?.id == widget.items[i].id,
                    isProduced: _producedItemIds.contains(widget.items[i].id),
                    onTap: () => _selectItem(widget.items[i]),
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Divider
        Container(
          width: 1,
          color: FluentTheme.divider,
        ),

        // Detail panel (form)
        Expanded(
          child: _DetailPanel(
            item: _selectedItem!,
            formBuilder: widget.formBuilder,
            onSubmit: _handleFormSubmit,
            onBack: _collapseDetail,
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────
/// Header
/// ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onClose;

  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
      decoration: BoxDecoration(
        color: FluentTheme.surfaceCard,
        border: Border(
          bottom: BorderSide(color: FluentTheme.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          _FluentIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Select Item to Produce',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: FluentTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            iconSize: 20,
            style: IconButton.styleFrom(
              foregroundColor: FluentTheme.textSecondary,
            ),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _FluentIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [FluentTheme.accent, FluentTheme.accentLight],
        ),
        boxShadow: [
          BoxShadow(
            color: FluentTheme.accent.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.precision_manufacturing_rounded,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// Description + count
/// ─────────────────────────────────────────────

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 12),
      child: Text(
        'Choose an item from the list below to begin production.',
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: FluentTheme.textSecondary,
        ),
      ),
    );
  }
}

class _ItemCountBadge extends StatelessWidget {
  final int totalCount;
  final int producedCount;

  const _ItemCountBadge({
    required this.totalCount,
    required this.producedCount,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = totalCount - producedCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: FluentTheme.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$remaining ${remaining == 1 ? 'item' : 'items'} remaining',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: FluentTheme.accent,
              ),
            ),
          ),
          if (producedCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: FluentTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: FluentTheme.successGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$producedCount assigned',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: FluentTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// Reusable Fluent Card
/// ─────────────────────────────────────────────

class FluentCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;

  const FluentCard({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      mouseCursor:
          isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(FluentTheme.radiusMedium),
        onTap: isDisabled ? null : onTap,
        hoverColor: isDisabled ? null : FluentTheme.surfaceHover,
        child: AnimatedContainer(
          duration: FluentTheme.animFast,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey[100]
                : isSelected
                    ? FluentTheme.accent.withValues(alpha: 0.05)
                    : FluentTheme.surfaceCard,
            borderRadius: BorderRadius.circular(FluentTheme.radiusMedium),
            border: Border.all(
              color: isSelected ? FluentTheme.accent : FluentTheme.divider,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isDisabled
                ? null
                : const [
                    BoxShadow(
                      color: FluentTheme.shadow,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    )
                  ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// Item tile
/// ─────────────────────────────────────────────

class _ItemTile extends StatelessWidget {
  final models.TransactionItem item;
  final bool isSelected;
  final bool isProduced;
  final VoidCallback onTap;
  final bool compact;

  const _ItemTile({
    required this.item,
    required this.isSelected,
    required this.isProduced,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return FluentCard(
      onTap: onTap,
      isSelected: isSelected,
      isDisabled: isProduced,
      child: Row(
        children: [
          _Avatar(item.name, isProduced: isProduced),
          const SizedBox(width: 12),
          Expanded(
            child: _Details(
              item,
              isSelected: isSelected,
              isProduced: isProduced,
              compact: compact,
            ),
          ),
          _StatusIndicator(
            isSelected: isSelected,
            isProduced: isProduced,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final bool isProduced;

  const _Avatar(this.name, {this.isProduced = false});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isProduced
            ? FluentTheme.successGreen.withValues(alpha: 0.1)
            : FluentTheme.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: isProduced
            ? const Icon(
                Icons.check,
                size: 20,
                color: FluentTheme.successGreen,
              )
            : Text(
                initial,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isProduced
                      ? FluentTheme.successGreen
                      : FluentTheme.accent,
                ),
              ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final models.TransactionItem item;
  final bool isSelected;
  final bool isProduced;
  final bool compact;

  const _Details(
    this.item, {
    this.isSelected = false,
    this.isProduced = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w500,
            color:
                isProduced ? FluentTheme.textTertiary : FluentTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 13,
              color: isProduced
                  ? FluentTheme.textTertiary
                  : FluentTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Qty: ${item.qty}',
              style: TextStyle(
                fontSize: 12,
                color: isProduced
                    ? FluentTheme.textTertiary
                    : FluentTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isProduced;

  const _StatusIndicator({
    required this.isSelected,
    required this.isProduced,
  });

  @override
  Widget build(BuildContext context) {
    if (isProduced) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: FluentTheme.successGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Assigned',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: FluentTheme.successGreen,
          ),
        ),
      );
    }

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: FluentTheme.warningOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: FluentTheme.warningOrange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'In Progress',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: FluentTheme.warningOrange,
              ),
            ),
          ],
        ),
      );
    }

    return const Icon(
      Icons.chevron_right_rounded,
      color: FluentTheme.textTertiary,
      size: 20,
    );
  }
}

/// ─────────────────────────────────────────────
/// Detail Panel (Form)
/// ─────────────────────────────────────────────

class _DetailPanel extends StatelessWidget {
  final models.TransactionItem item;
  final Widget Function({
    String? initialVariantId,
    String? initialVariantName,
    double? initialPlannedQuantity,
    Future<void> Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onCancel,
  }) formBuilder;
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onBack;

  const _DetailPanel({
    required this.item,
    required this.formBuilder,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FluentTheme.surfaceCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detail header with back button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: FluentTheme.surfaceBase,
              border: Border(
                bottom: BorderSide(color: FluentTheme.divider, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 20,
                  style: IconButton.styleFrom(
                    backgroundColor: FluentTheme.surfaceCard,
                    foregroundColor: FluentTheme.textSecondary,
                  ),
                  tooltip: 'Back to list',
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Production Details',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: FluentTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: formBuilder(
                initialVariantId: item.variantId,
                initialVariantName: item.name,
                initialPlannedQuantity: item.qty.toDouble(),
                onSubmit: onSubmit,
                onCancel: onBack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
