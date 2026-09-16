// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(businessTypes)
const businessTypesProvider = BusinessTypesProvider._();

final class BusinessTypesProvider
    extends
        $FunctionalProvider<
          List<BusinessType>,
          List<BusinessType>,
          List<BusinessType>
        >
    with $Provider<List<BusinessType>> {
  const BusinessTypesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessTypesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessTypesHash();

  @$internal
  @override
  $ProviderElement<List<BusinessType>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<BusinessType> create(Ref ref) {
    return businessTypes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BusinessType> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BusinessType>>(value),
    );
  }
}

String _$businessTypesHash() => r'002848af2bef84f87d547596fc1561c9a0811707';

@ProviderFor(countries)
const countriesProvider = CountriesProvider._();

final class CountriesProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  const CountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return countries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$countriesHash() => r'445e9a33585deb1523d0b8858c757d1af494a295';

@ProviderFor(SignupForm)
const signupFormProvider = SignupFormProvider._();

final class SignupFormProvider
    extends $NotifierProvider<SignupForm, SignupFormState> {
  const SignupFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupFormHash();

  @$internal
  @override
  SignupForm create() => SignupForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupFormState>(value),
    );
  }
}

String _$signupFormHash() => r'f4f51dab1f9d00b70b731fb7dc3ad487ffd628d9';

abstract class _$SignupForm extends $Notifier<SignupFormState> {
  SignupFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SignupFormState, SignupFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignupFormState, SignupFormState>,
              SignupFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
