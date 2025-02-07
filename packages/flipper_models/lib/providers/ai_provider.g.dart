// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geminiResponseHash() => r'5d948cd5850cbe14d9c1ed6aa1241e3e01d6c0e3';

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

/// See also [geminiResponse].
@ProviderFor(geminiResponse)
const geminiResponseProvider = GeminiResponseFamily();

/// See also [geminiResponse].
class GeminiResponseFamily extends Family<AsyncValue<String>> {
  /// See also [geminiResponse].
  const GeminiResponseFamily();

  /// See also [geminiResponse].
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

/// See also [geminiResponse].
class GeminiResponseProvider extends AutoDisposeFutureProvider<String> {
  /// See also [geminiResponse].
  GeminiResponseProvider(
    GeminiInput input,
  ) : this._internal(
          (ref) => geminiResponse(
            ref as GeminiResponseRef,
            input,
          ),
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
  Override overrideWith(
    FutureOr<String> Function(GeminiResponseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GeminiResponseProvider._internal(
        (ref) => create(ref as GeminiResponseRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
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
mixin GeminiResponseRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `input` of this provider.
  GeminiInput get input;
}

class _GeminiResponseProviderElement
    extends AutoDisposeFutureProviderElement<String> with GeminiResponseRef {
  _GeminiResponseProviderElement(super.provider);

  @override
  GeminiInput get input => (origin as GeminiResponseProvider).input;
}

String _$geminiBusinessAnalyticsResponseHash() =>
    r'1cc3d87df4c59339e5a6c97d616cdcbdd65dc092';

/// See also [geminiBusinessAnalyticsResponse].
@ProviderFor(geminiBusinessAnalyticsResponse)
const geminiBusinessAnalyticsResponseProvider =
    GeminiBusinessAnalyticsResponseFamily();

/// See also [geminiBusinessAnalyticsResponse].
class GeminiBusinessAnalyticsResponseFamily extends Family<AsyncValue<String>> {
  /// See also [geminiBusinessAnalyticsResponse].
  const GeminiBusinessAnalyticsResponseFamily();

  /// See also [geminiBusinessAnalyticsResponse].
  GeminiBusinessAnalyticsResponseProvider call(
    int branchId,
    String userPrompt,
  ) {
    return GeminiBusinessAnalyticsResponseProvider(
      branchId,
      userPrompt,
    );
  }

  @override
  GeminiBusinessAnalyticsResponseProvider getProviderOverride(
    covariant GeminiBusinessAnalyticsResponseProvider provider,
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
  String? get name => r'geminiBusinessAnalyticsResponseProvider';
}

/// See also [geminiBusinessAnalyticsResponse].
class GeminiBusinessAnalyticsResponseProvider
    extends AutoDisposeFutureProvider<String> {
  /// See also [geminiBusinessAnalyticsResponse].
  GeminiBusinessAnalyticsResponseProvider(
    int branchId,
    String userPrompt,
  ) : this._internal(
          (ref) => geminiBusinessAnalyticsResponse(
            ref as GeminiBusinessAnalyticsResponseRef,
            branchId,
            userPrompt,
          ),
          from: geminiBusinessAnalyticsResponseProvider,
          name: r'geminiBusinessAnalyticsResponseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$geminiBusinessAnalyticsResponseHash,
          dependencies: GeminiBusinessAnalyticsResponseFamily._dependencies,
          allTransitiveDependencies:
              GeminiBusinessAnalyticsResponseFamily._allTransitiveDependencies,
          branchId: branchId,
          userPrompt: userPrompt,
        );

  GeminiBusinessAnalyticsResponseProvider._internal(
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
  Override overrideWith(
    FutureOr<String> Function(GeminiBusinessAnalyticsResponseRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GeminiBusinessAnalyticsResponseProvider._internal(
        (ref) => create(ref as GeminiBusinessAnalyticsResponseRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GeminiBusinessAnalyticsResponseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeminiBusinessAnalyticsResponseProvider &&
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
mixin GeminiBusinessAnalyticsResponseRef
    on AutoDisposeFutureProviderRef<String> {
  /// The parameter `branchId` of this provider.
  int get branchId;

  /// The parameter `userPrompt` of this provider.
  String get userPrompt;
}

class _GeminiBusinessAnalyticsResponseProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with GeminiBusinessAnalyticsResponseRef {
  _GeminiBusinessAnalyticsResponseProviderElement(super.provider);

  @override
  int get branchId =>
      (origin as GeminiBusinessAnalyticsResponseProvider).branchId;
  @override
  String get userPrompt =>
      (origin as GeminiBusinessAnalyticsResponseProvider).userPrompt;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
