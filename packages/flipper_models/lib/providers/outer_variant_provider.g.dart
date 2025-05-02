// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outer_variant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outerVariantsHash() => r'3fb8c58eef0e7a60339a85e55844ef578a6c62f5';

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

abstract class _$OuterVariants
    extends BuildlessAutoDisposeAsyncNotifier<List<Variant>> {
  late final int branchId;
  late final dynamic fetchRemote;

  FutureOr<List<Variant>> build(
    int branchId, {
    dynamic fetchRemote = false,
  });
}

/// See also [OuterVariants].
@ProviderFor(OuterVariants)
const outerVariantsProvider = OuterVariantsFamily();

/// See also [OuterVariants].
class OuterVariantsFamily extends Family<AsyncValue<List<Variant>>> {
  /// See also [OuterVariants].
  const OuterVariantsFamily();

  /// See also [OuterVariants].
  OuterVariantsProvider call(
    int branchId, {
    dynamic fetchRemote = false,
  }) {
    return OuterVariantsProvider(
      branchId,
      fetchRemote: fetchRemote,
    );
  }

  @override
  OuterVariantsProvider getProviderOverride(
    covariant OuterVariantsProvider provider,
  ) {
    return call(
      provider.branchId,
      fetchRemote: provider.fetchRemote,
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
  String? get name => r'outerVariantsProvider';
}

/// See also [OuterVariants].
class OuterVariantsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OuterVariants, List<Variant>> {
  /// See also [OuterVariants].
  OuterVariantsProvider(
    int branchId, {
    dynamic fetchRemote = false,
  }) : this._internal(
          () => OuterVariants()
            ..branchId = branchId
            ..fetchRemote = fetchRemote,
          from: outerVariantsProvider,
          name: r'outerVariantsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$outerVariantsHash,
          dependencies: OuterVariantsFamily._dependencies,
          allTransitiveDependencies:
              OuterVariantsFamily._allTransitiveDependencies,
          branchId: branchId,
          fetchRemote: fetchRemote,
        );

  OuterVariantsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.fetchRemote,
  }) : super.internal();

  final int branchId;
  final dynamic fetchRemote;

  @override
  FutureOr<List<Variant>> runNotifierBuild(
    covariant OuterVariants notifier,
  ) {
    return notifier.build(
      branchId,
      fetchRemote: fetchRemote,
    );
  }

  @override
  Override overrideWith(OuterVariants Function() create) {
    return ProviderOverride(
      origin: this,
      override: OuterVariantsProvider._internal(
        () => create()
          ..branchId = branchId
          ..fetchRemote = fetchRemote,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        fetchRemote: fetchRemote,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OuterVariants, List<Variant>>
      createElement() {
    return _OuterVariantsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OuterVariantsProvider &&
        other.branchId == branchId &&
        other.fetchRemote == fetchRemote;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, fetchRemote.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OuterVariantsRef on AutoDisposeAsyncNotifierProviderRef<List<Variant>> {
  /// The parameter `branchId` of this provider.
  int get branchId;

  /// The parameter `fetchRemote` of this provider.
  dynamic get fetchRemote;
}

class _OuterVariantsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OuterVariants,
        List<Variant>> with OuterVariantsRef {
  _OuterVariantsProviderElement(super.provider);

  @override
  int get branchId => (origin as OuterVariantsProvider).branchId;
  @override
  dynamic get fetchRemote => (origin as OuterVariantsProvider).fetchRemote;
}

String _$productsHash() => r'8b22654ea21af89c94e9bf4369d356c54f94bd0c';

abstract class _$Products
    extends BuildlessAutoDisposeAsyncNotifier<List<Product>> {
  late final int branchId;

  FutureOr<List<Product>> build(
    int branchId,
  );
}

/// See also [Products].
@ProviderFor(Products)
const productsProvider = ProductsFamily();

/// See also [Products].
class ProductsFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [Products].
  const ProductsFamily();

  /// See also [Products].
  ProductsProvider call(
    int branchId,
  ) {
    return ProductsProvider(
      branchId,
    );
  }

  @override
  ProductsProvider getProviderOverride(
    covariant ProductsProvider provider,
  ) {
    return call(
      provider.branchId,
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
  String? get name => r'productsProvider';
}

/// See also [Products].
class ProductsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Products, List<Product>> {
  /// See also [Products].
  ProductsProvider(
    int branchId,
  ) : this._internal(
          () => Products()..branchId = branchId,
          from: productsProvider,
          name: r'productsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsHash,
          dependencies: ProductsFamily._dependencies,
          allTransitiveDependencies: ProductsFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  ProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
  }) : super.internal();

  final int branchId;

  @override
  FutureOr<List<Product>> runNotifierBuild(
    covariant Products notifier,
  ) {
    return notifier.build(
      branchId,
    );
  }

  @override
  Override overrideWith(Products Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductsProvider._internal(
        () => create()..branchId = branchId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Products, List<Product>>
      createElement() {
    return _ProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsProvider && other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsRef on AutoDisposeAsyncNotifierProviderRef<List<Product>> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _ProductsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Products, List<Product>>
    with ProductsRef {
  _ProductsProviderElement(super.provider);

  @override
  int get branchId => (origin as ProductsProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
