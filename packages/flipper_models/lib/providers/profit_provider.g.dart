// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profitHash() => r'55124a7fd4a819e61a5dbf573205f9cd56a151ff';

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

abstract class _$Profit extends BuildlessAutoDisposeAsyncNotifier<double> {
  late final int branchId;

  FutureOr<double> build(
    int branchId,
  );
}

/// See also [Profit].
@ProviderFor(Profit)
const profitProvider = ProfitFamily();

/// See also [Profit].
class ProfitFamily extends Family<AsyncValue<double>> {
  /// See also [Profit].
  const ProfitFamily();

  /// See also [Profit].
  ProfitProvider call(
    int branchId,
  ) {
    return ProfitProvider(
      branchId,
    );
  }

  @override
  ProfitProvider getProviderOverride(
    covariant ProfitProvider provider,
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
  String? get name => r'profitProvider';
}

/// See also [Profit].
class ProfitProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Profit, double> {
  /// See also [Profit].
  ProfitProvider(
    int branchId,
  ) : this._internal(
          () => Profit()..branchId = branchId,
          from: profitProvider,
          name: r'profitProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profitHash,
          dependencies: ProfitFamily._dependencies,
          allTransitiveDependencies: ProfitFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  ProfitProvider._internal(
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
  FutureOr<double> runNotifierBuild(
    covariant Profit notifier,
  ) {
    return notifier.build(
      branchId,
    );
  }

  @override
  Override overrideWith(Profit Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfitProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<Profit, double> createElement() {
    return _ProfitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfitProvider && other.branchId == branchId;
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
mixin ProfitRef on AutoDisposeAsyncNotifierProviderRef<double> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _ProfitProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Profit, double>
    with ProfitRef {
  _ProfitProviderElement(super.provider);

  @override
  int get branchId => (origin as ProfitProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
