// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$creditStreamHash() => r'a63e851949fa9f076502f8937d417405ecd32e2b';

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

/// See also [creditStream].
@ProviderFor(creditStream)
const creditStreamProvider = CreditStreamFamily();

/// See also [creditStream].
class CreditStreamFamily extends Family<AsyncValue<Credit?>> {
  /// See also [creditStream].
  const CreditStreamFamily();

  /// See also [creditStream].
  CreditStreamProvider call(
    int branchId,
  ) {
    return CreditStreamProvider(
      branchId,
    );
  }

  @override
  CreditStreamProvider getProviderOverride(
    covariant CreditStreamProvider provider,
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
  String? get name => r'creditStreamProvider';
}

/// See also [creditStream].
class CreditStreamProvider extends AutoDisposeStreamProvider<Credit?> {
  /// See also [creditStream].
  CreditStreamProvider(
    int branchId,
  ) : this._internal(
          (ref) => creditStream(
            ref as CreditStreamRef,
            branchId,
          ),
          from: creditStreamProvider,
          name: r'creditStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$creditStreamHash,
          dependencies: CreditStreamFamily._dependencies,
          allTransitiveDependencies:
              CreditStreamFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  CreditStreamProvider._internal(
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
    Stream<Credit?> Function(CreditStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreditStreamProvider._internal(
        (ref) => create(ref as CreditStreamRef),
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
  AutoDisposeStreamProviderElement<Credit?> createElement() {
    return _CreditStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreditStreamProvider && other.branchId == branchId;
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
mixin CreditStreamRef on AutoDisposeStreamProviderRef<Credit?> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _CreditStreamProviderElement
    extends AutoDisposeStreamProviderElement<Credit?> with CreditStreamRef {
  _CreditStreamProviderElement(super.provider);

  @override
  int get branchId => (origin as CreditStreamProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
