import 'package:flutter/material.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/ProgressData.dart';

class BulkActionBar extends ConsumerWidget {
  final BulkAddProductViewModel model;
  final String? errorMessage;
  final VoidCallback onSave;

  const BulkActionBar({
    super.key,
    required this.model,
    this.errorMessage,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEbmEnabled = ref.watch(ebmVatEnabledProvider).value ?? false;
    final displayCount = model.uploadedProductCountForUi ?? model.rowCount;
    final isPrimaryParsing = model.selectedFile != null &&
        model.excelData == null &&
        model.isLoading &&
        !model.isLoadingFullParse;
    final isSecondaryParsing = model.isLoadingFullParse;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (displayCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 12),
                child: Chip(
                  label: Text(
                    '$displayCount product${displayCount == 1 ? '' : 's'}',
                  ),
                ),
              ),
            if (isEbmEnabled)
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Register via server (RRA first)'),
                  subtitle: const Text(
                    'Catalog is created in Ditto only after RRA succeeds. '
                    'Turn off to use the previous on-device flow.',
                  ),
                  value: model.useServerBulkRra,
                  onChanged: model.isSaving ||
                          model.isLoading ||
                          model.isLoadingFullParse
                      ? null
                      : (value) => model.setUseServerBulkRra(value),
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: 12),
            FlipperButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: model.canSave && !isPrimaryParsing && !isSecondaryParsing
                  ? onSave
                  : null,
              text: 'Save All',
            ),
          ],
        ),
        if (isPrimaryParsing || isSecondaryParsing) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
          const SizedBox(height: 4),
          Text(
            isSecondaryParsing
                ? 'Loading all rows from spreadsheet (save disabled until done)…'
                : 'Parsing spreadsheet…',
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
        if (model.isSaving)
          ValueListenableBuilder<ProgressData>(
            valueListenable: model.progressNotifier,
            builder: (context, progress, _) {
              final total = progress.totalItems;
              final current = progress.currentItem;
              final value = total > 0 ? current / total : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: value),
                  const SizedBox(height: 4),
                  if (total > 0)
                    Text(
                      '${ProgressData.formatPercent(current, total)} · $current of $total',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                  Text(
                    progress.progress.isNotEmpty
                        ? progress.progress
                        : 'Saving…',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        if (model.importValidation != null &&
            model.importValidation!.hasIssues) ...[
          const SizedBox(height: 8),
          Text(
            _validationText(model.importValidation!),
            style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
          ),
        ],
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }

  String _validationText(BulkImportValidation v) {
    final parts = <String>[];
    if (v.missingNameCount > 0) {
      parts.add('${v.missingNameCount} row(s) missing name');
    }
    if (v.duplicateBarCodeCount > 0) {
      parts.add('${v.duplicateBarCodeCount} duplicate barcode(s)');
    }
    return parts.join(' · ');
  }
}
