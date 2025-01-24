// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_value_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockValueHash() => r'af3b214ab488fd89f7ee8971178ec65e87f9a3ca';

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

/// See also [StockValue].
@ProviderFor(StockValue)
const stockValueProvider = StockValueFamily();

/// See also [StockValue].
class StockValueFamily extends Family<AsyncValue<double>> {
  /// See also [StockValue].
  const StockValueFamily();

  /// See also [StockValue].
  StockValueProvider call({
    required int branchId,
  }) {
    return StockValueProvider(
      branchId: branchId,
    );
  }

  @override
  StockValueProvider getProviderOverride(
    covariant StockValueProvider provider,
  ) {
    return call(
      branchId: provider.branchId,
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
  String? get name => r'stockValueProvider';
}

/// See also [StockValue].
class StockValueProvider extends AutoDisposeStreamProvider<double> {
  /// See also [StockValue].
  StockValueProvider({
    required int branchId,
  }) : this._internal(
          (ref) => StockValue(
            ref as StockValueRef,
            branchId: branchId,
          ),
          from: stockValueProvider,
          name: r'stockValueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockValueHash,
          dependencies: StockValueFamily._dependencies,
          allTransitiveDependencies:
              StockValueFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  StockValueProvider._internal(
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
  Override overrideWith(
    Stream<double> Function(StockValueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockValueProvider._internal(
        (ref) => create(ref as StockValueRef),
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
  AutoDisposeStreamProviderElement<double> createElement() {
    return _StockValueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockValueProvider && other.branchId == branchId;
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
mixin StockValueRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _StockValueProviderElement
    extends AutoDisposeStreamProviderElement<double> with StockValueRef {
  _StockValueProviderElement(super.provider);

  @override
  int get branchId => (origin as StockValueProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
