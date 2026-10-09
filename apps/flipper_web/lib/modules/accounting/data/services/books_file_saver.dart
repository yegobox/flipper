import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hands a generated Books export to the user: a browser download on web, a
/// save dialog on desktop and mobile.
abstract class BooksFileSaver {
  /// Returns false when the user cancelled the save dialog.
  Future<bool> save(Uint8List bytes, String fileName, String ext);
}

class FilePickerBooksFileSaver implements BooksFileSaver {
  const FilePickerBooksFileSaver();

  @override
  Future<bool> save(Uint8List bytes, String fileName, String ext) async {
    final path = await FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: [ext],
    );
    // On web the browser owns the download and the path is always null.
    return kIsWeb || path != null;
  }
}

final booksFileSaverProvider = Provider<BooksFileSaver>(
  (ref) => const FilePickerBooksFileSaver(),
);
