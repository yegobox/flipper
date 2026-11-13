// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_range_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A provider for managing date range state.

@ProviderFor(DateRange)
final dateRangeProvider = DateRangeProvider._();

/// A provider for managing date range state.
final class DateRangeProvider
    extends $NotifierProvider<DateRange, DateRangeModel> {
  /// A provider for managing date range state.
  DateRangeProvider._()
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

String _$dateRangeHash() => r'bc952ce38096113d15e91b4482b86d8fee1293ca';

/// A provider for managing date range state.

abstract class _$DateRange extends $Notifier<DateRangeModel> {
  DateRangeModel build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateRangeModel, DateRangeModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateRangeModel, DateRangeModel>,
              DateRangeModel,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
