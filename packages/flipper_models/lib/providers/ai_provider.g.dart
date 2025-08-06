// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geminiSummaryHash() => r'bf24e0c89d185a0011091e7211a61bc326b9184e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [geminiSummary].
@ProviderFor(geminiSummary)
const geminiSummaryProvider = GeminiSummaryFamily();

/// See also [geminiSummary].
class GeminiSummaryFamily extends Family<AsyncValue<String>> {
  /// See also [geminiSummary].
  const GeminiSummaryFamily();

  /// See also [geminiSummary].
  GeminiSummaryProvider call(
    String prompt,
  ) {
    return GeminiSummaryProvider(
      prompt,
    );
  }

  @override
  GeminiSummaryProvider getProviderOverride(
    covariant GeminiSummaryProvider provider,
  ) {
    return call(
      provider.prompt,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'geminiSummaryProvider';
}

/// See also [geminiSummary].
class GeminiSummaryProvider extends AutoDisposeFutureProvider<String> {
  /// See also [geminiSummary].
  GeminiSummaryProvider(
    String prompt,
  ) : this._internal(
          (ref) => geminiSummary(
            ref as GeminiSummaryRef,
            prompt,
          ),
          from: geminiSummaryProvider,
          name: r'geminiSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$geminiSummaryHash,
          dependencies: GeminiSummaryFamily._dependencies,
          allTransitiveDependencies:
              GeminiSummaryFamily._allTransitiveDependencies,
          prompt: prompt,
        );

  GeminiSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.prompt,
  }) : super.internal();

  final String prompt;

  @override
  Override overrideWith(
    FutureOr<String> Function(GeminiSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GeminiSummaryProvider._internal(
        (ref) => create(ref as GeminiSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        prompt: prompt,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GeminiSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeminiSummaryProvider && other.prompt == prompt;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, prompt.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GeminiSummaryRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `prompt` of this provider.
  String get prompt;
}

class _GeminiSummaryProviderElement
    extends AutoDisposeFutureProviderElement<String> with GeminiSummaryRef {
  _GeminiSummaryProviderElement(super.provider);

  @override
  String get prompt => (origin as GeminiSummaryProvider).prompt;
}

String _$streamedBusinessAnalyticsHash() =>
    r'50dfe5f380d2280d57f8190d0e478f37f1ac226c';

/// See also [streamedBusinessAnalytics].
@ProviderFor(streamedBusinessAnalytics)
const streamedBusinessAnalyticsProvider = StreamedBusinessAnalyticsFamily();

/// See also [streamedBusinessAnalytics].
class StreamedBusinessAnalyticsFamily
    extends Family<AsyncValue<List<BusinessAnalytic>>> {
  /// See also [streamedBusinessAnalytics].
  const StreamedBusinessAnalyticsFamily();

  /// See also [streamedBusinessAnalytics].
  StreamedBusinessAnalyticsProvider call(
    int branchId,
  ) {
    return StreamedBusinessAnalyticsProvider(
      branchId,
    );
  }

  @override
  StreamedBusinessAnalyticsProvider getProviderOverride(
    covariant StreamedBusinessAnalyticsProvider provider,
  ) {
    return call(
      provider.branchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'streamedBusinessAnalyticsProvider';
}

/// See also [streamedBusinessAnalytics].
class StreamedBusinessAnalyticsProvider
    extends AutoDisposeStreamProvider<List<BusinessAnalytic>> {
  /// See also [streamedBusinessAnalytics].
  StreamedBusinessAnalyticsProvider(
    int branchId,
  ) : this._internal(
          (ref) => streamedBusinessAnalytics(
            ref as StreamedBusinessAnalyticsRef,
            branchId,
          ),
          from: streamedBusinessAnalyticsProvider,
          name: r'streamedBusinessAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamedBusinessAnalyticsHash,
          dependencies: StreamedBusinessAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              StreamedBusinessAnalyticsFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  StreamedBusinessAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
  }) : super.internal();

  final int branchId;

  @override
  Override overrideWith(
    Stream<List<BusinessAnalytic>> Function(
            StreamedBusinessAnalyticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StreamedBusinessAnalyticsProvider._internal(
        (ref) => create(ref as StreamedBusinessAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<BusinessAnalytic>> createElement() {
    return _StreamedBusinessAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamedBusinessAnalyticsProvider &&
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreamedBusinessAnalyticsRef
    on AutoDisposeStreamProviderRef<List<BusinessAnalytic>> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _StreamedBusinessAnalyticsProviderElement
    extends AutoDisposeStreamProviderElement<List<BusinessAnalytic>>
    with StreamedBusinessAnalyticsRef {
  _StreamedBusinessAnalyticsProviderElement(super.provider);

  @override
  int get branchId => (origin as StreamedBusinessAnalyticsProvider).branchId;
}

String _$geminiResponseHash() => r'f9a143b08a4ba9ba139ff419ccb010443f6b7a71';

abstract class _$GeminiResponse
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final GeminiInput input;

  FutureOr<String> build(
    GeminiInput input,
  );
}

/// Providers
///
/// Copied from [GeminiResponse].
@ProviderFor(GeminiResponse)
const geminiResponseProvider = GeminiResponseFamily();

/// Providers
///
/// Copied from [GeminiResponse].
class GeminiResponseFamily extends Family<AsyncValue<String>> {
  /// Providers
  ///
  /// Copied from [GeminiResponse].
  const GeminiResponseFamily();

  /// Providers
  ///
  /// Copied from [GeminiResponse].
  GeminiResponseProvider call(
    GeminiInput input,
  ) {
    return GeminiResponseProvider(
      input,
    );
  }

  @override
  GeminiResponseProvider getProviderOverride(
    covariant GeminiResponseProvider provider,
  ) {
    return call(
      provider.input,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'geminiResponseProvider';
}

/// Providers
///
/// Copied from [GeminiResponse].
class GeminiResponseProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GeminiResponse, String> {
  /// Providers
  ///
  /// Copied from [GeminiResponse].
  GeminiResponseProvider(
    GeminiInput input,
  ) : this._internal(
          () => GeminiResponse()..input = input,
          from: geminiResponseProvider,
          name: r'geminiResponseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$geminiResponseHash,
          dependencies: GeminiResponseFamily._dependencies,
          allTransitiveDependencies:
              GeminiResponseFamily._allTransitiveDependencies,
          input: input,
        );

  GeminiResponseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.input,
  }) : super.internal();

  final GeminiInput input;

  @override
  FutureOr<String> runNotifierBuild(
    covariant GeminiResponse notifier,
  ) {
    return notifier.build(
      input,
    );
  }

  @override
  Override overrideWith(GeminiResponse Function() create) {
    return ProviderOverride(
      origin: this,
      override: GeminiResponseProvider._internal(
        () => create()..input = input,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        input: input,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GeminiResponse, String>
      createElement() {
    return _GeminiResponseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeminiResponseProvider && other.input == input;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, input.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GeminiResponseRef on AutoDisposeAsyncNotifierProviderRef<String> {
  /// The parameter `input` of this provider.
  GeminiInput get input;
}

class _GeminiResponseProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GeminiResponse, String>
    with GeminiResponseRef {
  _GeminiResponseProviderElement(super.provider);

  @override
  GeminiInput get input => (origin as GeminiResponseProvider).input;
}

String _$geminiBusinessAnalyticsHash() =>
    r'a9630a3f95f1d14a4a6792b0207b61e0f84efcd6';

abstract class _$GeminiBusinessAnalytics
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int branchId;
  late final String userPrompt;
  late final String? filePath;
  late final List<Content>? history;

  FutureOr<String> build(
    int branchId,
    String userPrompt, {
    String? filePath,
    List<Content>? history,
  });
}

/// See also [GeminiBusinessAnalytics].
@ProviderFor(GeminiBusinessAnalytics)
const geminiBusinessAnalyticsProvider = GeminiBusinessAnalyticsFamily();

/// See also [GeminiBusinessAnalytics].
class GeminiBusinessAnalyticsFamily extends Family<AsyncValue<String>> {
  /// See also [GeminiBusinessAnalytics].
  const GeminiBusinessAnalyticsFamily();

  /// See also [GeminiBusinessAnalytics].
  GeminiBusinessAnalyticsProvider call(
    int branchId,
    String userPrompt, {
    String? filePath,
    List<Content>? history,
  }) {
    return GeminiBusinessAnalyticsProvider(
      branchId,
      userPrompt,
      filePath: filePath,
      history: history,
    );
  }

  @override
  GeminiBusinessAnalyticsProvider getProviderOverride(
    covariant GeminiBusinessAnalyticsProvider provider,
  ) {
    return call(
      provider.branchId,
      provider.userPrompt,
      filePath: provider.filePath,
      history: provider.history,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'geminiBusinessAnalyticsProvider';
}

/// See also [GeminiBusinessAnalytics].
class GeminiBusinessAnalyticsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GeminiBusinessAnalytics,
        String> {
  /// See also [GeminiBusinessAnalytics].
  GeminiBusinessAnalyticsProvider(
    int branchId,
    String userPrompt, {
    String? filePath,
    List<Content>? history,
  }) : this._internal(
          () => GeminiBusinessAnalytics()
            ..branchId = branchId
            ..userPrompt = userPrompt
            ..filePath = filePath
            ..history = history,
          from: geminiBusinessAnalyticsProvider,
          name: r'geminiBusinessAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$geminiBusinessAnalyticsHash,
          dependencies: GeminiBusinessAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              GeminiBusinessAnalyticsFamily._allTransitiveDependencies,
          branchId: branchId,
          userPrompt: userPrompt,
          filePath: filePath,
          history: history,
        );

  GeminiBusinessAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.userPrompt,
    required this.filePath,
    required this.history,
  }) : super.internal();

  final int branchId;
  final String userPrompt;
  final String? filePath;
  final List<Content>? history;

  @override
  FutureOr<String> runNotifierBuild(
    covariant GeminiBusinessAnalytics notifier,
  ) {
    return notifier.build(
      branchId,
      userPrompt,
      filePath: filePath,
      history: history,
    );
  }

  @override
  Override overrideWith(GeminiBusinessAnalytics Function() create) {
    return ProviderOverride(
      origin: this,
      override: GeminiBusinessAnalyticsProvider._internal(
        () => create()
          ..branchId = branchId
          ..userPrompt = userPrompt
          ..filePath = filePath
          ..history = history,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        userPrompt: userPrompt,
        filePath: filePath,
        history: history,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GeminiBusinessAnalytics, String>
      createElement() {
    return _GeminiBusinessAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeminiBusinessAnalyticsProvider &&
        other.branchId == branchId &&
        other.userPrompt == userPrompt &&
        other.filePath == filePath &&
        other.history == history;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, userPrompt.hashCode);
    hash = _SystemHash.combine(hash, filePath.hashCode);
    hash = _SystemHash.combine(hash, history.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GeminiBusinessAnalyticsRef
    on AutoDisposeAsyncNotifierProviderRef<String> {
  /// The parameter `branchId` of this provider.
  int get branchId;

  /// The parameter `userPrompt` of this provider.
  String get userPrompt;

  /// The parameter `filePath` of this provider.
  String? get filePath;

  /// The parameter `history` of this provider.
  List<Content>? get history;
}

class _GeminiBusinessAnalyticsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GeminiBusinessAnalytics,
        String> with GeminiBusinessAnalyticsRef {
  _GeminiBusinessAnalyticsProviderElement(super.provider);

  @override
  int get branchId => (origin as GeminiBusinessAnalyticsProvider).branchId;
  @override
  String get userPrompt =>
      (origin as GeminiBusinessAnalyticsProvider).userPrompt;
  @override
  String? get filePath => (origin as GeminiBusinessAnalyticsProvider).filePath;
  @override
  List<Content>? get history =>
      (origin as GeminiBusinessAnalyticsProvider).history;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
