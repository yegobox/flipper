// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geminiResponseHash() => r'1b640503005abdf2b11ffb60f3b620b663b47879';

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
    r'1ed3ebbe1a91107df9845068b7dc85280db7e347';

abstract class _$GeminiBusinessAnalytics
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int branchId;
  late final String userPrompt;

  FutureOr<String> build(
    int branchId,
    String userPrompt,
  );
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
    String userPrompt,
  ) {
    return GeminiBusinessAnalyticsProvider(
      branchId,
      userPrompt,
    );
  }

  @override
  GeminiBusinessAnalyticsProvider getProviderOverride(
    covariant GeminiBusinessAnalyticsProvider provider,
  ) {
    return call(
      provider.branchId,
      provider.userPrompt,
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
    String userPrompt,
  ) : this._internal(
          () => GeminiBusinessAnalytics()
            ..branchId = branchId
            ..userPrompt = userPrompt,
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
  }) : super.internal();

  final int branchId;
  final String userPrompt;

  @override
  FutureOr<String> runNotifierBuild(
    covariant GeminiBusinessAnalytics notifier,
  ) {
    return notifier.build(
      branchId,
      userPrompt,
    );
  }

  @override
  Override overrideWith(GeminiBusinessAnalytics Function() create) {
    return ProviderOverride(
      origin: this,
      override: GeminiBusinessAnalyticsProvider._internal(
        () => create()
          ..branchId = branchId
          ..userPrompt = userPrompt,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        userPrompt: userPrompt,
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
        other.userPrompt == userPrompt;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, userPrompt.hashCode);

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
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
