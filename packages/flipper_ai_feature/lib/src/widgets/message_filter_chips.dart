import 'package:flutter/material.dart';
import '../theme/ai_theme.dart';

/// Enum for message filter options
enum MessageFilter { all, ai, whatsapp }

/// Filter chips for switching between message sources
class MessageFilterChips extends StatelessWidget {
  final MessageFilter currentFilter;
  final ValueChanged<MessageFilter> onFilterChanged;
  final int? allCount;
  final int? aiCount;
  final int? whatsappCount;

  const MessageFilterChips({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
    this.allCount,
    this.aiCount,
    this.whatsappCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AiTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AiTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            count: allCount,
            filter: MessageFilter.all,
            icon: Icons.chat_bubble_outline_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'AI',
            count: aiCount,
            filter: MessageFilter.ai,
            icon: Icons.smart_toy_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'WhatsApp',
            count: whatsappCount,
            filter: MessageFilter.whatsapp,
            icon: Icons.chat_rounded,
            brandColor: AiTheme.whatsAppGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required MessageFilter filter,
    required IconData icon,
    int? count,
    Color? brandColor,
  }) {
    final isSelected = currentFilter == filter;
    final chipColor = brandColor ?? AiTheme.primaryColor;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? AiTheme.onPrimaryColor
                : (brandColor ?? AiTheme.secondaryColor),
          ),
          const SizedBox(width: 6),
          Text(label),
          if (count != null) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AiTheme.onPrimaryColor.withValues(alpha: 0.2)
                    : AiTheme.secondaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AiTheme.onPrimaryColor
                      : AiTheme.secondaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(filter),
      backgroundColor: AiTheme.inputBackgroundColor,
      selectedColor: chipColor,
      checkmarkColor: AiTheme.onPrimaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AiTheme.onPrimaryColor : AiTheme.textColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? chipColor : AiTheme.borderColor,
          width: 1,
        ),
      ),
    );
  }
}
