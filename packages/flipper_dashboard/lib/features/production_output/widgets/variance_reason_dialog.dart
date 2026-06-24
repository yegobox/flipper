import 'package:flutter/material.dart';
import '../models/production_output_models.dart';

/// SAP Fiori-inspired Value Help Dialog for variance reasons
///
/// A dialog to select or input variance reasons following
/// SAP standard categories (machine, material, labor, quality).
class VarianceReasonDialog extends StatefulWidget {
  final Function(String reason, String? notes)? onSubmit;
  final VoidCallback? onCancel;
  final String? initialReason;
  final String? initialNotes;

  const VarianceReasonDialog({
    Key? key,
    this.onSubmit,
    this.onCancel,
    this.initialReason,
    this.initialNotes,
  }) : super(key: key);

  static Future<Map<String, String>?> show(BuildContext context) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: 400,
          child: VarianceReasonDialog(
            onSubmit: (reason, notes) {
              Navigator.of(
                context,
              ).pop({'reason': reason, 'notes': notes ?? ''});
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  @override
  State<VarianceReasonDialog> createState() => _VarianceReasonDialogState();
}

class _VarianceReasonDialogState extends State<VarianceReasonDialog> {
  String? _selectedReason;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedReason = widget.initialReason;
    _notesController.text = widget.initialNotes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Color(VarianceColors.warning),
              ),
              const SizedBox(width: 8),
              Text(
                'Variance Reason',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (widget.onCancel != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancel,
                  iconSize: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Select the primary reason for production variance',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          // Reason categories
          ...VarianceReasonCategory.values.map((reason) {
            final isSelected =
                _selectedReason?.toLowerCase() == reason.name.toLowerCase();
            return _ReasonTile(
              reason: reason,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedReason = reason.name;
                });
              },
            );
          }),
          const SizedBox(height: 16),
          // Notes field
          TextFormField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Additional Notes',
              hintText: 'Provide details about the variance...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 24),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _selectedReason != null
                    ? () {
                        widget.onSubmit?.call(
                          _selectedReason!,
                          _notesController.text.isNotEmpty
                              ? _notesController.text
                              : null,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(VarianceColors.neutral),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual reason tile
class _ReasonTile extends StatelessWidget {
  final VarianceReasonCategory reason;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ReasonTile({
    Key? key,
    required this.reason,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getReasonColor(reason);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getReasonIcon(reason), color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reason.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      reason.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Color _getReasonColor(VarianceReasonCategory reason) {
    switch (reason) {
      case VarianceReasonCategory.machine:
        return Colors.orange;
      case VarianceReasonCategory.material:
        return Colors.blue;
      case VarianceReasonCategory.labor:
        return Colors.purple;
      case VarianceReasonCategory.quality:
        return Colors.red;
      case VarianceReasonCategory.planning:
        return Colors.teal;
      case VarianceReasonCategory.other:
        return Colors.grey;
    }
  }

  IconData _getReasonIcon(VarianceReasonCategory reason) {
    switch (reason) {
      case VarianceReasonCategory.machine:
        return Icons.precision_manufacturing;
      case VarianceReasonCategory.material:
        return Icons.inventory_2;
      case VarianceReasonCategory.labor:
        return Icons.people;
      case VarianceReasonCategory.quality:
        return Icons.verified;
      case VarianceReasonCategory.planning:
        return Icons.event_note;
      case VarianceReasonCategory.other:
        return Icons.help_outline;
    }
  }
}
