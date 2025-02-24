// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'eea2d4c000d9248c5b851f70400c36b5a405a9d5';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeStreamProvider<List<ITransaction>>.internal(
  transactions,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRef = AutoDisposeStreamProviderRef<List<ITransaction>>;
String _$transactionItemListHash() =>
    r'85552971ed9825743561738c79c9b409714319e1';

/// See also [transactionItemList].
@ProviderFor(transactionItemList)
final transactionItemListProvider =
    AutoDisposeStreamProvider<List<TransactionItem>>.internal(
  transactionItemList,
  name: r'transactionItemListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionItemListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionItemListRef
    = AutoDisposeStreamProviderRef<List<TransactionItem>>;
String _$pendingTransactionStreamHash() =>
    r'e947f3bc925e283e94af111320140db18e9c43d8';

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

/// See also [pendingTransactionStream].
@ProviderFor(pendingTransactionStream)
const pendingTransactionStreamProvider = PendingTransactionStreamFamily();

/// See also [pendingTransactionStream].
class PendingTransactionStreamFamily extends Family<AsyncValue<ITransaction>> {
  /// See also [pendingTransactionStream].
  const PendingTransactionStreamFamily();

  /// See also [pendingTransactionStream].
  PendingTransactionStreamProvider call({
    required bool isExpense,
  }) {
    return PendingTransactionStreamProvider(
      isExpense: isExpense,
    );
  }

  @override
  PendingTransactionStreamProvider getProviderOverride(
    covariant PendingTransactionStreamProvider provider,
  ) {
    return call(
      isExpense: provider.isExpense,
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
  String? get name => r'pendingTransactionStreamProvider';
}

/// See also [pendingTransactionStream].
class PendingTransactionStreamProvider
    extends AutoDisposeStreamProvider<ITransaction> {
  /// See also [pendingTransactionStream].
  PendingTransactionStreamProvider({
    required bool isExpense,
  }) : this._internal(
          (ref) => pendingTransactionStream(
            ref as PendingTransactionStreamRef,
            isExpense: isExpense,
          ),
          from: pendingTransactionStreamProvider,
          name: r'pendingTransactionStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pendingTransactionStreamHash,
          dependencies: PendingTransactionStreamFamily._dependencies,
          allTransitiveDependencies:
              PendingTransactionStreamFamily._allTransitiveDependencies,
          isExpense: isExpense,
        );

  PendingTransactionStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isExpense,
  }) : super.internal();

  final bool isExpense;

  @override
  Override overrideWith(
    Stream<ITransaction> Function(PendingTransactionStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingTransactionStreamProvider._internal(
        (ref) => create(ref as PendingTransactionStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isExpense: isExpense,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ITransaction> createElement() {
    return _PendingTransactionStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingTransactionStreamProvider &&
        other.isExpense == isExpense;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isExpense.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PendingTransactionStreamRef
    on AutoDisposeStreamProviderRef<ITransaction> {
  /// The parameter `isExpense` of this provider.
  bool get isExpense;
}

class _PendingTransactionStreamProviderElement
    extends AutoDisposeStreamProviderElement<ITransaction>
    with PendingTransactionStreamRef {
  _PendingTransactionStreamProviderElement(super.provider);

  @override
  bool get isExpense => (origin as PendingTransactionStreamProvider).isExpense;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
