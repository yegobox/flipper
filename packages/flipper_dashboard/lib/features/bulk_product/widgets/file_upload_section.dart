import 'package:flutter/material.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadSection extends StatelessWidget {
  final PlatformFile? selectedFile;
  final Future<void> Function() onSelectFile;

  const FileUploadSection({
    super.key,
    required this.selectedFile,
    required this.onSelectFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlipperButton(
          textColor: Colors.black,
          onPressed: onSelectFile,
          text: selectedFile == null
              ? 'Choose Excel File'
              : 'Change Excel File',
        ),
        if (selectedFile != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Selected File: ${selectedFile!.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}
