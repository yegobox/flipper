// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAccessesHash() => r'85031db45721354f90dd0afac7d5f119609d15a5';

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

/// See also [userAccesses].
@ProviderFor(userAccesses)
const userAccessesProvider = UserAccessesFamily();

/// See also [userAccesses].
class UserAccessesFamily extends Family<AsyncValue<List<Access>>> {
  /// See also [userAccesses].
  const UserAccessesFamily();

  /// See also [userAccesses].
  UserAccessesProvider call(
    int userId, {
    required String featureName,
  }) {
    return UserAccessesProvider(
      userId,
      featureName: featureName,
    );
  }

  @override
  UserAccessesProvider getProviderOverride(
    covariant UserAccessesProvider provider,
  ) {
    return call(
      provider.userId,
      featureName: provider.featureName,
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
  String? get name => r'userAccessesProvider';
}

/// See also [userAccesses].
class UserAccessesProvider extends AutoDisposeFutureProvider<List<Access>> {
  /// See also [userAccesses].
  UserAccessesProvider(
    int userId, {
    required String featureName,
  }) : this._internal(
          (ref) => userAccesses(
            ref as UserAccessesRef,
            userId,
            featureName: featureName,
          ),
          from: userAccessesProvider,
          name: r'userAccessesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userAccessesHash,
          dependencies: UserAccessesFamily._dependencies,
          allTransitiveDependencies:
              UserAccessesFamily._allTransitiveDependencies,
          userId: userId,
          featureName: featureName,
        );

  UserAccessesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.featureName,
  }) : super.internal();

  final int userId;
  final String featureName;

  @override
  Override overrideWith(
    FutureOr<List<Access>> Function(UserAccessesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserAccessesProvider._internal(
        (ref) => create(ref as UserAccessesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        featureName: featureName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Access>> createElement() {
    return _UserAccessesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAccessesProvider &&
        other.userId == userId &&
        other.featureName == featureName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, featureName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserAccessesRef on AutoDisposeFutureProviderRef<List<Access>> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `featureName` of this provider.
  String get featureName;
}

class _UserAccessesProviderElement
    extends AutoDisposeFutureProviderElement<List<Access>>
    with UserAccessesRef {
  _UserAccessesProviderElement(super.provider);

  @override
  int get userId => (origin as UserAccessesProvider).userId;
  @override
  String get featureName => (origin as UserAccessesProvider).featureName;
}

String _$allAccessesHash() => r'980941f566daf3451516ccdb9bcb74bb68069f36';

/// See also [allAccesses].
@ProviderFor(allAccesses)
const allAccessesProvider = AllAccessesFamily();

/// See also [allAccesses].
class AllAccessesFamily extends Family<AsyncValue<List<Access>>> {
  /// See also [allAccesses].
  const AllAccessesFamily();

  /// See also [allAccesses].
  AllAccessesProvider call(
    int userId,
  ) {
    return AllAccessesProvider(
      userId,
    );
  }

  @override
  AllAccessesProvider getProviderOverride(
    covariant AllAccessesProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'allAccessesProvider';
}

/// See also [allAccesses].
class AllAccessesProvider extends AutoDisposeFutureProvider<List<Access>> {
  /// See also [allAccesses].
  AllAccessesProvider(
    int userId,
  ) : this._internal(
          (ref) => allAccesses(
            ref as AllAccessesRef,
            userId,
          ),
          from: allAccessesProvider,
          name: r'allAccessesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allAccessesHash,
          dependencies: AllAccessesFamily._dependencies,
          allTransitiveDependencies:
              AllAccessesFamily._allTransitiveDependencies,
          userId: userId,
        );

  AllAccessesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<List<Access>> Function(AllAccessesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllAccessesProvider._internal(
        (ref) => create(ref as AllAccessesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Access>> createElement() {
    return _AllAccessesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllAccessesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllAccessesRef on AutoDisposeFutureProviderRef<List<Access>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _AllAccessesProviderElement
    extends AutoDisposeFutureProviderElement<List<Access>> with AllAccessesRef {
  _AllAccessesProviderElement(super.provider);

  @override
  int get userId => (origin as AllAccessesProvider).userId;
}

String _$featureAccessHash() => r'3463dcd719a683bfca69c6ffd41f26a7e74c660d';

/// See also [featureAccess].
@ProviderFor(featureAccess)
const featureAccessProvider = FeatureAccessFamily();

/// See also [featureAccess].
class FeatureAccessFamily extends Family<bool> {
  /// See also [featureAccess].
  const FeatureAccessFamily();

  /// See also [featureAccess].
  FeatureAccessProvider call({
    required int userId,
    required String featureName,
  }) {
    return FeatureAccessProvider(
      userId: userId,
      featureName: featureName,
    );
  }

  @override
  FeatureAccessProvider getProviderOverride(
    covariant FeatureAccessProvider provider,
  ) {
    return call(
      userId: provider.userId,
      featureName: provider.featureName,
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
  String? get name => r'featureAccessProvider';
}

/// See also [featureAccess].
class FeatureAccessProvider extends AutoDisposeProvider<bool> {
  /// See also [featureAccess].
  FeatureAccessProvider({
    required int userId,
    required String featureName,
  }) : this._internal(
          (ref) => featureAccess(
            ref as FeatureAccessRef,
            userId: userId,
            featureName: featureName,
          ),
          from: featureAccessProvider,
          name: r'featureAccessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$featureAccessHash,
          dependencies: FeatureAccessFamily._dependencies,
          allTransitiveDependencies:
              FeatureAccessFamily._allTransitiveDependencies,
          userId: userId,
          featureName: featureName,
        );

  FeatureAccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.featureName,
  }) : super.internal();

  final int userId;
  final String featureName;

  @override
  Override overrideWith(
    bool Function(FeatureAccessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeatureAccessProvider._internal(
        (ref) => create(ref as FeatureAccessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        featureName: featureName,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _FeatureAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureAccessProvider &&
        other.userId == userId &&
        other.featureName == featureName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, featureName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeatureAccessRef on AutoDisposeProviderRef<bool> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `featureName` of this provider.
  String get featureName;
}

class _FeatureAccessProviderElement extends AutoDisposeProviderElement<bool>
    with FeatureAccessRef {
  _FeatureAccessProviderElement(super.provider);

  @override
  int get userId => (origin as FeatureAccessProvider).userId;
  @override
  String get featureName => (origin as FeatureAccessProvider).featureName;
}

String _$featureAccessLevelHash() =>
    r'451ee862eb0bd1aedd815cae4d08f15e5dc1caaa';

/// See also [featureAccessLevel].
@ProviderFor(featureAccessLevel)
const featureAccessLevelProvider = FeatureAccessLevelFamily();

/// See also [featureAccessLevel].
class FeatureAccessLevelFamily extends Family<bool> {
  /// See also [featureAccessLevel].
  const FeatureAccessLevelFamily();

  /// See also [featureAccessLevel].
  FeatureAccessLevelProvider call({
    required int userId,
    required String accessLevel,
  }) {
    return FeatureAccessLevelProvider(
      userId: userId,
      accessLevel: accessLevel,
    );
  }

  @override
  FeatureAccessLevelProvider getProviderOverride(
    covariant FeatureAccessLevelProvider provider,
  ) {
    return call(
      userId: provider.userId,
      accessLevel: provider.accessLevel,
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
  String? get name => r'featureAccessLevelProvider';
}

/// See also [featureAccessLevel].
class FeatureAccessLevelProvider extends AutoDisposeProvider<bool> {
  /// See also [featureAccessLevel].
  FeatureAccessLevelProvider({
    required int userId,
    required String accessLevel,
  }) : this._internal(
          (ref) => featureAccessLevel(
            ref as FeatureAccessLevelRef,
            userId: userId,
            accessLevel: accessLevel,
          ),
          from: featureAccessLevelProvider,
          name: r'featureAccessLevelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$featureAccessLevelHash,
          dependencies: FeatureAccessLevelFamily._dependencies,
          allTransitiveDependencies:
              FeatureAccessLevelFamily._allTransitiveDependencies,
          userId: userId,
          accessLevel: accessLevel,
        );

  FeatureAccessLevelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.accessLevel,
  }) : super.internal();

  final int userId;
  final String accessLevel;

  @override
  Override overrideWith(
    bool Function(FeatureAccessLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeatureAccessLevelProvider._internal(
        (ref) => create(ref as FeatureAccessLevelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        accessLevel: accessLevel,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _FeatureAccessLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureAccessLevelProvider &&
        other.userId == userId &&
        other.accessLevel == accessLevel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, accessLevel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeatureAccessLevelRef on AutoDisposeProviderRef<bool> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `accessLevel` of this provider.
  String get accessLevel;
}

class _FeatureAccessLevelProviderElement
    extends AutoDisposeProviderElement<bool> with FeatureAccessLevelRef {
  _FeatureAccessLevelProviderElement(super.provider);

  @override
  int get userId => (origin as FeatureAccessLevelProvider).userId;
  @override
  String get accessLevel => (origin as FeatureAccessLevelProvider).accessLevel;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
