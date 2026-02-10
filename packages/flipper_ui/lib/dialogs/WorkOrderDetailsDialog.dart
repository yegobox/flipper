import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Helper to show work order details dialog
Future<void> showWorkOrderDetailsDialog({
  required BuildContext context,
  required dynamic workOrder,
  VoidCallback? onStart,
  VoidCallback? onRecordOutput,
  VoidCallback? onComplete,
}) {
  return showDialog(
    context: context,
    builder: (context) => WorkOrderDetailsDialog(
      workOrder: workOrder,
      onStart: onStart,
      onRecordOutput: onRecordOutput,
      onComplete: onComplete,
    ),
  );
}

class WorkOrderDetailsDialog extends StatelessWidget {
  const WorkOrderDetailsDialog({
    Key? key,
    required this.workOrder,
    this.onStart,
    this.onRecordOutput,
    this.onComplete,
  }) : super(key: key);

  final dynamic workOrder;
  final VoidCallback? onStart;
  final VoidCallback? onRecordOutput;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final variance = workOrder.variance;
    final varianceColor =
        variance >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final isCompleted = workOrder.status == 'completed';
    final isPlanned = workOrder.status == 'planned';

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF01B8E4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workOrder.variantName ?? 'Unknown Product',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${workOrder.id.substring(0, 8)}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    _buildStatusBadge(workOrder.status),

                    const SizedBox(height: 24),

                    // Metrics Grid
                    _buildMetricsGrid(workOrder, variance, varianceColor),

                    // Notes
                    if (workOrder.notes != null &&
                        workOrder.notes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildNotesSection(workOrder.notes!),
                    ],

                    // Timeline
                    if (workOrder.createdAt != null ||
                        workOrder.startedAt != null ||
                        workOrder.completedAt != null) ...[
                      const SizedBox(height: 24),
                      _buildTimeline(workOrder),
                    ],
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F9),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isCompleted) ...[
                    if (isPlanned && onStart != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onStart?.call();
                        },
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: Text(
                          'Start',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01B8E4),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    if (isPlanned && onStart != null) const SizedBox(width: 12),
                    if (onRecordOutput != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onRecordOutput?.call();
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: Text(
                          'Record Output',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01B8E4),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                  ],
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      side: const BorderSide(color: Color(0xFFE1E2E4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF42474E),
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

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (status) {
      case 'completed':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle;
        statusLabel = 'Completed';
        break;
      case 'in_progress':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.play_circle;
        statusLabel = 'In Progress';
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusIcon = Icons.schedule;
        statusLabel = 'Planned';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
      dynamic workOrder, double variance, Color varianceColor) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          'Planned',
          workOrder.plannedQuantity.toStringAsFixed(0),
          Icons.flag_outlined,
          const Color(0xFF01B8E4),
        ),
        _buildMetricCard(
          'Actual',
          workOrder.actualQuantity.toStringAsFixed(0),
          Icons.inventory_2_outlined,
          varianceColor,
        ),
        _buildMetricCard(
          'Variance',
          '${variance >= 0 ? '+' : ''}${variance.toStringAsFixed(0)}',
          variance >= 0 ? Icons.trending_up : Icons.trending_down,
          varianceColor,
        ),
        _buildMetricCard(
          'Efficiency',
          '${workOrder.efficiency.toStringAsFixed(1)}%',
          Icons.speed,
          workOrder.efficiency >= 100
              ? const Color(0xFF10B981)
              : workOrder.efficiency >= 90
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFFEF4444),
        ),
        _buildMetricCard(
          'Target Date',
          _formatDate(workOrder.targetDate),
          Icons.calendar_today,
          const Color(0xFF6B7280),
        ),
        if (workOrder.shiftId != null)
          _buildMetricCard(
            'Shift',
            workOrder.shiftId ?? 'N/A',
            Icons.access_time,
            const Color(0xFF6B7280),
          ),
      ],
    );
  }

  Widget _buildMetricCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: color),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notes, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                'Notes',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notes,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF42474E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(dynamic workOrder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 12),
        if (workOrder.createdAt != null)
          _buildTimelineItem(
            'Created',
            workOrder.createdAt,
            Icons.add_circle_outline,
            const Color(0xFF01B8E4),
          ),
        if (workOrder.startedAt != null)
          _buildTimelineItem(
            'Started',
            workOrder.startedAt,
            Icons.play_circle_outline,
            const Color(0xFFF59E0B),
          ),
        if (workOrder.completedAt != null)
          _buildTimelineItem(
            'Completed',
            workOrder.completedAt,
            Icons.check_circle_outline,
            const Color(0xFF10B981),
          ),
      ],
    );
  }

  Widget _buildTimelineItem(
      String label, DateTime timestamp, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                Text(
                  _formatDateTime(timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
