// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalSaleHash() => r'49fcf494739f38b2bf3659e3b3947ead9c2e8461';

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

/// See also [TotalSale].
@ProviderFor(TotalSale)
const totalSaleProvider = TotalSaleFamily();

/// See also [TotalSale].
class TotalSaleFamily extends Family<AsyncValue<double>> {
  /// See also [TotalSale].
  const TotalSaleFamily();

  /// See also [TotalSale].
  TotalSaleProvider call({
    required int branchId,
  }) {
    return TotalSaleProvider(
      branchId: branchId,
    );
  }

  @override
  TotalSaleProvider getProviderOverride(
    covariant TotalSaleProvider provider,
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
  String? get name => r'totalSaleProvider';
}

/// See also [TotalSale].
class TotalSaleProvider extends AutoDisposeStreamProvider<double> {
  /// See also [TotalSale].
  TotalSaleProvider({
    required int branchId,
  }) : this._internal(
          (ref) => TotalSale(
            ref as TotalSaleRef,
            branchId: branchId,
          ),
          from: totalSaleProvider,
          name: r'totalSaleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalSaleHash,
          dependencies: TotalSaleFamily._dependencies,
          allTransitiveDependencies: TotalSaleFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  TotalSaleProvider._internal(
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
    Stream<double> Function(TotalSaleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalSaleProvider._internal(
        (ref) => create(ref as TotalSaleRef),
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
    return _TotalSaleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalSaleProvider && other.branchId == branchId;
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
mixin TotalSaleRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _TotalSaleProviderElement extends AutoDisposeStreamProviderElement<double>
    with TotalSaleRef {
  _TotalSaleProviderElement(super.provider);

  @override
  int get branchId => (origin as TotalSaleProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
