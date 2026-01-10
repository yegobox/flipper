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
      required (
        UnifiedAIInput,
        AIModel?,
      )
          super.argument})
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
        '$argument';
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

String _$geminiResponseHash() => r'09bf77145db165e2fa41cbe79d94ea3c933c0c9e';

/// Providers

final class GeminiResponseFamily extends $Family
    with
        $ClassFamilyOverride<
            GeminiResponse,
            AsyncValue<String>,
            String,
            FutureOr<String>,
            (
              UnifiedAIInput,
              AIModel?,
            )> {
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
    UnifiedAIInput input,
    AIModel? aiModel,
  ) =>
      GeminiResponseProvider._(argument: (
        input,
        aiModel,
      ), from: this);

  @override
  String toString() => r'geminiResponseProvider';
}

/// Providers

abstract class _$GeminiResponse extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as (
    UnifiedAIInput,
    AIModel?,
  );
  UnifiedAIInput get input => _$args.$1;
  AIModel? get aiModel => _$args.$2;

  FutureOr<String> build(
    UnifiedAIInput input,
    AIModel? aiModel,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
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
        String,
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
    r'1405b809a8b835683e8a1d8a2ab86aa1418204e4';

final class GeminiBusinessAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
            GeminiBusinessAnalytics,
            AsyncValue<String>,
            String,
            FutureOr<String>,
            (
              String,
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
    String branchId,
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
    String,
    String, {
    String? filePath,
    List<Content>? history,
  });
  String get branchId => _$args.$1;
  String get userPrompt => _$args.$2;
  String? get filePath => _$args.filePath;
  List<Content>? get history => _$args.history;

  FutureOr<String> build(
    String branchId,
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

String _$geminiSummaryHash() => r'2a5ea7c9b7721717b6b56bd58d713c646a3fc534';

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
      required String super.argument})
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
    final argument = this.argument as String;
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
    r'087c0b987e5d3f7d085c717d3a13b92d9613dc5e';

final class StreamedBusinessAnalyticsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<BusinessAnalytic>>, String> {
  const StreamedBusinessAnalyticsFamily._()
      : super(
          retry: null,
          name: r'streamedBusinessAnalyticsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StreamedBusinessAnalyticsProvider call(
    String branchId,
  ) =>
      StreamedBusinessAnalyticsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'streamedBusinessAnalyticsProvider';
}
