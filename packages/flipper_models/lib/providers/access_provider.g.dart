// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isAdmin)
const isAdminProvider = IsAdminFamily._();

final class IsAdminProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsAdminProvider._({
    required IsAdminFamily super.from,
    required (String, {String featureName}) super.argument,
  }) : super(
         retry: null,
         name: r'isAdminProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isAdminHash();

  @override
  String toString() {
    return r'isAdminProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as (String, {String featureName});
    return isAdmin(ref, argument.$1, featureName: argument.featureName);
  }

  @override
  bool operator ==(Object other) {
    return other is IsAdminProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isAdminHash() => r'851984c66008a3d6bff1255ecc04b4a7994fdce7';

final class IsAdminFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          (String, {String featureName})
        > {
  const IsAdminFamily._()
    : super(
        retry: null,
        name: r'isAdminProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsAdminProvider call(String userId, {required String featureName}) =>
      IsAdminProvider._(
        argument: (userId, featureName: featureName),
        from: this,
      );

  @override
  String toString() => r'isAdminProvider';
}

@ProviderFor(userAccesses)
const userAccessesProvider = UserAccessesFamily._();

final class UserAccessesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Access>>,
          List<Access>,
          FutureOr<List<Access>>
        >
    with $FutureModifier<List<Access>>, $FutureProvider<List<Access>> {
  const UserAccessesProvider._({
    required UserAccessesFamily super.from,
    required (String, {String featureName}) super.argument,
  }) : super(
         retry: null,
         name: r'userAccessesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userAccessesHash();

  @override
  String toString() {
    return r'userAccessesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Access>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Access>> create(Ref ref) {
    final argument = this.argument as (String, {String featureName});
    return userAccesses(ref, argument.$1, featureName: argument.featureName);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAccessesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userAccessesHash() => r'bdee75c10ced4deea1d09af69517ba79518899f7';

final class UserAccessesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Access>>,
          (String, {String featureName})
        > {
  const UserAccessesFamily._()
    : super(
        retry: null,
        name: r'userAccessesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserAccessesProvider call(String userId, {required String featureName}) =>
      UserAccessesProvider._(
        argument: (userId, featureName: featureName),
        from: this,
      );

  @override
  String toString() => r'userAccessesProvider';
}

@ProviderFor(allAccesses)
const allAccessesProvider = AllAccessesFamily._();

final class AllAccessesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Access>>,
          List<Access>,
          FutureOr<List<Access>>
        >
    with $FutureModifier<List<Access>>, $FutureProvider<List<Access>> {
  const AllAccessesProvider._({
    required AllAccessesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'allAccessesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allAccessesHash();

  @override
  String toString() {
    return r'allAccessesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Access>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Access>> create(Ref ref) {
    final argument = this.argument as String;
    return allAccesses(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllAccessesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allAccessesHash() => r'fd7365d30cdb76a733b716498c120cf7201d0964';

final class AllAccessesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Access>>, String> {
  const AllAccessesFamily._()
    : super(
        retry: null,
        name: r'allAccessesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AllAccessesProvider call(String userId) =>
      AllAccessesProvider._(argument: userId, from: this);

  @override
  String toString() => r'allAccessesProvider';
}

@ProviderFor(tenant)
const tenantProvider = TenantFamily._();

final class TenantProvider
    extends $FunctionalProvider<AsyncValue<Tenant?>, Tenant?, FutureOr<Tenant?>>
    with $FutureModifier<Tenant?>, $FutureProvider<Tenant?> {
  const TenantProvider._({
    required TenantFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tenantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantHash();

  @override
  String toString() {
    return r'tenantProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Tenant?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Tenant?> create(Ref ref) {
    final argument = this.argument as String;
    return tenant(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantHash() => r'055c38c0a9dce197cee9721713664d3941718f97';

final class TenantFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Tenant?>, String> {
  const TenantFamily._()
    : super(
        retry: null,
        name: r'tenantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TenantProvider call(String userId) =>
      TenantProvider._(argument: userId, from: this);

  @override
  String toString() => r'tenantProvider';
}

@ProviderFor(featureAccess)
const featureAccessProvider = FeatureAccessFamily._();

final class FeatureAccessProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const FeatureAccessProvider._({
    required FeatureAccessFamily super.from,
    required ({String userId, String featureName}) super.argument,
  }) : super(
         retry: null,
         name: r'featureAccessProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$featureAccessHash();

  @override
  String toString() {
    return r'featureAccessProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as ({String userId, String featureName});
    return featureAccess(
      ref,
      userId: argument.userId,
      featureName: argument.featureName,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureAccessProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$featureAccessHash() => r'2354d8ec52b91ec8b8c20b4db8b5ca73dc11a6ea';

final class FeatureAccessFamily extends $Family
    with
        $FunctionalFamilyOverride<bool, ({String userId, String featureName})> {
  const FeatureAccessFamily._()
    : super(
        retry: null,
        name: r'featureAccessProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FeatureAccessProvider call({
    required String userId,
    required String featureName,
  }) => FeatureAccessProvider._(
    argument: (userId: userId, featureName: featureName),
    from: this,
  );

  @override
  String toString() => r'featureAccessProvider';
}

/// this check if a user has one accessLevel required to grant him access regardles of the feature
/// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
/// to whatever he is trying to access

@ProviderFor(featureAccessLevel)
const featureAccessLevelProvider = FeatureAccessLevelFamily._();

/// this check if a user has one accessLevel required to grant him access regardles of the feature
/// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
/// to whatever he is trying to access

final class FeatureAccessLevelProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// this check if a user has one accessLevel required to grant him access regardles of the feature
  /// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
  /// to whatever he is trying to access
  const FeatureAccessLevelProvider._({
    required FeatureAccessLevelFamily super.from,
    required ({String userId, String accessLevel}) super.argument,
  }) : super(
         retry: null,
         name: r'featureAccessLevelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$featureAccessLevelHash();

  @override
  String toString() {
    return r'featureAccessLevelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as ({String userId, String accessLevel});
    return featureAccessLevel(
      ref,
      userId: argument.userId,
      accessLevel: argument.accessLevel,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureAccessLevelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$featureAccessLevelHash() =>
    r'ca5706e11e1c269b92fd3426ce984b35354d8614';

/// this check if a user has one accessLevel required to grant him access regardles of the feature
/// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
/// to whatever he is trying to access

final class FeatureAccessLevelFamily extends $Family
    with
        $FunctionalFamilyOverride<bool, ({String userId, String accessLevel})> {
  const FeatureAccessLevelFamily._()
    : super(
        retry: null,
        name: r'featureAccessLevelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// this check if a user has one accessLevel required to grant him access regardles of the feature
  /// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
  /// to whatever he is trying to access

  FeatureAccessLevelProvider call({
    required String userId,
    required String accessLevel,
  }) => FeatureAccessLevelProvider._(
    argument: (userId: userId, accessLevel: accessLevel),
    from: this,
  );

  @override
  String toString() => r'featureAccessLevelProvider';
}
