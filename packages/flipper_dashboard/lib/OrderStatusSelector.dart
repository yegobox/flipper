import 'package:flipper_dashboard/checkout.dart' show OrderStatus;
import 'package:flutter/material.dart';

class OrderStatusSelector extends StatefulWidget {
  final OrderStatus selectedStatus;
  final Function(OrderStatus) onStatusChanged;

  const OrderStatusSelector({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<OrderStatusSelector> createState() => _OrderStatusSelectorState();
}

class _OrderStatusSelectorState extends State<OrderStatusSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF0078D4).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    _buildStatusButton(
                      OrderStatus.pending,
                      'Pending',
                      Icons.schedule_outlined,
                      const Color(0xFFFF9500),
                      true,
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: const Color(0xFF0078D4).withOpacity(0.1),
                    ),
                    _buildStatusButton(
                      OrderStatus.approved,
                      'Approved',
                      Icons.check_circle_outline,
                      const Color(0xFF34C759),
                      false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(
    OrderStatus status,
    String label,
    IconData icon,
    Color accentColor,
    bool isLeft,
  ) {
    final isSelected = widget.selectedStatus == status;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _animationController.forward().then((_) {
              _animationController.reverse();
            });
            widget.onStatusChanged(status);
          },
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(12) : Radius.zero,
            right: !isLeft ? const Radius.circular(12) : Radius.zero,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.horizontal(
                left: isLeft ? const Radius.circular(12) : Radius.zero,
                right: !isLeft ? const Radius.circular(12) : Radius.zero,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.white : accentColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? accentColor : const Color(0xFF1A1A1A),
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