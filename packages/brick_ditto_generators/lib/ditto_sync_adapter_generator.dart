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
      final enumValue = syncDirectionField.objectValue.toString();
      if (enumValue.contains('sendOnly')) {
        syncDirection = 'sendOnly';
      } else if (enumValue.contains('receiveOnly')) {
        syncDirection = 'receiveOnly';
      }
    }

    final fields = classElement.fields
        .where((field) => !field.isStatic && !field.isSynthetic)
        .toList();
    final hasBranchId = fields.any((field) => field.name == 'branchId');
    final enableBackupPull =
        annotation.peek('enableBackupPull')?.boolValue ?? false;
    final hydrateOnStartup =
        annotation.peek('hydrateOnStartup')?.boolValue ?? false;
    final hydrateOnStartupLiteral = hydrateOnStartup ? 'true' : 'false';
    final backupLinks = _collectBackupLinks(fields);

    // Validate that the source file has required imports
    final sourceContent = await buildStep.readAsString(buildStep.inputId);
    final missingImports = validateImports(sourceContent);

    if (missingImports.isNotEmpty) {
      log.warning(
        formatMissingImportsError(buildStep.inputId.path, missingImports),
      );
    }

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
        '// REQUIRED IMPORTS in parent file (${className!.toLowerCase()}.model.dart):',
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
      ..writeln('  // Observer management to prevent live query buildup')
      ..writeln('  dynamic _activeObserver;')
      ..writeln('  dynamic _activeSubscription;')
      ..writeln('')
      ..writeln('  static String? Function()? _branchIdProviderOverride;')
      ..writeln('  static String? Function()? _businessIdProviderOverride;')
      ..writeln('')
      ..writeln(
        '  /// Allows tests to override how the current branch ID is resolved.',
      )
      ..writeln(
          '  void overrideBranchIdProvider(String? Function()? provider) {')
      ..writeln('    _branchIdProviderOverride = provider;')
      ..writeln('  }')
      ..writeln('')
      ..writeln(
        '  /// Allows tests to override how the current business ID is resolved.',
      )
      ..writeln(
        '  void overrideBusinessIdProvider(String? Function()? provider) {',
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
      ..writeln('  /// Cleanup active observers to prevent live query buildup')
      ..writeln('  Future<void> dispose() async {')
      ..writeln('    await _activeObserver?.cancel();')
      ..writeln('    await _activeSubscription?.cancel();')
      ..writeln('    _activeObserver = null;')
      ..writeln('    _activeSubscription = null;')
      ..writeln('  }')
      ..writeln('')
      ..writeln('  @override')
      ..writeln('  String get collectionName => "$collectionName";')
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        '  SyncDirection get syncDirection => SyncDirection.$syncDirection;',
      )
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        '  bool get shouldHydrateOnStartup => $hydrateOnStartupLiteral;',
      )
      ..writeln('')
      ..writeln('  @override')
      ..writeln(
        enableBackupPull
            ? '  bool get supportsBackupPull => true;'
            : '  bool get supportsBackupPull => false;',
      )
      ..writeln('');

    if (enableBackupPull) {
      buffer
        ..writeln('  @override')
        ..writeln('  Future<DittoSyncQuery?> buildBackupPullQuery() async {');
      if (hasBranchId) {
        buffer
          ..writeln('    final branchId = await _resolveBranchId();')
          ..writeln('    if (branchId == null) {')
          ..writeln('      if (kDebugMode) {')
          ..writeln(
            '        debugPrint("Ditto backup pull for $className skipped because branch context is unavailable");',
          )
          ..writeln('      }')
          ..writeln('      return const DittoSyncQuery(')
          ..writeln(
            '        query: "SELECT * FROM $collectionName WHERE 1 = 0",',
          )
          ..writeln('      );')
          ..writeln('    }')
          ..writeln('    return DittoSyncQuery(')
          ..writeln(
            '      query: "SELECT * FROM $collectionName WHERE branchId = :branchId",',
          )
          ..writeln('      arguments: {"branchId": branchId},')
          ..writeln('    );');
      } else {
        buffer.writeln(
          '    return const DittoSyncQuery(query: "SELECT * FROM $collectionName");',
        );
      }
      buffer
        ..writeln('  }')
        ..writeln('')
        ..writeln('  @override')
        ..writeln('  List<DittoBackupLinkConfig> get backupLinks => const [');

      if (backupLinks.isEmpty) {
        buffer.writeln('    ];');
      } else {
        for (final link in backupLinks) {
          buffer
            ..writeln('    const DittoBackupLinkConfig(')
            ..writeln('      field: "${link.fieldName}",')
            ..writeln('      targetType: ${link.targetType},')
            ..writeln('      remoteKey: "${link.remoteKey}",')
            ..writeln('      cascade: ${link.cascade},')
            ..writeln('    ),');
        }
        buffer.writeln('  ];');
      }

      buffer.writeln('');
    }

    if (hasBranchId) {
      buffer
        ..writeln(
          '  Future<String?> _resolveBranchId({bool waitForValue = false}) async {',
        )
        ..writeln(
          '    String? branchId = _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();',
        )
        ..writeln('    if (!waitForValue || branchId != null) {')
        ..writeln('      return branchId;')
        ..writeln('    }')
        ..writeln('    final stopwatch = Stopwatch()..start();')
        ..writeln('    const timeout = Duration(seconds: 30);')
        ..writeln(
          '    while (branchId == null && stopwatch.elapsed < timeout) {',
        )
        ..writeln(
          '      await Future.delayed(const Duration(milliseconds: 200));',
        )
        ..writeln(
          '      branchId = _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();',
        )
        ..writeln('    }')
        ..writeln('    if (branchId == null && kDebugMode) {')
        ..writeln(
          '      debugPrint("Ditto hydration for $className timed out waiting for branchId");',
        )
        ..writeln('    }')
        ..writeln('    return branchId;')
        ..writeln('  }')
        ..writeln('');
    }

    if (syncDirection == 'sendOnly') {
      buffer
        ..writeln('  @override')
        ..writeln('  Future<DittoSyncQuery?> buildObserverQuery() async {')
        ..writeln('    // Send-only mode: no remote observation')
        ..writeln('    return null;')
        ..writeln('  }');
    } else {
      buffer
        ..writeln('  @override')
        ..writeln('  Future<DittoSyncQuery?> buildObserverQuery() async {')
        ..writeln(
          '    // Cleanup any existing observer before creating new one',
        )
        ..writeln('    await _cleanupActiveObserver();')
        ..writeln('    return _buildQuery(waitForBranchId: false);')
        ..writeln('  }')
        ..writeln('')
        ..writeln('  /// Cleanup active observer to prevent live query buildup')
        ..writeln('  Future<void> _cleanupActiveObserver() async {')
        ..writeln('    if (_activeObserver != null) {')
        ..writeln('      await _activeObserver?.cancel();')
        ..writeln('      _activeObserver = null;')
        ..writeln('    }')
        ..writeln('    if (_activeSubscription != null) {')
        ..writeln('      await _activeSubscription?.cancel();')
        ..writeln('      _activeSubscription = null;')
        ..writeln('    }')
        ..writeln('  }')
        ..writeln('')
        ..writeln(
          '  Future<DittoSyncQuery?> _buildQuery({required bool waitForBranchId}) async {',
        );

      if (hasBranchId) {
        buffer
          ..writeln(
            '    final branchId = await _resolveBranchId(waitForValue: waitForBranchId);',
          )
          ..writeln(
            '    final branchIdString = ProxyService.box.branchIdString();',
          )
          ..writeln('    final bhfId = await ProxyService.box.bhfId();')
          ..writeln('    final arguments = <String, dynamic>{};')
          ..writeln('    final whereParts = <String>[];')
          ..writeln('')
          ..writeln('    if (branchId != null) {')
          ..writeln("      whereParts.add('branchId = :branchId');")
          ..writeln('      arguments["branchId"] = branchId;')
          ..writeln('    }')
          ..writeln('')
          ..writeln(
            '    if (branchIdString != null && branchIdString.isNotEmpty) {',
          )
          ..writeln(
            "      whereParts.add('(branchId = :branchIdString OR branchIdString = :branchIdString)');",
          )
          ..writeln('      arguments["branchIdString"] = branchIdString;')
          ..writeln('    }')
          ..writeln('')
          ..writeln('    if (bhfId != null && bhfId.isNotEmpty) {')
          ..writeln("      whereParts.add('bhfId = :bhfId');")
          ..writeln('      arguments["bhfId"] = bhfId;')
          ..writeln('    }')
          ..writeln('')
          ..writeln('    if (whereParts.isEmpty) {')
          ..writeln('      if (waitForBranchId) {')
          ..writeln('        if (kDebugMode) {')
          ..writeln(
            '          debugPrint("Ditto hydration for $className skipped because branch context is unavailable");',
          )
          ..writeln('        }')
          ..writeln('        return null;')
          ..writeln('      }')
          ..writeln('      if (kDebugMode) {')
          ..writeln(
            '        debugPrint("Ditto observation for $className deferred until branch context is available");',
          )
          ..writeln('      }')
          ..writeln('      return const DittoSyncQuery(')
          ..writeln(
            '        query: "SELECT * FROM $collectionName WHERE 1 = 0",',
          )
          ..writeln('      );')
          ..writeln('    }')
          ..writeln('')
          ..writeln('    final whereClause = whereParts.join(" OR ");')
          ..writeln('    return DittoSyncQuery(')
          ..writeln(
            '      query: "SELECT * FROM $collectionName WHERE \$whereClause",',
          )
          ..writeln('      arguments: arguments,')
          ..writeln('    );');
      } else {
        buffer.writeln(
          '    return const DittoSyncQuery(query: "SELECT * FROM $collectionName");',
        );
      }

      buffer
        ..writeln('  }')
        ..writeln('')
        ..writeln('  @override')
        ..writeln('  Future<DittoSyncQuery?> buildHydrationQuery() async {')
        ..writeln('    return _buildQuery(waitForBranchId: true);')
        ..writeln('  }');
    }

    buffer
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
      ..writeln('    // Helper method to fetch relationships')
      ..writeln(
        '    Future<T?> fetchRelationship<T extends OfflineFirstWithSupabaseModel>(dynamic id) async {',
      )
      ..writeln('      if (id == null) return null;')
      ..writeln('      try {')
      ..writeln('        final results = await Repository().get<T>(')
      ..writeln('          query: Query(where: [Where(\'id\').isExactly(id)]),')
      ..writeln(
        '          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,',
      )
      ..writeln('        );')
      ..writeln('        return results.isNotEmpty ? results.first : null;')
      ..writeln('      } catch (e) {')
      ..writeln('        return null;')
      ..writeln('      }')
      ..writeln('    }')
      ..writeln('')
      ..writeln('    return $className(')
      ..writeln('      id: id,')
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
      ..writeln('  }, modelType: $className, seed: (coordinator) async {')
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
    // Skip fields that should not be synced to Ditto
    if (_shouldExcludeFromDitto(field)) {
      continue;
    }
    if (field.name == 'id') {
      buffer.writeln('      "_id": ${_serializeField(field)},');
      buffer.writeln('      "id": ${_serializeField(field)},');
    } else {
      buffer.writeln('      "${field.name}": ${_serializeField(field)},');
    }
  }
  return buffer.toString();
}

/// Determines if a field should be excluded from Ditto sync
bool _shouldExcludeFromDitto(FieldElement field) {
  // Check for @Supabase(ignore: true)
  try {
    final supabaseAnnotation = field.metadata.annotations.firstWhere(
      (annotation) => annotation.element?.displayName == 'Supabase',
      orElse: () => throw StateError('Not found'),
    );

    final source = supabaseAnnotation.toSource();
    if (source.contains('ignore:') && source.contains('true')) {
      return true;
    }
  } catch (_) {
    // No Supabase annotation found
  }

  // Check for @OfflineFirst annotation (usually for relationships)
  final hasOfflineFirst = field.metadata.annotations.any(
    (annotation) => annotation.element?.displayName == 'OfflineFirst',
  );

  if (hasOfflineFirst) {
    return true;
  }

  // Check if field type is a complex object (List of models)
  final typeName = field.type.getDisplayString(withNullability: false);
  if (typeName.startsWith('List<') &&
      !typeName.contains('String') &&
      !typeName.contains('int') &&
      !typeName.contains('double') &&
      !typeName.contains('bool') &&
      !typeName.contains('Map') &&
      !typeName.contains('num')) {
    // This is likely a List of model objects, exclude it
    return true;
  }

  // Check if field is a model relationship (extends OfflineFirstWithSupabaseModel)
  // Common model types that should be excluded from Ditto serialization
  final modelRelationshipTypes = [
    'Stock',
    'Product',
    'Variant',
    'Customer',
    'Branch',
    'Business',
    'Category',
    'Unit',
    'Favorite',
    'Pin',
    'Device',
    'Setting',
    'Ebm',
    'Composite',
    'VariantBranch',
    'InventoryRequest',
    'Financing',
    'FinanceProvider',
  ];

  if (modelRelationshipTypes.contains(typeName)) {
    return true;
  }

  return false;
}

String _generateConstructorArgs(List<FieldElement> fields) {
  final buffer = StringBuffer();
  for (final field in fields) {
    if (field.name == 'id') continue;
    // For fields excluded from Ditto, handle relationships or set to null
    if (_shouldExcludeFromDitto(field)) {
      if (_isModelRelationship(field)) {
        buffer.writeln(
          '      ${field.name}: ${_generateRelationshipFetch(field)}, // Fetched from repository',
        );
      } else {
        buffer
            .writeln('      ${field.name}: null, // Excluded from Ditto sync');
      }
      continue;
    }
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

String _generateSeedMethod(String? className, {required bool hasBranchId}) {
  if (className == null) return '';
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

/// Checks if a field represents a model relationship
bool _isModelRelationship(FieldElement field) {
  final typeName = field.type.getDisplayString(withNullability: false);
  final modelRelationshipTypes = [
    'Stock',
    'Product',
    'Variant',
    'Customer',
    'Branch',
    'Business',
    'Category',
    'Unit',
  ];
  return modelRelationshipTypes.contains(typeName);
}

/// Generates code to fetch a relationship from the repository
String _generateRelationshipFetch(FieldElement field) {
  final typeName = field.type.getDisplayString(withNullability: false);
  final fieldName = field.name;
  final foreignKeyField = '${fieldName}Id';

  return '''await fetchRelationship<$typeName>(document["$foreignKeyField"])''';
}

List<_BackupLink> _collectBackupLinks(List<FieldElement> fields) {
  final links = <_BackupLink>[];
  for (final field in fields) {
    for (final annotation in field.metadata.annotations) {
      final constant = annotation.computeConstantValue();
      if (constant == null) continue;
      final typeName =
          constant.type?.getDisplayString(withNullability: false) ?? '';
      if (typeName != 'DittoBackupLink') continue;

      final modelType = constant.getField('model')?.toTypeValue();
      if (modelType == null) continue;

      final overrideField = constant.getField('field')?.toStringValue();
      final remoteKey = constant.getField('remoteKey')?.toStringValue() ?? 'id';
      final cascade = constant.getField('cascade')?.toBoolValue() ?? true;

      links.add(
        _BackupLink(
          fieldName: overrideField ?? field.name!,
          targetType: modelType.getDisplayString(withNullability: false),
          remoteKey: remoteKey,
          cascade: cascade,
        ),
      );
    }
  }
  return links;
}

class _BackupLink {
  _BackupLink({
    required this.fieldName,
    required this.targetType,
    required this.remoteKey,
    required this.cascade,
  });

  final String fieldName;
  final String targetType;
  final String remoteKey;
  final bool cascade;
}
