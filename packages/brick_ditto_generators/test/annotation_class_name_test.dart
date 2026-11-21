import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:brick_ditto_generators/annotation_class_name.dart';
import 'package:test/test.dart';

const _source = '''
class Supabase {
  final bool ignore;
  const Supabase({this.ignore = false});
  const Supabase.named();
}

const marker = Supabase();

class Model {
  @Supabase(ignore: true)
  String? unnamedConstructor;

  @Supabase.named()
  String? namedConstructor;

  @marker
  String? constVariable;

  String? plain;
}
''';

void main() {
  late Directory dir;
  late Map<String, List<ElementAnnotation>> annotations;

  setUpAll(() async {
    dir = Directory.systemTemp.createTempSync('annotation_class_name_');
    final path = File('${dir.path}/model.dart')..writeAsStringSync(_source);
    final file = path.absolute.path;
    final collection = AnalysisContextCollection(includedPaths: [file]);
    final result = await collection
        .contextFor(file)
        .currentSession
        .getResolvedLibrary(file) as ResolvedLibraryResult;
    final model = result.element.classes.firstWhere((c) => c.name == 'Model');
    annotations = {
      for (final field in model.fields) field.name!: field.metadata.annotations,
    };
  });

  tearDownAll(() => dir.deleteSync(recursive: true));

  test('an unnamed constructor annotation gives its class name', () {
    expect(
      annotationClassName(annotations['unnamedConstructor']!.single),
      'Supabase',
    );
  });

  test('a named constructor annotation gives its class name', () {
    expect(
      annotationClassName(annotations['namedConstructor']!.single),
      'Supabase',
    );
  });

  test('a const variable annotation gives the variable name', () {
    expect(
      annotationClassName(annotations['constVariable']!.single),
      'marker',
    );
  });

  test('an unannotated field has nothing to name', () {
    expect(annotations['plain'], isEmpty);
  });
}
