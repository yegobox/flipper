// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Example controller that demonstrates how to use the UserRepository
/// to fetch and save user profiles from the API and Ditto

@ProviderFor(UserProfileController)
const userProfileControllerProvider = UserProfileControllerProvider._();

/// Example controller that demonstrates how to use the UserRepository
/// to fetch and save user profiles from the API and Ditto
final class UserProfileControllerProvider
    extends $NotifierProvider<UserProfileController, AsyncValue<UserProfile?>> {
  /// Example controller that demonstrates how to use the UserRepository
  /// to fetch and save user profiles from the API and Ditto
  const UserProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileControllerHash();

  @$internal
  @override
  UserProfileController create() => UserProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UserProfile?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UserProfile?>>(value),
    );
  }
}

String _$userProfileControllerHash() =>
    r'028a757f2a45c69573b7ef40bb7659165f3251ea';

/// Example controller that demonstrates how to use the UserRepository
/// to fetch and save user profiles from the API and Ditto

abstract class _$UserProfileController
    extends $Notifier<AsyncValue<UserProfile?>> {
  AsyncValue<UserProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<UserProfile?>, AsyncValue<UserProfile?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile?>, AsyncValue<UserProfile?>>,
              AsyncValue<UserProfile?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
