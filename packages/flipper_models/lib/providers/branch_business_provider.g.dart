// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_business_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$branchesHash() => r'f999c376c1b643455a5b70a11a804571cb2882b9';

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

/// See also [branches].
@ProviderFor(branches)
const branchesProvider = BranchesFamily();

/// See also [branches].
class BranchesFamily extends Family<AsyncValue<List<Branch>>> {
  /// See also [branches].
  const BranchesFamily();

  /// See also [branches].
  BranchesProvider call({
    int? businessId,
  }) {
    return BranchesProvider(
      businessId: businessId,
    );
  }

  @override
  BranchesProvider getProviderOverride(
    covariant BranchesProvider provider,
  ) {
    return call(
      businessId: provider.businessId,
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
  String? get name => r'branchesProvider';
}

/// See also [branches].
class BranchesProvider extends AutoDisposeFutureProvider<List<Branch>> {
  /// See also [branches].
  BranchesProvider({
    int? businessId,
  }) : this._internal(
          (ref) => branches(
            ref as BranchesRef,
            businessId: businessId,
          ),
          from: branchesProvider,
          name: r'branchesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$branchesHash,
          dependencies: BranchesFamily._dependencies,
          allTransitiveDependencies: BranchesFamily._allTransitiveDependencies,
          businessId: businessId,
        );

  BranchesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessId,
  }) : super.internal();

  final int? businessId;

  @override
  Override overrideWith(
    FutureOr<List<Branch>> Function(BranchesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BranchesProvider._internal(
        (ref) => create(ref as BranchesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessId: businessId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Branch>> createElement() {
    return _BranchesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchesProvider && other.businessId == businessId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BranchesRef on AutoDisposeFutureProviderRef<List<Branch>> {
  /// The parameter `businessId` of this provider.
  int? get businessId;
}

class _BranchesProviderElement
    extends AutoDisposeFutureProviderElement<List<Branch>> with BranchesRef {
  _BranchesProviderElement(super.provider);

  @override
  int? get businessId => (origin as BranchesProvider).businessId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
