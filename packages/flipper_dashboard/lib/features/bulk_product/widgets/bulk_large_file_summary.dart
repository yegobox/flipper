import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/bulk_add_constants.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';

/// Read-only preview for imports over [kBulkEditableRowLimit] rows.
class BulkLargeFileSummary extends StatelessWidget {
  final BulkAddProductViewModel model;
  final void Function(int index) onDeleteRow;

  const BulkLargeFileSummary({
    super.key,
    required this.model,
    required this.onDeleteRow,
  });

  @override
  Widget build(BuildContext context) {
    final data = model.excelData!;
    final previewCount = data.length.clamp(0, kBulkLargeFilePreviewLimit);
    final validation = model.importValidation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Large import (${data.length} products)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Per-row editing is disabled for large files. Edit the Excel '
                  'file and re-upload to change values. You can still remove '
                  'rows below — removed rows will not be submitted.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                if (validation != null && validation.hasIssues) ...[
                  const SizedBox(height: 12),
                  _ValidationBanner(validation: validation),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Preview (first $previewCount of ${data.length})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: previewCount,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final row = data[index];
                      final name = row['Name']?.toString() ?? '';
                      final barCode = row['BarCode']?.toString() ?? '';
                      final price = row['Price']?.toString() ?? '';
                      return ListTile(
                        dense: true,
                        title: Text(
                          name.isEmpty ? '(no name)' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Barcode: ${barCode.isEmpty ? '—' : barCode} · '
                          'Price: $price',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          tooltip: 'Remove row',
                          icon: const Icon(
                            FluentIcons.delete_24_regular,
                            size: 20,
                          ),
                          onPressed: () => onDeleteRow(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ValidationBanner extends StatelessWidget {
  final BulkImportValidation validation;

  const _ValidationBanner({required this.validation});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (validation.missingNameCount > 0) {
      parts.add('${validation.missingNameCount} row(s) missing a name');
    }
    if (validation.duplicateBarCodeCount > 0) {
      parts.add(
        '${validation.duplicateBarCodeCount} duplicate barcode(s)'
        '${validation.duplicateBarCodes.isNotEmpty ? ': ${validation.duplicateBarCodes.join(', ')}' : ''}',
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              parts.join(' · '),
              style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
