// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dittoService)
const dittoServiceProvider = DittoServiceProvider._();

final class DittoServiceProvider
    extends $FunctionalProvider<DittoService, DittoService, DittoService>
    with $Provider<DittoService> {
  const DittoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dittoServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dittoServiceHash();

  @$internal
  @override
  $ProviderElement<DittoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DittoService create(Ref ref) {
    return dittoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DittoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DittoService>(value),
    );
  }
}

String _$dittoServiceHash() => r'9ae7d6fb5e98559e4ad9dead57463595001728d2';

@ProviderFor(challengeService)
const challengeServiceProvider = ChallengeServiceProvider._();

final class ChallengeServiceProvider
    extends
        $FunctionalProvider<
          ChallengeService,
          ChallengeService,
          ChallengeService
        >
    with $Provider<ChallengeService> {
  const ChallengeServiceProvider._()
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
  $ProviderElement<ChallengeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChallengeService create(Ref ref) {
    return challengeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChallengeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChallengeService>(value),
    );
  }
}

String _$challengeServiceHash() => r'9ab71acf0a4d9de1e85d323824e5ee17df9c2c3b';

@ProviderFor(availableChallengeCodes)
const availableChallengeCodesProvider = AvailableChallengeCodesProvider._();

final class AvailableChallengeCodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChallengeCode>>,
          List<ChallengeCode>,
          Stream<List<ChallengeCode>>
        >
    with
        $FutureModifier<List<ChallengeCode>>,
        $StreamProvider<List<ChallengeCode>> {
  const AvailableChallengeCodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableChallengeCodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableChallengeCodesHash();

  @$internal
  @override
  $StreamProviderElement<List<ChallengeCode>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChallengeCode>> create(Ref ref) {
    return availableChallengeCodes(ref);
  }
}

String _$availableChallengeCodesHash() =>
    r'2ae92806fa2877e1bc7d410384592ddff2366b43';

@ProviderFor(userClaims)
const userClaimsProvider = UserClaimsFamily._();

final class UserClaimsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Claim>>,
          List<Claim>,
          FutureOr<List<Claim>>
        >
    with $FutureModifier<List<Claim>>, $FutureProvider<List<Claim>> {
  const UserClaimsProvider._({
    required UserClaimsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userClaimsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userClaimsHash();

  @override
  String toString() {
    return r'userClaimsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Claim>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Claim>> create(Ref ref) {
    final argument = this.argument as String;
    return userClaims(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserClaimsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userClaimsHash() => r'7b04f1be17088970be5b6b81319d43fac05b362e';

final class UserClaimsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Claim>>, String> {
  const UserClaimsFamily._()
    : super(
        retry: null,
        name: r'userClaimsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserClaimsProvider call(String userId) =>
      UserClaimsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userClaimsProvider';
}

@ProviderFor(businessChallengeCodes)
const businessChallengeCodesProvider = BusinessChallengeCodesFamily._();

final class BusinessChallengeCodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChallengeCode>>,
          List<ChallengeCode>,
          FutureOr<List<ChallengeCode>>
        >
    with
        $FutureModifier<List<ChallengeCode>>,
        $FutureProvider<List<ChallengeCode>> {
  const BusinessChallengeCodesProvider._({
    required BusinessChallengeCodesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'businessChallengeCodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$businessChallengeCodesHash();

  @override
  String toString() {
    return r'businessChallengeCodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ChallengeCode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChallengeCode>> create(Ref ref) {
    final argument = this.argument as String;
    return businessChallengeCodes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessChallengeCodesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$businessChallengeCodesHash() =>
    r'd4af94c5f4be2cd3dba93fd0d3b1105d21ca4389';

final class BusinessChallengeCodesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ChallengeCode>>, String> {
  const BusinessChallengeCodesFamily._()
    : super(
        retry: null,
        name: r'businessChallengeCodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BusinessChallengeCodesProvider call(String businessId) =>
      BusinessChallengeCodesProvider._(argument: businessId, from: this);

  @override
  String toString() => r'businessChallengeCodesProvider';
}

@ProviderFor(ChallengeClaim)
const challengeClaimProvider = ChallengeClaimProvider._();

final class ChallengeClaimProvider
    extends $NotifierProvider<ChallengeClaim, AsyncValue<bool>> {
  const ChallengeClaimProvider._()
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

String _$challengeClaimHash() => r'f7a844bc80488d3451556469118f21d06a5bb353';

abstract class _$ChallengeClaim extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(dittoReady)
const dittoReadyProvider = DittoReadyProvider._();

final class DittoReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const DittoReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dittoReadyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dittoReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return dittoReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dittoReadyHash() => r'd5519b3d439f12741c256b65cd6f7883b5f85e83';
