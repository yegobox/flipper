// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(GeminiResponse)
const geminiResponseProvider = GeminiResponseFamily._();

/// Providers
final class GeminiResponseProvider
    extends $AsyncNotifierProvider<GeminiResponse, String> {
  /// Providers
  const GeminiResponseProvider._(
      {required GeminiResponseFamily super.from,
      required GeminiInput super.argument})
      : super(
          retry: null,
          name: r'geminiResponseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$geminiResponseHash();

  @override
  String toString() {
    return r'geminiResponseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GeminiResponse create() => GeminiResponse();

  @override
  bool operator ==(Object other) {
    return other is GeminiResponseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geminiResponseHash() => r'2035609e3fa651e343607ebc87d760a7a1f9661e';

/// Providers

final class GeminiResponseFamily extends $Family
    with
        $ClassFamilyOverride<GeminiResponse, AsyncValue<String>, String,
            FutureOr<String>, GeminiInput> {
  const GeminiResponseFamily._()
      : super(
          retry: null,
          name: r'geminiResponseProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Providers

  GeminiResponseProvider call(
    GeminiInput input,
  ) =>
      GeminiResponseProvider._(argument: input, from: this);

  @override
  String toString() => r'geminiResponseProvider';
}

/// Providers

abstract class _$GeminiResponse extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as GeminiInput;
  GeminiInput get input => _$args;

  FutureOr<String> build(
    GeminiInput input,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GeminiBusinessAnalytics)
const geminiBusinessAnalyticsProvider = GeminiBusinessAnalyticsFamily._();

final class GeminiBusinessAnalyticsProvider
    extends $AsyncNotifierProvider<GeminiBusinessAnalytics, String> {
  const GeminiBusinessAnalyticsProvider._(
      {required GeminiBusinessAnalyticsFamily super.from,
      required (
        int,
        String, {
        String? filePath,
        List<Content>? history,
      })
          super.argument})
      : super(
          retry: null,
          name: r'geminiBusinessAnalyticsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$geminiBusinessAnalyticsHash();

  @override
  String toString() {
    return r'geminiBusinessAnalyticsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  GeminiBusinessAnalytics create() => GeminiBusinessAnalytics();

  @override
  bool operator ==(Object other) {
    return other is GeminiBusinessAnalyticsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geminiBusinessAnalyticsHash() =>
    r'612a9acb20665a4ee5c7b2efda811770cf8c307e';

final class GeminiBusinessAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
            GeminiBusinessAnalytics,
            AsyncValue<String>,
            String,
            FutureOr<String>,
            (
              int,
              String, {
              String? filePath,
              List<Content>? history,
            })> {
  const GeminiBusinessAnalyticsFamily._()
      : super(
          retry: null,
          name: r'geminiBusinessAnalyticsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeminiBusinessAnalyticsProvider call(
    int branchId,
    String userPrompt, {
    String? filePath,
    List<Content>? history,
  }) =>
      GeminiBusinessAnalyticsProvider._(argument: (
        branchId,
        userPrompt,
        filePath: filePath,
        history: history,
      ), from: this);

  @override
  String toString() => r'geminiBusinessAnalyticsProvider';
}

abstract class _$GeminiBusinessAnalytics extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as (
    int,
    String, {
    String? filePath,
    List<Content>? history,
  });
  int get branchId => _$args.$1;
  String get userPrompt => _$args.$2;
  String? get filePath => _$args.filePath;
  List<Content>? get history => _$args.history;

  FutureOr<String> build(
    int branchId,
    String userPrompt, {
    String? filePath,
    List<Content>? history,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
      filePath: _$args.filePath,
      history: _$args.history,
    );
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(geminiSummary)
const geminiSummaryProvider = GeminiSummaryFamily._();

final class GeminiSummaryProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const GeminiSummaryProvider._(
      {required GeminiSummaryFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'geminiSummaryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$geminiSummaryHash();

  @override
  String toString() {
    return r'geminiSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return geminiSummary(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeminiSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geminiSummaryHash() => r'47ce0665f73a819980ec6f4fc79db07c9fbad9d3';

final class GeminiSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  const GeminiSummaryFamily._()
      : super(
          retry: null,
          name: r'geminiSummaryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeminiSummaryProvider call(
    String prompt,
  ) =>
      GeminiSummaryProvider._(argument: prompt, from: this);

  @override
  String toString() => r'geminiSummaryProvider';
}

@ProviderFor(streamedBusinessAnalytics)
const streamedBusinessAnalyticsProvider = StreamedBusinessAnalyticsFamily._();

final class StreamedBusinessAnalyticsProvider extends $FunctionalProvider<
        AsyncValue<List<BusinessAnalytic>>,
        List<BusinessAnalytic>,
        Stream<List<BusinessAnalytic>>>
    with
        $FutureModifier<List<BusinessAnalytic>>,
        $StreamProvider<List<BusinessAnalytic>> {
  const StreamedBusinessAnalyticsProvider._(
      {required StreamedBusinessAnalyticsFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'streamedBusinessAnalyticsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$streamedBusinessAnalyticsHash();

  @override
  String toString() {
    return r'streamedBusinessAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<BusinessAnalytic>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<BusinessAnalytic>> create(Ref ref) {
    final argument = this.argument as int;
    return streamedBusinessAnalytics(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StreamedBusinessAnalyticsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streamedBusinessAnalyticsHash() =>
    r'e08be810e878598fc06f65775e1bbfb585aff745';

final class StreamedBusinessAnalyticsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<BusinessAnalytic>>, int> {
  const StreamedBusinessAnalyticsFamily._()
      : super(
          retry: null,
          name: r'streamedBusinessAnalyticsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StreamedBusinessAnalyticsProvider call(
    int branchId,
  ) =>
      StreamedBusinessAnalyticsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'streamedBusinessAnalyticsProvider';
}
