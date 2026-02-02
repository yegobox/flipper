// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_range_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A provider for managing date range state.

@ProviderFor(DateRange)
const dateRangeProvider = DateRangeProvider._();

/// A provider for managing date range state.
final class DateRangeProvider
    extends $NotifierProvider<DateRange, DateRangeModel> {
  /// A provider for managing date range state.
  const DateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateRangeHash();

  @$internal
  @override
  DateRange create() => DateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateRangeModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateRangeModel>(value),
    );
  }
}

String _$dateRangeHash() => r'268af0ecad10e688f98dd6bc846a77173a9b7490';

/// A provider for managing date range state.

abstract class _$DateRange extends $Notifier<DateRangeModel> {
  DateRangeModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateRangeModel, DateRangeModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateRangeModel, DateRangeModel>,
              DateRangeModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
