import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class FileUploadSection extends StatefulWidget {
  final PlatformFile? selectedFile;
  final int? itemCount;
  final Future<void> Function({String? filePath}) onSelectFile;
  final VoidCallback? onClearFile;
  final VoidCallback onDownloadTemplate;

  const FileUploadSection({
    super.key,
    required this.selectedFile,
    this.itemCount,
    required this.onSelectFile,
    this.onClearFile,
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
          widget.selectedFile == null
              ? _buildEmptyDropzone()
              : _buildCompactSelectedRow(),
          const SizedBox(height: 12),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildEmptyDropzone() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 140,
      decoration: BoxDecoration(
        color: _isDragging
            ? Colors.blue.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDragging
              ? Colors.blue
              : Colors.grey.withValues(alpha: 0.3),
          width: 2,
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
                FluentIcons.document_add_24_regular,
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              Text(
                'Drop your Excel file here',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'or click to browse your files',
                style: GoogleFonts.outfit(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactSelectedRow() {
    final count = widget.itemCount;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _isDragging
            ? Colors.blue.withValues(alpha: 0.05)
            : Colors.green.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDragging
              ? Colors.blue
              : Colors.green.withValues(alpha: 0.35),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onSelectFile(),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              const Icon(
                FluentIcons.checkmark_circle_24_regular,
                color: Colors.green,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.selectedFile!.name,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (count != null)
                      Text(
                        '$count products loaded',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => widget.onSelectFile(),
                child: const Text('Change'),
              ),
              if (widget.onClearFile != null)
                TextButton(
                  onPressed: widget.onClearFile,
                  child: const Text('Remove'),
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
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: widget.onDownloadTemplate,
          icon: const Icon(FluentIcons.arrow_download_24_regular, size: 18),
          label: Text(
            'Download Template',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
