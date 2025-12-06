// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_purchase_dates_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$importPurchaseDatesHash() =>
    r'b38581246fcd47ca60ca59d7a6b6a0c2fcf2ac9f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider to fetch the last import/purchase date for a given branch and request type
///
/// Copied from [importPurchaseDates].
@ProviderFor(importPurchaseDates)
const importPurchaseDatesProvider = ImportPurchaseDatesFamily();

/// Provider to fetch the last import/purchase date for a given branch and request type
///
/// Copied from [importPurchaseDates].
class ImportPurchaseDatesFamily extends Family<AsyncValue<DateTime?>> {
  /// Provider to fetch the last import/purchase date for a given branch and request type
  ///
  /// Copied from [importPurchaseDates].
  const ImportPurchaseDatesFamily();

  /// Provider to fetch the last import/purchase date for a given branch and request type
  ///
  /// Copied from [importPurchaseDates].
  ImportPurchaseDatesProvider call({
    required String branchId,
    required String requestType,
  }) {
    return ImportPurchaseDatesProvider(
      branchId: branchId,
      requestType: requestType,
    );
  }

  @override
  ImportPurchaseDatesProvider getProviderOverride(
    covariant ImportPurchaseDatesProvider provider,
  ) {
    return call(
      branchId: provider.branchId,
      requestType: provider.requestType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'importPurchaseDatesProvider';
}

/// Provider to fetch the last import/purchase date for a given branch and request type
///
/// Copied from [importPurchaseDates].
class ImportPurchaseDatesProvider extends AutoDisposeFutureProvider<DateTime?> {
  /// Provider to fetch the last import/purchase date for a given branch and request type
  ///
  /// Copied from [importPurchaseDates].
  ImportPurchaseDatesProvider({
    required String branchId,
    required String requestType,
  }) : this._internal(
          (ref) => importPurchaseDates(
            ref as ImportPurchaseDatesRef,
            branchId: branchId,
            requestType: requestType,
          ),
          from: importPurchaseDatesProvider,
          name: r'importPurchaseDatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$importPurchaseDatesHash,
          dependencies: ImportPurchaseDatesFamily._dependencies,
          allTransitiveDependencies:
              ImportPurchaseDatesFamily._allTransitiveDependencies,
          branchId: branchId,
          requestType: requestType,
        );

  ImportPurchaseDatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.requestType,
  }) : super.internal();

  final String branchId;
  final String requestType;

  @override
  Override overrideWith(
    FutureOr<DateTime?> Function(ImportPurchaseDatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImportPurchaseDatesProvider._internal(
        (ref) => create(ref as ImportPurchaseDatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        requestType: requestType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DateTime?> createElement() {
    return _ImportPurchaseDatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImportPurchaseDatesProvider &&
        other.branchId == branchId &&
        other.requestType == requestType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ImportPurchaseDatesRef on AutoDisposeFutureProviderRef<DateTime?> {
  /// The parameter `branchId` of this provider.
  String get branchId;

  /// The parameter `requestType` of this provider.
  String get requestType;
}

class _ImportPurchaseDatesProviderElement
    extends AutoDisposeFutureProviderElement<DateTime?>
    with ImportPurchaseDatesRef {
  _ImportPurchaseDatesProviderElement(super.provider);

  @override
  String get branchId => (origin as ImportPurchaseDatesProvider).branchId;
  @override
  String get requestType => (origin as ImportPurchaseDatesProvider).requestType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
