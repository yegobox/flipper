// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variants_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$variantHash() => r'945186b1c19e79fa1a1a94060141a1f96e5becd8';

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
    required String transactionId,
    required int branchId,
    String? key,
  }) {
    return VariantProvider(
      transactionId: transactionId,
      branchId: branchId,
      key: key,
    );
  }

  @override
  VariantProvider getProviderOverride(
    covariant VariantProvider provider,
  ) {
    return call(
      transactionId: provider.transactionId,
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
    required String transactionId,
    required int branchId,
    String? key,
  }) : this._internal(
          (ref) => variant(
            ref as VariantRef,
            transactionId: transactionId,
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
          transactionId: transactionId,
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
    required this.transactionId,
    required this.branchId,
    required this.key,
  }) : super.internal();

  final String transactionId;
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
        transactionId: transactionId,
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
        other.transactionId == transactionId &&
        other.branchId == branchId &&
        other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transactionId.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VariantRef on AutoDisposeFutureProviderRef<List<Variant>> {
  /// The parameter `transactionId` of this provider.
  String get transactionId;

  /// The parameter `branchId` of this provider.
  int get branchId;

  /// The parameter `key` of this provider.
  String? get key;
}

class _VariantProviderElement
    extends AutoDisposeFutureProviderElement<List<Variant>> with VariantRef {
  _VariantProviderElement(super.provider);

  @override
  String get transactionId => (origin as VariantProvider).transactionId;
  @override
  int get branchId => (origin as VariantProvider).branchId;
  @override
  String? get key => (origin as VariantProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
