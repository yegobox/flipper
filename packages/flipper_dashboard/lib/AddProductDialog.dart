import 'package:flutter/material.dart';

/// Design palette aligned with the Add Product modal spec.
class _AddProductPalette {
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueBg = Color(0xFFEFF6FF);
  static const Color blueBadgeBg = Color(0xFFDBEAFE);
  static const Color blueIconSquare = Color(0xFFDBEAFE);

  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleBg = Color(0xFFF5F3FF);
  static const Color purpleBadgeBg = Color(0xFFEDE9FE);
  static const Color purpleIconSquare = Color(0xFFEDE9FE);

  static const Color teal = Color(0xFF10B981);
  static const Color tealBg = Color(0xFFECFDF5);
  static const Color tealBadgeBg = Color(0xFFD1FAE5);
  static const Color tealIconSquare = Color(0xFFD1FAE5);

  static const Color title = Color(0xFF0F172A);
  static const Color subtitle = Color(0xFF64748B);
  static const Color handle = Color(0xFFE2E8F0);
  static const Color chevron = Color(0xFF94A3B8);
}

class AddProductDialog extends StatelessWidget {
  final Function(String) onChoiceSelected;

  const AddProductDialog({
    super.key,
    required this.onChoiceSelected,
  });

  static const double _modalRadius = 32;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Material(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_modalRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDragHandle(),
                const SizedBox(height: 8),
                _buildHeader(context),
                const SizedBox(height: 22),
                _buildThemedOption(
                  context: context,
                  background: _AddProductPalette.blueBg,
                  border: _AddProductPalette.blue,
                  title: 'Single Product',
                  subtitle: 'Add and configure one item',
                  badgeLabel: 'QUICK',
                  badgeForeground: _AddProductPalette.blue,
                  badgeBackground: _AddProductPalette.blueBadgeBg,
                  leading: _singleProductLeading(),
                  onTap: () => _handleSelection(context, 'single'),
                ),
                const SizedBox(height: 14),
                _buildThemedOption(
                  context: context,
                  background: _AddProductPalette.purpleBg,
                  border: _AddProductPalette.purple,
                  title: 'Bulk Add',
                  subtitle: 'Import multiple products at once',
                  badgeLabel: 'FAST',
                  badgeForeground: _AddProductPalette.purple,
                  badgeBackground: _AddProductPalette.purpleBadgeBg,
                  leading: _bulkAddLeading(),
                  onTap: () => _handleSelection(context, 'bulk'),
                ),
                const SizedBox(height: 14),
                _buildThemedOption(
                  context: context,
                  background: _AddProductPalette.tealBg,
                  border: _AddProductPalette.teal,
                  title: 'Add Rooms',
                  subtitle: 'Hotel & accommodation',
                  badgeLabel: 'HOTEL',
                  badgeForeground: _AddProductPalette.teal,
                  badgeBackground: _AddProductPalette.tealBadgeBg,
                  leading: _roomsLeading(),
                  onTap: () => _handleSelection(context, 'rooms'),
                ),
                const SizedBox(height: 20),
                _buildCancelButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: _AddProductPalette.handle,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _AddProductPalette.blueIconSquare,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.work_outline_rounded,
            color: _AddProductPalette.blue,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Product',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _AddProductPalette.title,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose how you\'d like to add',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _AddProductPalette.subtitle,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _singleProductLeading() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _AddProductPalette.blueIconSquare,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: _AddProductPalette.blueBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_rounded,
            color: _AddProductPalette.blue,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _bulkAddLeading() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _AddProductPalette.purpleIconSquare,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.grid_view_rounded,
            color: _AddProductPalette.purple,
            size: 26,
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: _AddProductPalette.purpleBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: _AddProductPalette.purple,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomsLeading() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _AddProductPalette.tealIconSquare,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.home_rounded,
        color: _AddProductPalette.teal,
        size: 28,
      ),
    );
  }

  Widget _buildThemedOption({
    required BuildContext context,
    required Color background,
    required Color border,
    required String title,
    required String subtitle,
    required String badgeLabel,
    required Color badgeForeground,
    required Color badgeBackground,
    required Widget leading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _AddProductPalette.title,
                              letterSpacing: -0.2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _AddProductPalette.subtitle,
                              height: 1.35,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      color: badgeForeground,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: _AddProductPalette.chevron,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: _AddProductPalette.subtitle,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Cancel',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: _AddProductPalette.subtitle,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  void _handleSelection(BuildContext context, String choice) {
    Navigator.of(context).pop();
    onChoiceSelected(choice);
  }
}
