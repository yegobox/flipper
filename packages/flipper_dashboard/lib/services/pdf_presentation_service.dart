import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:universal_platform/universal_platform.dart';

/// How a PDF should reach the user.
enum PdfPresentationMode {
  /// OS share sheet.
  share,

  /// Save to a location the user picks (desktop) or the documents directory.
  download,

  /// The system print dialog, which on desktop also offers Save as PDF.
  print,

  /// Open in a viewer.
  view,
}

/// Puts a PDF in front of the user, whatever the platform allows.
///
/// Extracted from [TransactionReceiptActionsService] so a sale receipt and a
/// hotel quotation reach the print dialog and the save dialog by exactly the
/// same route. Everything platform-specific lives here — desktop gets a real
/// save dialog, mobile writes to documents and opens a viewer, and every path
/// falls back to the share sheet rather than failing.
///
/// Knows nothing about what the document *is*: callers hand it bytes, a
/// filename, and a [label] for the wording.
class PdfPresentationService {
  /// Guards against a second tap while a PDF is still being produced. Building
  /// one can take seconds, and two taps used to mean two dialogs.
  bool _busy = false;

  @visibleForTesting
  bool get busy => _busy;

  /// Produces the bytes via [build], then presents them.
  ///
  /// [build] runs inside the busy guard and behind the progress indicator, so
  /// a caller that has to fetch or render first does not need its own spinner.
  Future<void> present(
    BuildContext context, {
    required PdfPresentationMode mode,
    required Future<Uint8List> Function() build,
    required String Function() filename,

    /// Sentence-case noun for the snackbars — "Receipt", "Quotation".
    String label = 'Document',
    String progressMessage = 'Preparing document…',
    String? shareSubject,
    String? shareBody,

    /// An already-written copy on disk, reused instead of writing again.
    String? Function()? existingPath,
  }) async {
    if (_busy) return;
    _busy = true;
    // Say something immediately: rendering can take seconds, and a button that
    // does nothing for that long reads as broken.
    showProgress(context, progressMessage);
    try {
      final bytes = await build();
      hideProgress(context);
      if (!context.mounted) return;

      await presentBytes(
        context,
        mode: mode,
        bytes: bytes,
        filename: filename(),
        label: label,
        shareSubject: shareSubject,
        shareBody: shareBody,
        existingPath: existingPath?.call(),
      );
    } catch (e) {
      hideProgress(context);
      if (context.mounted) showSnack(context, friendlyError(e), isError: true);
    } finally {
      _busy = false;
    }
  }

  /// Presents bytes that are already in hand. Throws nothing the caller has to
  /// handle beyond what [present] already catches.
  Future<void> presentBytes(
    BuildContext context, {
    required PdfPresentationMode mode,
    required Uint8List bytes,
    required String filename,
    String label = 'Document',
    String? shareSubject,
    String? shareBody,
    String? existingPath,
  }) async {
    switch (mode) {
      case PdfPresentationMode.share:
        await Printing.sharePdf(
          bytes: bytes,
          filename: filename,
          bounds: shareBounds(context),
          subject: shareSubject,
          body: shareBody,
        );
      case PdfPresentationMode.download:
        await _download(context, bytes, filename, label, existingPath);
      case PdfPresentationMode.print:
        await _print(context, bytes, filename, shareSubject);
      case PdfPresentationMode.view:
        await _view(context, bytes, filename, shareSubject, existingPath);
    }
  }

  Future<void> _download(
    BuildContext context,
    Uint8List bytes,
    String filename,
    String label,
    String? existingPath,
  ) async {
    if (kIsWeb) {
      await Printing.sharePdf(bytes: bytes, filename: filename);
      if (context.mounted) {
        showSnack(context, '$label ready to save or share.');
      }
      return;
    }

    if (UniversalPlatform.isDesktop) {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save ${label.toLowerCase()} PDF',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: bytes,
      );
      if (savedPath == null || savedPath.isEmpty) return;
      final file = File(savedPath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      await OpenFilex.open(savedPath);
      if (context.mounted) {
        showSnack(context, '$label saved to ${_baseName(savedPath)}.');
      }
      return;
    }

    final path = await writeToDocuments(bytes, filename, existingPath);
    final result = await OpenFilex.open(path);
    if (result.type == ResultType.done) {
      if (context.mounted) {
        showSnack(context, '$label saved on this device.');
      }
      return;
    }
    // No PDF viewer installed (or the OS refused the file): hand it to the
    // share sheet so it can still be saved to Files or Drive.
    await Printing.sharePdf(
      bytes: bytes,
      filename: filename,
      bounds: shareBounds(context),
      subject: label,
    );
    if (context.mounted) {
      showSnack(context, '$label ready — choose where to save it.');
    }
  }

  Future<void> _print(
    BuildContext context,
    Uint8List bytes,
    String filename,
    String? subject,
  ) async {
    try {
      await Printing.layoutPdf(name: filename, onLayout: (_) async => bytes);
    } catch (_) {
      if (!context.mounted) return;
      await Printing.sharePdf(
        bytes: bytes,
        filename: filename,
        bounds: shareBounds(context),
        subject: subject,
      );
    }
  }

  Future<void> _view(
    BuildContext context,
    Uint8List bytes,
    String filename,
    String? subject,
    String? existingPath,
  ) async {
    if (kIsWeb || UniversalPlatform.isDesktop) {
      await Printing.layoutPdf(name: filename, onLayout: (_) async => bytes);
      return;
    }

    final path = await writeToDocuments(bytes, filename, existingPath);
    final result = await OpenFilex.open(path);
    if (result.type == ResultType.done) return;

    if (!context.mounted) return;
    try {
      await Printing.layoutPdf(name: filename, onLayout: (_) async => bytes);
    } catch (_) {
      if (!context.mounted) return;
      await Printing.sharePdf(
        bytes: bytes,
        filename: filename,
        bounds: shareBounds(context),
        subject: subject,
      );
    }
  }

  @visibleForTesting
  Future<String> writeToDocuments(
    Uint8List bytes,
    String filename,
    String? existingPath,
  ) async {
    if (existingPath != null &&
        existingPath.isNotEmpty &&
        await File(existingPath).exists()) {
      return existingPath;
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    await File(path).writeAsBytes(bytes, flush: true);
    return path;
  }

  /// iPad shows the share sheet in a popover anchored to these bounds; without
  /// them the sheet can fail to appear.
  Rect? shareBounds(BuildContext context) {
    if (!context.mounted) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    final origin = box.localToGlobal(Offset.zero);
    return Rect.fromLTWH(origin.dx, origin.dy, box.size.width, box.size.height);
  }

  String _baseName(String path) {
    final parts = path.split(Platform.pathSeparator);
    return parts.isEmpty ? path : parts.last;
  }

  String friendlyError(Object error) {
    final text = error.toString();
    final idx = text.indexOf(': ');
    if (idx != -1 && idx < text.length - 2) {
      return text.substring(idx + 2).trim();
    }
    return 'Something went wrong. Please try again.';
  }

  void showProgress(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(minutes: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void hideProgress(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  }

  void showSnack(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: isError ? 4 : 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFB42318) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
