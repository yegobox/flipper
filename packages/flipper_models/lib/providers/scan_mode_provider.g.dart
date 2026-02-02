// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScanningMode)
const scanningModeProvider = ScanningModeProvider._();

final class ScanningModeProvider extends $NotifierProvider<ScanningMode, bool> {
  const ScanningModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanningModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanningModeHash();

  @$internal
  @override
  ScanningMode create() => ScanningMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$scanningModeHash() => r'c6815c0e13e83778bea13d2068f4fa0d9111913c';

abstract class _$ScanningMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SearchString)
const searchStringProvider = SearchStringProvider._();

final class SearchStringProvider
    extends $NotifierProvider<SearchString, String> {
  const SearchStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchStringHash();

  @$internal
  @override
  SearchString create() => SearchString();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchStringHash() => r'23a12d0f8dcea3722ba0895fadeec888580de0df';

abstract class _$SearchString extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
