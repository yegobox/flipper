// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionItemsHash() => r'4aaf54ea490b0aaed83633ebdd56b2001a3cd621';

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

/// See also [transactionItems].
@ProviderFor(transactionItems)
const transactionItemsProvider = TransactionItemsFamily();

/// See also [transactionItems].
class TransactionItemsFamily extends Family<AsyncValue<List<TransactionItem>>> {
  /// See also [transactionItems].
  const TransactionItemsFamily();

  /// See also [transactionItems].
  TransactionItemsProvider call({
    required String transactionId,
    required int branchId,
  }) {
    return TransactionItemsProvider(
      transactionId: transactionId,
      branchId: branchId,
    );
  }

  @override
  TransactionItemsProvider getProviderOverride(
    covariant TransactionItemsProvider provider,
  ) {
    return call(
      transactionId: provider.transactionId,
      branchId: provider.branchId,
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
  String? get name => r'transactionItemsProvider';
}

/// See also [transactionItems].
class TransactionItemsProvider
    extends AutoDisposeFutureProvider<List<TransactionItem>> {
  /// See also [transactionItems].
  TransactionItemsProvider({
    required String transactionId,
    required int branchId,
  }) : this._internal(
          (ref) => transactionItems(
            ref as TransactionItemsRef,
            transactionId: transactionId,
            branchId: branchId,
          ),
          from: transactionItemsProvider,
          name: r'transactionItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionItemsHash,
          dependencies: TransactionItemsFamily._dependencies,
          allTransitiveDependencies:
              TransactionItemsFamily._allTransitiveDependencies,
          transactionId: transactionId,
          branchId: branchId,
        );

  TransactionItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transactionId,
    required this.branchId,
  }) : super.internal();

  final String transactionId;
  final int branchId;

  @override
  Override overrideWith(
    FutureOr<List<TransactionItem>> Function(TransactionItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionItemsProvider._internal(
        (ref) => create(ref as TransactionItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transactionId: transactionId,
        branchId: branchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TransactionItem>> createElement() {
    return _TransactionItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionItemsProvider &&
        other.transactionId == transactionId &&
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transactionId.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionItemsRef
    on AutoDisposeFutureProviderRef<List<TransactionItem>> {
  /// The parameter `transactionId` of this provider.
  String get transactionId;

  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _TransactionItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<TransactionItem>>
    with TransactionItemsRef {
  _TransactionItemsProviderElement(super.provider);

  @override
  String get transactionId =>
      (origin as TransactionItemsProvider).transactionId;
  @override
  int get branchId => (origin as TransactionItemsProvider).branchId;
}

String _$transactionItemsStreamHash() =>
    r'1f05c9aa10b3b728cd5b9bfc6cc0a79b6a477349';

/// See also [transactionItemsStream].
@ProviderFor(transactionItemsStream)
const transactionItemsStreamProvider = TransactionItemsStreamFamily();

/// See also [transactionItemsStream].
class TransactionItemsStreamFamily
    extends Family<AsyncValue<List<TransactionItem>>> {
  /// See also [transactionItemsStream].
  const TransactionItemsStreamFamily();

  /// See also [transactionItemsStream].
  TransactionItemsStreamProvider call({
    required String transactionId,
    required int branchId,
  }) {
    return TransactionItemsStreamProvider(
      transactionId: transactionId,
      branchId: branchId,
    );
  }

  @override
  TransactionItemsStreamProvider getProviderOverride(
    covariant TransactionItemsStreamProvider provider,
  ) {
    return call(
      transactionId: provider.transactionId,
      branchId: provider.branchId,
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
  String? get name => r'transactionItemsStreamProvider';
}

/// See also [transactionItemsStream].
class TransactionItemsStreamProvider
    extends AutoDisposeStreamProvider<List<TransactionItem>> {
  /// See also [transactionItemsStream].
  TransactionItemsStreamProvider({
    required String transactionId,
    required int branchId,
  }) : this._internal(
          (ref) => transactionItemsStream(
            ref as TransactionItemsStreamRef,
            transactionId: transactionId,
            branchId: branchId,
          ),
          from: transactionItemsStreamProvider,
          name: r'transactionItemsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionItemsStreamHash,
          dependencies: TransactionItemsStreamFamily._dependencies,
          allTransitiveDependencies:
              TransactionItemsStreamFamily._allTransitiveDependencies,
          transactionId: transactionId,
          branchId: branchId,
        );

  TransactionItemsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transactionId,
    required this.branchId,
  }) : super.internal();

  final String transactionId;
  final int branchId;

  @override
  Override overrideWith(
    Stream<List<TransactionItem>> Function(TransactionItemsStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionItemsStreamProvider._internal(
        (ref) => create(ref as TransactionItemsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transactionId: transactionId,
        branchId: branchId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionItem>> createElement() {
    return _TransactionItemsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionItemsStreamProvider &&
        other.transactionId == transactionId &&
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transactionId.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionItemsStreamRef
    on AutoDisposeStreamProviderRef<List<TransactionItem>> {
  /// The parameter `transactionId` of this provider.
  String get transactionId;

  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _TransactionItemsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionItem>>
    with TransactionItemsStreamRef {
  _TransactionItemsStreamProviderElement(super.provider);

  @override
  String get transactionId =>
      (origin as TransactionItemsStreamProvider).transactionId;
  @override
  int get branchId => (origin as TransactionItemsStreamProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
