// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$countersHash() => r'dd59f67c7a77ff8f4056a21c14922d9fd8acf7e2';

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

/// See also [counters].
@ProviderFor(counters)
const countersProvider = CountersFamily();

/// See also [counters].
class CountersFamily extends Family<AsyncValue<List<Counter>>> {
  /// See also [counters].
  const CountersFamily();

  /// See also [counters].
  CountersProvider call(
    int branchId,
  ) {
    return CountersProvider(
      branchId,
    );
  }

  @override
  CountersProvider getProviderOverride(
    covariant CountersProvider provider,
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
  String? get name => r'countersProvider';
}

/// See also [counters].
class CountersProvider extends AutoDisposeStreamProvider<List<Counter>> {
  /// See also [counters].
  CountersProvider(
    int branchId,
  ) : this._internal(
          (ref) => counters(
            ref as CountersRef,
            branchId,
          ),
          from: countersProvider,
          name: r'countersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countersHash,
          dependencies: CountersFamily._dependencies,
          allTransitiveDependencies: CountersFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  CountersProvider._internal(
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
    Stream<List<Counter>> Function(CountersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CountersProvider._internal(
        (ref) => create(ref as CountersRef),
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
  AutoDisposeStreamProviderElement<List<Counter>> createElement() {
    return _CountersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CountersProvider && other.branchId == branchId;
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
mixin CountersRef on AutoDisposeStreamProviderRef<List<Counter>> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _CountersProviderElement
    extends AutoDisposeStreamProviderElement<List<Counter>> with CountersRef {
  _CountersProviderElement(super.provider);

  @override
  int get branchId => (origin as CountersProvider).branchId;
}

String _$highestCounterHash() => r'ad3835014d4943737b95e35145ad9b927fc18ac0';

/// See also [highestCounter].
@ProviderFor(highestCounter)
const highestCounterProvider = HighestCounterFamily();

/// See also [highestCounter].
class HighestCounterFamily extends Family<int> {
  /// See also [highestCounter].
  const HighestCounterFamily();

  /// See also [highestCounter].
  HighestCounterProvider call(
    int branchId,
  ) {
    return HighestCounterProvider(
      branchId,
    );
  }

  @override
  HighestCounterProvider getProviderOverride(
    covariant HighestCounterProvider provider,
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
  String? get name => r'highestCounterProvider';
}

/// See also [highestCounter].
class HighestCounterProvider extends AutoDisposeProvider<int> {
  /// See also [highestCounter].
  HighestCounterProvider(
    int branchId,
  ) : this._internal(
          (ref) => highestCounter(
            ref as HighestCounterRef,
            branchId,
          ),
          from: highestCounterProvider,
          name: r'highestCounterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$highestCounterHash,
          dependencies: HighestCounterFamily._dependencies,
          allTransitiveDependencies:
              HighestCounterFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  HighestCounterProvider._internal(
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
    int Function(HighestCounterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HighestCounterProvider._internal(
        (ref) => create(ref as HighestCounterRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _HighestCounterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HighestCounterProvider && other.branchId == branchId;
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
mixin HighestCounterRef on AutoDisposeProviderRef<int> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _HighestCounterProviderElement extends AutoDisposeProviderElement<int>
    with HighestCounterRef {
  _HighestCounterProviderElement(super.provider);

  @override
  int get branchId => (origin as HighestCounterProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
