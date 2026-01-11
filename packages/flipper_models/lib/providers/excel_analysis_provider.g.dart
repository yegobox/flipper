// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_analysis_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExcelAnalysis)
const excelAnalysisProvider = ExcelAnalysisProvider._();

final class ExcelAnalysisProvider
    extends $NotifierProvider<ExcelAnalysis, ExcelAnalysisState> {
  const ExcelAnalysisProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'excelAnalysisProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$excelAnalysisHash();

  @$internal
  @override
  ExcelAnalysis create() => ExcelAnalysis();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExcelAnalysisState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExcelAnalysisState>(value),
    );
  }
}

String _$excelAnalysisHash() => r'edac2db8b3907981fad9e12877dbb2aefae6f786';

abstract class _$ExcelAnalysis extends $Notifier<ExcelAnalysisState> {
  ExcelAnalysisState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExcelAnalysisState, ExcelAnalysisState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ExcelAnalysisState, ExcelAnalysisState>,
        ExcelAnalysisState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
