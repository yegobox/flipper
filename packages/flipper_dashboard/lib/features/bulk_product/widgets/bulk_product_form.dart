import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/file_upload_section.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/product_data_table.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/bulk_action_bar.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/bulk_save_overlay.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/bulk_save_result_sheet.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/bulk_large_file_summary.dart';

class BulkProductForm extends ConsumerStatefulWidget {
  const BulkProductForm({super.key});

  @override
  BulkProductFormState createState() => BulkProductFormState();
}

class BulkProductFormState extends ConsumerState<BulkProductForm> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bulkAddProductViewModelProvider).initializeControllers();
    });
  }

  Future<void> _handleSave(BulkAddProductViewModel model) async {
    setState(() {
      _errorMessage = null;
    });
    try {
      if (model.excelData == null || model.excelData!.isEmpty) {
        setState(() {
          _errorMessage = 'No data to save';
        });
        return;
      }
      final result = await model.saveAllWithProgress();
      if (!mounted) return;

      final shouldClose = await showBulkSaveResultSheet(
        context: context,
        result: result,
      );

      if (!mounted) return;
      if (shouldClose == true && result.success) {
        ref.read(refreshProvider).performActions(
          productName: '',
          scanMode: true,
        );
        Navigator.of(context).pop();
      } else if (!result.success) {
        setState(() {
          _errorMessage = result.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(bulkAddProductViewModelProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FileUploadSection(
                selectedFile: model.selectedFile,
                itemCount: model.excelData?.length,
                onSelectFile: model.selectFile,
                onClearFile: model.clearSelectedFile,
                onDownloadTemplate: model.downloadTemplate,
              ),
              const SizedBox(height: 12),
              BulkActionBar(
                model: model,
                errorMessage: _errorMessage,
                onSave: () => _handleSave(model),
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(model)),
            ],
          ),
        ),
        if (model.isSaving) BulkSaveOverlay(model: model),
      ],
    );
  }

  Widget _buildBody(BulkAddProductViewModel model) {
    if (model.isLoading &&
        model.selectedFile != null &&
        model.excelData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (model.excelData == null) {
      return Center(
        child: Text(
          model.selectedFile != null
              ? 'Parsing spreadsheet…'
              : 'Upload an Excel file to preview products',
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
        ),
      );
    }

    if (model.excelData!.isEmpty) {
      return const Center(
        child: Text(
          'No rows in file — upload another spreadsheet or add rows in Excel.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      );
    }

    if (model.exceedsEditableLimit) {
      return BulkLargeFileSummary(
        model: model,
        onDeleteRow: (index) => model.removeRowAt(index),
      );
    }

    return ProductDataTable(key: ValueKey(model.rowCount), model: model);
  }
}
