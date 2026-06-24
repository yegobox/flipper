import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onClose;
  final bool isSaving;

  const ActionButtons({
    Key? key,
    required this.onSave,
    required this.onClose,
    this.isSaving = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 520;

    final closeButton = OutlinedButton(
      onPressed: isSaving ? null : onClose,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Close'),
    );

    final saveButton = ElevatedButton(
      onPressed: isSaving ? null : onSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF006AF6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBackgroundColor: const Color(
          0xFF006AF6,
        ).withValues(alpha: 0.6),
      ),
      child: isSaving
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('Save', style: TextStyle(color: Colors.white)),
    );

    return Column(
      children: [
        const SizedBox(height: 24),
        if (isNarrow)
          Column(
            children: [
              SizedBox(width: double.infinity, child: saveButton),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: closeButton),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: closeButton),
              const SizedBox(width: 16),
              Expanded(child: saveButton),
            ],
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
