import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/services/branch_document_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_models/brick/repository/storage.dart';

final getIt = GetIt.instance;

/// Minimal box: the cache is preference keys plus the active branch.
class _FakeBox implements LocalStorage {
  final Map<String, Object?> _values = {};
  String? branchId;

  @override
  String? getBranchId() => branchId;

  @override
  String? readString({required String key}) => _values[key] as String?;

  @override
  Future<void> writeString({required String key, required String value}) async {
    _values[key] = value;
  }

  @override
  bool? readBool({required String key}) => _values[key] as bool?;

  @override
  Future<void> writeBool({required String key, required bool value}) async {
    _values[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  late _FakeBox box;

  setUp(() {
    box = _FakeBox();
    getIt.registerSingleton<LocalStorage>(box);
  });

  tearDown(() async => getIt.reset());

  group('stamp cache is partitioned by branch', () {
    test('a branch with nothing cached gets defaults', () {
      box.branchId = 'branch-a';
      final settings = BranchDocumentSettingsService.current();

      expect(settings.branchId, 'branch-a');
      expect(settings.hasStamp, isFalse);
    });

    test('its own branch reads its own stamp back', () {
      box.branchId = 'branch-a';
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          stampEnabled: true,
          stampImageBase64: 'AAAA',
          stampWidthMm: 44,
        ),
      );

      final settings = BranchDocumentSettingsService.current();
      expect(settings.hasStamp, isTrue);
      expect(settings.stampImageBase64, 'AAAA');
      expect(settings.stampWidthMm, 44);
    });

    test('another branch never inherits it', () {
      // The cache is a flat set of preference keys, so before this check a
      // branch switch stamped the next property's documents with the previous
      // property's mark until hydrate landed.
      box.branchId = 'branch-a';
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          stampEnabled: true,
          stampImageBase64: 'AAAA',
        ),
      );

      box.branchId = 'branch-b';
      final settings = BranchDocumentSettingsService.current();

      expect(settings.branchId, 'branch-b');
      expect(settings.hasStamp, isFalse);
      expect(settings.stampImageBase64, isNull);
    });

    test('switching back finds the stamp again', () {
      box.branchId = 'branch-a';
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          stampEnabled: true,
          stampImageBase64: 'AAAA',
        ),
      );
      box.branchId = 'branch-b';
      expect(BranchDocumentSettingsService.current().hasStamp, isFalse);

      box.branchId = 'branch-a';
      expect(BranchDocumentSettingsService.current().hasStamp, isTrue);
    });

    test('caching a branch with no stamp clears the previous one', () {
      box.branchId = 'branch-a';
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          stampEnabled: true,
          stampImageBase64: 'AAAA',
        ),
      );

      box.branchId = 'branch-b';
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(branchId: 'branch-b'),
      );

      expect(BranchDocumentSettingsService.current().hasStamp, isFalse);
    });
  });
}
