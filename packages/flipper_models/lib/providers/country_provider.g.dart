// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Countries for the origin pickers, ordered with the default first.
///
/// Falls back to the bundled CSV when the `countries` table has no rows (it is
/// remote-only, so a backend without that reference data leaves the dropdown
/// empty and unusable) or when the active strategy cannot serve it at all —
/// CapellaSync.countries() throws UnimplementedError, which is the web path.

@ProviderFor(countries)
final countriesProvider = CountriesProvider._();

/// Countries for the origin pickers, ordered with the default first.
///
/// Falls back to the bundled CSV when the `countries` table has no rows (it is
/// remote-only, so a backend without that reference data leaves the dropdown
/// empty and unusable) or when the active strategy cannot serve it at all —
/// CapellaSync.countries() throws UnimplementedError, which is the web path.

final class CountriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Country>>,
          List<Country>,
          FutureOr<List<Country>>
        >
    with $FutureModifier<List<Country>>, $FutureProvider<List<Country>> {
  /// Countries for the origin pickers, ordered with the default first.
  ///
  /// Falls back to the bundled CSV when the `countries` table has no rows (it is
  /// remote-only, so a backend without that reference data leaves the dropdown
  /// empty and unusable) or when the active strategy cannot serve it at all —
  /// CapellaSync.countries() throws UnimplementedError, which is the web path.
  CountriesProvider._()
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
  $FutureProviderElement<List<Country>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Country>> create(Ref ref) {
    return countries(ref);
  }
}

String _$countriesHash() => r'fa61bab2de6552ab8d3c1aba4fce9dc48ccec846';
