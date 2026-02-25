import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class FileUploadSection extends StatefulWidget {
  final PlatformFile? selectedFile;
  final Future<void> Function({String? filePath}) onSelectFile;
  final VoidCallback onDownloadTemplate;

  const FileUploadSection({
    super.key,
    required this.selectedFile,
    required this.onSelectFile,
    required this.onDownloadTemplate,
  });

  @override
  State<FileUploadSection> createState() => _FileUploadSectionState();
}

class _FileUploadSectionState extends State<FileUploadSection> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        if (detail.files.isNotEmpty) {
          widget.onSelectFile(filePath: detail.files.first.path);
        }
      },
      onDragEntered: (detail) => setState(() => _isDragging = true),
      onDragExited: (detail) => setState(() => _isDragging = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDropzone(),
          const SizedBox(height: 16),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildDropzone() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 200,
      decoration: BoxDecoration(
        color: _isDragging
            ? Colors.blue.withOpacity(0.05)
            : widget.selectedFile != null
            ? Colors.green.withOpacity(0.02)
            : Colors.grey.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDragging
              ? Colors.blue
              : widget.selectedFile != null
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onSelectFile(),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.selectedFile != null
                    ? FluentIcons.checkmark_circle_24_regular
                    : FluentIcons.document_add_24_regular,
                size: 48,
                color: widget.selectedFile != null ? Colors.green : Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                widget.selectedFile == null
                    ? 'Drop your Excel file here'
                    : widget.selectedFile!.name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.selectedFile == null
                    ? 'or click to browse your files'
                    : 'File selected successfully',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        const Icon(FluentIcons.info_24_regular, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          'Supported: .xlsx, .xls',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: widget.onDownloadTemplate,
          icon: const Icon(FluentIcons.arrow_download_24_regular, size: 18),
          label: Text(
            'Download Template',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
