// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variants_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$variantHash() => r'3e2e489d243c719820d5c9dd4e6682ada1c203b8';

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

/// See also [variant].
@ProviderFor(variant)
const variantProvider = VariantFamily();

/// See also [variant].
class VariantFamily extends Family<AsyncValue<List<Variant>>> {
  /// See also [variant].
  const VariantFamily();

  /// See also [variant].
  VariantProvider call({
    required int branchId,
    String? key,
  }) {
    return VariantProvider(
      branchId: branchId,
      key: key,
    );
  }

  @override
  VariantProvider getProviderOverride(
    covariant VariantProvider provider,
  ) {
    return call(
      branchId: provider.branchId,
      key: provider.key,
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
  String? get name => r'variantProvider';
}

/// See also [variant].
class VariantProvider extends AutoDisposeFutureProvider<List<Variant>> {
  /// See also [variant].
  VariantProvider({
    required int branchId,
    String? key,
  }) : this._internal(
          (ref) => variant(
            ref as VariantRef,
            branchId: branchId,
            key: key,
          ),
          from: variantProvider,
          name: r'variantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$variantHash,
          dependencies: VariantFamily._dependencies,
          allTransitiveDependencies: VariantFamily._allTransitiveDependencies,
          branchId: branchId,
          key: key,
        );

  VariantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.key,
  }) : super.internal();

  final int branchId;
  final String? key;

  @override
  Override overrideWith(
    FutureOr<List<Variant>> Function(VariantRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VariantProvider._internal(
        (ref) => create(ref as VariantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Variant>> createElement() {
    return _VariantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VariantProvider &&
        other.branchId == branchId &&
        other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VariantRef on AutoDisposeFutureProviderRef<List<Variant>> {
  /// The parameter `branchId` of this provider.
  int get branchId;

  /// The parameter `key` of this provider.
  String? get key;
}

class _VariantProviderElement
    extends AutoDisposeFutureProviderElement<List<Variant>> with VariantRef {
  _VariantProviderElement(super.provider);

  @override
  int get branchId => (origin as VariantProvider).branchId;
  @override
  String? get key => (origin as VariantProvider).key;
}

String _$purchaseVariantHash() => r'be3336685a9a0c92b6fd639607ad96a6f70e1bde';

/// See also [purchaseVariant].
@ProviderFor(purchaseVariant)
const purchaseVariantProvider = PurchaseVariantFamily();

/// See also [purchaseVariant].
class PurchaseVariantFamily extends Family<AsyncValue<List<Variant>>> {
  /// See also [purchaseVariant].
  const PurchaseVariantFamily();

  /// See also [purchaseVariant].
  PurchaseVariantProvider call({
    required int branchId,
    String? purchaseId,
  }) {
    return PurchaseVariantProvider(
      branchId: branchId,
      purchaseId: purchaseId,
    );
  }

  @override
  PurchaseVariantProvider getProviderOverride(
    covariant PurchaseVariantProvider provider,
  ) {
    return call(
      branchId: provider.branchId,
      purchaseId: provider.purchaseId,
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
  String? get name => r'purchaseVariantProvider';
}

/// See also [purchaseVariant].
class PurchaseVariantProvider extends AutoDisposeFutureProvider<List<Variant>> {
  /// See also [purchaseVariant].
  PurchaseVariantProvider({
    required int branchId,
    String? purchaseId,
  }) : this._internal(
          (ref) => purchaseVariant(
            ref as PurchaseVariantRef,
            branchId: branchId,
            purchaseId: purchaseId,
          ),
          from: purchaseVariantProvider,
          name: r'purchaseVariantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchaseVariantHash,
          dependencies: PurchaseVariantFamily._dependencies,
          allTransitiveDependencies:
              PurchaseVariantFamily._allTransitiveDependencies,
          branchId: branchId,
          purchaseId: purchaseId,
        );

  PurchaseVariantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.purchaseId,
  }) : super.internal();

  final int branchId;
  final String? purchaseId;

  @override
  Override overrideWith(
    FutureOr<List<Variant>> Function(PurchaseVariantRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PurchaseVariantProvider._internal(
        (ref) => create(ref as PurchaseVariantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        purchaseId: purchaseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Variant>> createElement() {
    return _PurchaseVariantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseVariantProvider &&
        other.branchId == branchId &&
        other.purchaseId == purchaseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, purchaseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PurchaseVariantRef on AutoDisposeFutureProviderRef<List<Variant>> {
  /// The parameter `branchId` of this provider.
  int get branchId;

  /// The parameter `purchaseId` of this provider.
  String? get purchaseId;
}

class _PurchaseVariantProviderElement
    extends AutoDisposeFutureProviderElement<List<Variant>>
    with PurchaseVariantRef {
  _PurchaseVariantProviderElement(super.provider);

  @override
  int get branchId => (origin as PurchaseVariantProvider).branchId;
  @override
  String? get purchaseId => (origin as PurchaseVariantProvider).purchaseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
