import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/file_upload_section.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/product_data_table.dart';
import 'package:flipper_ui/flipper_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(bulkAddProductViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FileUploadSection(
          selectedFile: model.selectedFile,
          onSelectFile: model.selectFile,
          onDownloadTemplate: model.downloadTemplate,
        ),
        const SizedBox(height: 16),
        if (model.selectedFile != null)
          Align(
            alignment: Alignment.centerRight,
            child: FlipperButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async {
                setState(() {
                  _errorMessage = null;
                });
                try {
                  if (model.excelData != null) {
                    await model.saveAllWithProgress();
                    // Handle completion
                    final combinedNotifier = ref.read(refreshProvider);
                    combinedNotifier.performActions(
                      productName: "",
                      scanMode: true,
                    );
                    // Close the modal after successful save
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    setState(() {
                      _errorMessage = 'No data to save';
                    });
                  }
                } catch (e) {
                  setState(() {
                    _errorMessage = e.toString();
                  });
                }
              },
              text: 'Save All',
            ),
          ),
        const SizedBox(height: 8.0),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 24.0),
        if (model.isLoading) const Center(child: CircularProgressIndicator()),
        if (model.excelData == null &&
            model.selectedFile != null &&
            !model.isLoading)
          const Center(
            child: Text(
              'Parsing Data...',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        if (model.excelData != null) ProductDataTable(model: model),
      ],
    );
  }
}
