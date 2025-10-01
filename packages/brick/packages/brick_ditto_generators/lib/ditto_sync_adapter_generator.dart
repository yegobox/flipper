import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Code generator for Ditto synchronization adapters.
class DittoSyncAdapterGenerator extends GeneratorForAnnotation<DittoAdapter> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final inputPath = buildStep.inputId.path;
    if (!inputPath.startsWith('lib/brick/models/')) {
      return '';
    }

    if (element is! ClassElement) return '';

    final classElement = element;
    final className = classElement.name;
    final collectionName = annotation.read('collectionName').stringValue;
    final fields =
        classElement.fields.where((field) => !field.isStatic).toList();
    final hasBranchId = fields.any((field) => field.name == 'branchId');

    // Generate the adapter code
    final buffer = StringBuffer();

    buffer
      ..writeln(
        '// **************************************************************************',
      )
      ..writeln('// DittoSyncAdapterGenerator')
      ..writeln(
        '// **************************************************************************',
      )
      ..writeln('')
      ..writeln('')
      ..writeln(
        'class ${className}DittoAdapter extends DittoSyncAdapter<$className> {',
      )
      ..writeln('  ${className}DittoAdapter._internal();')
      ..writeln('')
      ..writeln(
        '  static final ${className}DittoAdapter instance = ${className}DittoAdapter._internal();',
      )
      ..writeln('')
      ..writeln('  static int? Function()? _branchIdProviderOverride;')
      ..writeln('  static int? Function()? _businessIdProviderOverride;')
      ..writeln('')
      ..writeln(
        '  /// Allows tests to override how the current branch ID is resolved.',
      )
      ..writeln('  void overrideBranchIdProvider(int? Function()? provider) {')
      ..writeln('    _branchIdProviderOverride = provider;')
      ..writeln('  }')
      ..writeln('')
      ..writeln(
        '  /// Allows tests to override how the current business ID is resolved.',
      )
      ..writeln(
        '  void overrideBusinessIdProvider(int? Function()? provider) {',
      )
      ..writeln('    _businessIdProviderOverride = provider;')
      ..writeln('  }')
      ..writeln('')
      ..writeln('  /// Clears any provider overrides (intended for tests).')
      ..writeln('  void resetOverrides() {')
      ..writeln('    _branchIdProviderOverride = null;')
      ..writeln('    _businessIdProviderOverride = null;')
      ..writeln('  }')
      ..writeln('')
      ..writeln('  String get collectionName => "$collectionName";')
      ..writeln('')
      ..writeln('  @override')
      ..writeln('  Future<DittoSyncQuery?> buildObserverQuery() async {')
      ..writeln(
        '    final branchId = _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();',
      )
      ..writeln('    if (branchId == null) {')
      ..writeln(
        '      return const DittoSyncQuery(query: "SELECT * FROM $collectionName");',
      )
      ..writeln('    }')
      ..writeln('    return DittoSyncQuery(')
      ..writeln(
        '      query: "SELECT * FROM $collectionName WHERE branchId = :branchId",',
      )
      ..writeln('      arguments: {"branchId": branchId},')
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        '  Future<String?> documentIdForModel($className model) async => model.id;',
      )
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        '  Future<Map<String, dynamic>> toDittoDocument($className model) async {',
      )
      ..writeln('    return {')
      // Generate fields mapping
      ..write(_generateFieldsMapping(fields))
      ..writeln('    };')
      ..writeln('  }')
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        '  Future<$className?> fromDittoDocument(Map<String, dynamic> document) async {',
      )
      ..writeln('    final id = document["_id"] ?? document["id"];')
      ..writeln('    if (id == null) return null;')
      ..writeln('')
      ..writeln('    // Branch filtering')
      ..writeln(
        '    final currentBranch = _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();',
      )
      ..writeln('    final docBranch = document["branchId"];')
      ..writeln(
        '    if (currentBranch != null && docBranch != currentBranch) {',
      )
      ..writeln('      return null;')
      ..writeln('    }')
      ..writeln('')
      ..writeln('    return $className(')
      ..writeln('      id: id,')
      // Generate constructor args
      ..write(_generateConstructorArgs(fields))
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        '  Future<bool> shouldApplyRemote(Map<String, dynamic> document) async {',
      )
      ..writeln(
        '    final currentBranch = _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();',
      )
      ..writeln('    if (currentBranch == null) return true;')
      ..writeln('    final docBranch = document["branchId"];')
      ..writeln('    return docBranch == currentBranch;')
      ..writeln('  }')
      ..writeln('')
      ..write(_generateSeedMethod(className, hasBranchId: hasBranchId))
      ..writeln(
        '  static final int _\$${className}DittoAdapterRegistryToken = DittoSyncGeneratedRegistry.register((coordinator) async {',
      )
      ..writeln(
        '    await coordinator.registerAdapter<$className>(${className}DittoAdapter.instance);',
      )
      ..writeln('  }, seed: (coordinator) async {')
      ..writeln('    await _seed(coordinator);')
      ..writeln('  });')
      ..writeln('}');

    return buffer.toString();
  }
}

/// Builder factory for the Ditto sync adapter generator.
Builder dittoSyncAdapterBuilder(BuilderOptions options) =>
    PartBuilder([DittoSyncAdapterGenerator()], '.ditto_sync_adapter.g.dart');

String _generateFieldsMapping(List<FieldElement> fields) {
  final buffer = StringBuffer();
  for (final field in fields) {
    buffer.writeln('      "${field.name}": ${_serializeField(field)},');
  }
  return buffer.toString();
}

String _generateConstructorArgs(List<FieldElement> fields) {
  final buffer = StringBuffer();
  for (final field in fields) {
    if (field.name == 'id') continue;
    final typeName = field.type.getDisplayString(withNullability: false);
    if (typeName == 'DateTime') {
      buffer.writeln(
        '      ${field.name}: document["${field.name}"] != null ? DateTime.tryParse(document["${field.name}"]) : null,',
      );
    } else {
      buffer.writeln('      ${field.name}: document["${field.name}"],');
    }
  }
  return buffer.toString();
}

String _serializeField(FieldElement field) {
  final accessor = 'model.${field.name}';
  final typeName = field.type.getDisplayString(withNullability: false);
  if (typeName == 'DateTime') {
    return '$accessor?.toIso8601String()';
  }
  return accessor;
}

String _generateSeedMethod(String className, {required bool hasBranchId}) {
  final branchFilter = hasBranchId
      ? '''
      final branchId =
          _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
      if (branchId != null) {
        query = Query(where: [Where('branchId').isExactly(branchId)]);
      }
'''
      : '';

  return '''  static bool _seeded = false;

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      return;
    }

    try {
      Query? query;
$branchFilter
      final models = await Repository().get<$className>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      for (final model in models) {
        await coordinator.notifyLocalUpsert<$className>(model);
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for $className: \$error\\n\$stack');
      }
    }

    _seeded = true;
  }

''';
}
