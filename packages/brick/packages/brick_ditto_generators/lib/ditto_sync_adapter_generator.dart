import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:brick_ditto_generators/import_validator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Code generator for Ditto synchronization adapters.
class DittoSyncAdapterGenerator extends GeneratorForAnnotation<DittoAdapter> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final inputPath = buildStep.inputId.path;
    if (!inputPath.startsWith('lib/brick/models/')) {
      return '';
    }

    if (element is! ClassElement) return '';

    final classElement = element;
    final className = classElement.name;
    final collectionName = annotation.read('collectionName').stringValue;

    // Read sync direction from annotation
    final syncDirectionField = annotation.read('syncDirection');
    String syncDirection = 'bidirectional';
    if (!syncDirectionField.isNull) {
      // Extract enum value name (e.g., "SyncDirection.sendOnly" -> "sendOnly")
      final enumValue = syncDirectionField.objectValue.toString();
      if (enumValue.contains('sendOnly')) {
        syncDirection = 'sendOnly';
      } else if (enumValue.contains('receiveOnly')) {
        syncDirection = 'receiveOnly';
      }
    }

    final fields =
        classElement.fields.where((field) => !field.isStatic).toList();
    final hasBranchId = fields.any((field) => field.name == 'branchId');

    // Validate that the source file has required imports
    final sourceContent = await buildStep.readAsString(buildStep.inputId);
    final missingImports = validateImports(sourceContent);

    if (missingImports.isNotEmpty) {
      log.warning(
        formatMissingImportsError(buildStep.inputId.path, missingImports),
      );
    }

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
      ..writeln('//')
      ..writeln(
        '// REQUIRED IMPORTS in parent file (${className.toLowerCase()}.model.dart):',
      )
      ..writeln('// - import \'package:brick_core/query.dart\';')
      ..writeln(
        '// - import \'package:brick_offline_first/brick_offline_first.dart\';',
      )
      ..writeln('// - import \'package:flipper_services/proxy.dart\';')
      ..writeln(
        '// - import \'package:flutter/foundation.dart\' show debugPrint, kDebugMode;',
      )
      ..writeln(
        '// - import \'package:supabase_models/sync/ditto_sync_adapter.dart\';',
      )
      ..writeln(
        '// - import \'package:supabase_models/sync/ditto_sync_coordinator.dart\';',
      )
      ..writeln(
        '// - import \'package:supabase_models/sync/ditto_sync_generated.dart\';',
      )
      ..writeln(
        '// - import \'package:supabase_models/brick/repository.dart\';',
      )
      ..writeln(
        '// **************************************************************************',
      )
      ..writeln('//')
      ..writeln('// Sync Direction: $syncDirection')
      ..writeln(
        syncDirection == 'sendOnly'
            ? '// This adapter sends data to Ditto but does NOT receive remote updates.'
            : syncDirection == 'receiveOnly'
                ? '// This adapter receives data from Ditto but does NOT send local changes.'
                : '// This adapter supports full bidirectional sync (send and receive).',
      )
      ..writeln(
        '// **************************************************************************',
      )
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
      ..writeln('  Future<DittoSyncQuery?> buildObserverQuery() async {');

    // For sendOnly mode, return null to disable remote observation
    if (syncDirection == 'sendOnly') {
      buffer
        ..writeln('    // Send-only mode: no remote observation')
        ..writeln('    return null;')
        ..writeln('  }');
    } else {
      // For receiveOnly and bidirectional: enable observation
      buffer
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
        ..writeln('  }');
    }

    buffer
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
      ..writeln('  }, reset: _resetSeedFlag);')
      ..writeln('')
      ..writeln('  /// Public accessor to ensure static initializer runs')
      ..writeln(
        '  static int get registryToken => _\$${className}DittoAdapterRegistryToken;',
      )
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
    buffer.writeln('      ${field.name}: ${_deserializeField(field)},');
  }
  return buffer.toString();
}

String _serializeField(FieldElement field) {
  final accessor = 'model.${field.name}';
  if (_isDateTime(field)) {
    return _isNullable(field)
        ? '$accessor?.toIso8601String()'
        : '$accessor.toIso8601String()';
  }
  return accessor;
}

String _deserializeField(FieldElement field) {
  final accessor = 'document["${field.name}"]';
  if (_isDateTime(field)) {
    final parseExpr = 'DateTime.tryParse($accessor?.toString() ?? "")';
    if (_isNullable(field)) {
      return parseExpr;
    }
    return '$parseExpr ?? DateTime.now().toUtc()';
  }
  return accessor;
}

bool _isNullable(FieldElement field) =>
    field.type.getDisplayString(withNullability: true).endsWith('?');

bool _isDateTime(FieldElement field) =>
    field.type.getDisplayString(withNullability: false) == 'DateTime';

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

  static void _resetSeedFlag() {
    _seeded = false;
  }

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      if (kDebugMode) {
        debugPrint('Ditto seeding skipped for $className (already seeded)');
      }
      return;
    }

    try {
      Query? query;
$branchFilter
      final models = await Repository().get<$className>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<$className>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' $className record' +
            (seededCount == 1 ? '' : 's'));
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
