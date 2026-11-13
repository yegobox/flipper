// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'38d15292e1d1d4553c8f07a36b00411aa0a8d30e';

@ProviderFor(challengeService)
final challengeServiceProvider = ChallengeServiceProvider._();

final class ChallengeServiceProvider
    extends $FunctionalProvider<DittoService, DittoService, DittoService>
    with $Provider<DittoService> {
  ChallengeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengeServiceHash();

  @$internal
  @override
  $ProviderElement<DittoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DittoService create(Ref ref) {
    return challengeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DittoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DittoService>(value),
    );
  }
}

String _$challengeServiceHash() => r'39dcf2dd22b6a1909ec09d3635a1fad8c94c44a2';

@ProviderFor(ChallengeClaim)
final challengeClaimProvider = ChallengeClaimProvider._();

final class ChallengeClaimProvider
    extends $NotifierProvider<ChallengeClaim, AsyncValue<bool>> {
  ChallengeClaimProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengeClaimProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengeClaimHash();

  @$internal
  @override
  ChallengeClaim create() => ChallengeClaim();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$challengeClaimHash() => r'3386711794d878274bd2746b74628a82c19adc51';

abstract class _$ChallengeClaim extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ChallengeFinder)
final challengeFinderProvider = ChallengeFinderProvider._();

final class ChallengeFinderProvider
    extends
        $NotifierProvider<ChallengeFinder, AsyncValue<List<ChallengeCode>>> {
  ChallengeFinderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengeFinderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengeFinderHash();

  @$internal
  @override
  ChallengeFinder create() => ChallengeFinder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ChallengeCode>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ChallengeCode>>>(
        value,
      ),
    );
  }
}

String _$challengeFinderHash() => r'529b8daefe9ff970965ce6d6f0c2e003081f2550';

abstract class _$ChallengeFinder
    extends $Notifier<AsyncValue<List<ChallengeCode>>> {
  AsyncValue<List<ChallengeCode>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ChallengeCode>>,
              AsyncValue<List<ChallengeCode>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ChallengeCode>>,
                AsyncValue<List<ChallengeCode>>
              >,
              AsyncValue<List<ChallengeCode>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
