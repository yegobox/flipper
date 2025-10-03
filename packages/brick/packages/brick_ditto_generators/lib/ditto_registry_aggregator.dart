import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// Generates a file that imports all Ditto-enabled models to ensure their
/// static adapter registration code runs.
Builder dittoRegistryAggregatorBuilder(BuilderOptions options) =>
    _DittoRegistryAggregatorBuilder();

class _DittoRegistryAggregatorBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': ['sync/ditto_models_loader.g.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final modelFiles = <String>[];
    final classNames = <String, String>{}; // path -> class name mapping

    // Find all files with DittoAdapter annotation
    await for (final input in buildStep.findAssets(
      Glob('lib/brick/models/*.model.dart'),
    )) {
      final content = await buildStep.readAsString(input);
      if (content.contains('@DittoAdapter')) {
        modelFiles.add(input.path);

        // Extract the actual class name from the file
        final classNameMatch = RegExp(
          r'@DittoAdapter\([^)]+\)\s*class\s+(\w+)\s+extends',
        ).firstMatch(content);

        if (classNameMatch != null) {
          classNames[input.path] = classNameMatch.group(1)!;
        }
      }
    }

    if (modelFiles.isEmpty) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln(
        '// This file ensures all Ditto adapters are loaded at startup.',
      )
      ..writeln('')
      ..writeln(
        '// ignore_for_file: unused_import, depend_on_referenced_packages',
      )
      ..writeln('');

    // Import all model files
    for (final path in modelFiles) {
      final relativePath = path.replaceFirst('lib/', '');
      final fileName = path.split('/').last.replaceFirst('.dart', '');
      final importAlias = fileName.replaceAll('.', '_').replaceAll('-', '_');
      buffer.writeln(
        "import 'package:supabase_models/$relativePath' as $importAlias;",
      );
    }

    buffer
      ..writeln('')
      ..writeln('/// Forces all Ditto adapter static initializers to run.')
      ..writeln('/// Call this before using DittoSyncRegistry.')
      ..writeln('void ensureDittoAdaptersLoaded() {')
      ..writeln('  // Access registryToken getter to force static field init');

    for (final path in modelFiles) {
      final fileName = path.split('/').last.replaceFirst('.dart', '');
      final importAlias = fileName.replaceAll('.', '_').replaceAll('-', '_');
      final className = classNames[path];

      if (className != null) {
        buffer.writeln(
          '  $importAlias.${className}DittoAdapter.registryToken; // ignore: unnecessary_statements',
        );
      }
    }

    buffer.writeln('}');

    final outputId = AssetId(
      buildStep.inputId.package,
      'lib/sync/ditto_models_loader.g.dart',
    );
    await buildStep.writeAsString(outputId, buffer.toString());
  }
}
