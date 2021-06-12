import 'dart:io';

import 'package:flipper/routes.logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:path/path.dart' as path;

class PdfApi {
  final log = getLogger("PDFAPI");
  Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    bool dirExists = await Directory(dir.path + '/flipperInvoices').exists();
    if (!dirExists) {
      new Directory(dir.path + '/flipperInvoices').create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        log.i(directory.path);
      });
    }
    String normaliedPath = path.normalize('${dir.path}/flipperInvoices/$name');

    final file = File(normaliedPath);

    await file.writeAsBytes(bytes);

    return file;
  }

  Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
