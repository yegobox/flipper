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
String _$pendingTransactionHash() =>
    r'aa41c6d8d5c7d19b17f76cabd0a320a702fae2ab';

/// See also [pendingTransaction].
@ProviderFor(pendingTransaction)
final pendingTransactionProvider =
    AutoDisposeFutureProvider<ITransaction>.internal(
  pendingTransaction,
  name: r'pendingTransactionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingTransactionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingTransactionRef = AutoDisposeFutureProviderRef<ITransaction>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
