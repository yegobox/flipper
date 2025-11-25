// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$devicesForBranchHash() => r'3c5800408aa4a04f5b32eb830ed53acfc907370c';

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

/// See also [devicesForBranch].
@ProviderFor(devicesForBranch)
const devicesForBranchProvider = DevicesForBranchFamily();

/// See also [devicesForBranch].
class DevicesForBranchFamily extends Family<AsyncValue<List<Device>>> {
  /// See also [devicesForBranch].
  const DevicesForBranchFamily();

  /// See also [devicesForBranch].
  DevicesForBranchProvider call({
    required int branchId,
  }) {
    return DevicesForBranchProvider(
      branchId: branchId,
    );
  }

  @override
  DevicesForBranchProvider getProviderOverride(
    covariant DevicesForBranchProvider provider,
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
  String? get name => r'devicesForBranchProvider';
}

/// See also [devicesForBranch].
class DevicesForBranchProvider extends AutoDisposeFutureProvider<List<Device>> {
  /// See also [devicesForBranch].
  DevicesForBranchProvider({
    required int branchId,
  }) : this._internal(
          (ref) => devicesForBranch(
            ref as DevicesForBranchRef,
            branchId: branchId,
          ),
          from: devicesForBranchProvider,
          name: r'devicesForBranchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$devicesForBranchHash,
          dependencies: DevicesForBranchFamily._dependencies,
          allTransitiveDependencies:
              DevicesForBranchFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  DevicesForBranchProvider._internal(
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
    FutureOr<List<Device>> Function(DevicesForBranchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DevicesForBranchProvider._internal(
        (ref) => create(ref as DevicesForBranchRef),
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
  AutoDisposeFutureProviderElement<List<Device>> createElement() {
    return _DevicesForBranchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DevicesForBranchProvider && other.branchId == branchId;
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
mixin DevicesForBranchRef on AutoDisposeFutureProviderRef<List<Device>> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _DevicesForBranchProviderElement
    extends AutoDisposeFutureProviderElement<List<Device>>
    with DevicesForBranchRef {
  _DevicesForBranchProviderElement(super.provider);

  @override
  int get branchId => (origin as DevicesForBranchProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
