import 'dart:io';
import 'package:path/path.dart' as p;

extension DirectoryUtils on Directory {
  Directory subDirectory(String path) => Directory(p.join(this.path, path));
}

Future<void> createAllDirectories(List<Directory> directories) =>
    Future.wait(directories.map((it) => it.create(recursive: true)));
