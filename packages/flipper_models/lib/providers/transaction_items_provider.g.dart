// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionItems)
const transactionItemsProvider = TransactionItemsFamily._();

final class TransactionItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionItem>>,
          List<TransactionItem>,
          FutureOr<List<TransactionItem>>
        >
    with
        $FutureModifier<List<TransactionItem>>,
        $FutureProvider<List<TransactionItem>> {
  const TransactionItemsProvider._({
    required TransactionItemsFamily super.from,
    required ({
      String? transactionId,
      String? requestId,
      String? branchId,
      bool fetchRemote,
      bool doneWithTransaction,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'transactionItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionItemsHash();

  @override
  String toString() {
    return r'transactionItemsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TransactionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransactionItem>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? transactionId,
              String? requestId,
              String? branchId,
              bool fetchRemote,
              bool doneWithTransaction,
            });
    return transactionItems(
      ref,
      transactionId: argument.transactionId,
      requestId: argument.requestId,
      branchId: argument.branchId,
      fetchRemote: argument.fetchRemote,
      doneWithTransaction: argument.doneWithTransaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionItemsHash() => r'04903b5d92ad2d1858b4848f9daae07518a04af8';

final class TransactionItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TransactionItem>>,
          ({
            String? transactionId,
            String? requestId,
            String? branchId,
            bool fetchRemote,
            bool doneWithTransaction,
          })
        > {
  const TransactionItemsFamily._()
    : super(
        retry: null,
        name: r'transactionItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionItemsProvider call({
    String? transactionId,
    String? requestId,
    String? branchId,
    bool fetchRemote = false,
    bool doneWithTransaction = false,
  }) => TransactionItemsProvider._(
    argument: (
      transactionId: transactionId,
      requestId: requestId,
      branchId: branchId,
      fetchRemote: fetchRemote,
      doneWithTransaction: doneWithTransaction,
    ),
    from: this,
  );

  @override
  String toString() => r'transactionItemsProvider';
}

@ProviderFor(transactionItemsStream)
const transactionItemsStreamProvider = TransactionItemsStreamFamily._();

final class TransactionItemsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionItem>>,
          List<TransactionItem>,
          Stream<List<TransactionItem>>
        >
    with
        $FutureModifier<List<TransactionItem>>,
        $StreamProvider<List<TransactionItem>> {
  const TransactionItemsStreamProvider._({
    required TransactionItemsStreamFamily super.from,
    required ({
      String? transactionId,
      String? branchId,
      String? requestId,
      bool fetchRemote,
      bool doneWithTransaction,
      bool forceRealData,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'transactionItemsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionItemsStreamHash();

  @override
  String toString() {
    return r'transactionItemsStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<TransactionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionItem>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? transactionId,
              String? branchId,
              String? requestId,
              bool fetchRemote,
              bool doneWithTransaction,
              bool forceRealData,
            });
    return transactionItemsStream(
      ref,
      transactionId: argument.transactionId,
      branchId: argument.branchId,
      requestId: argument.requestId,
      fetchRemote: argument.fetchRemote,
      doneWithTransaction: argument.doneWithTransaction,
      forceRealData: argument.forceRealData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionItemsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionItemsStreamHash() =>
    r'59c4d020adeda7ba407bb49d63d01b5b42d5de28';

final class TransactionItemsStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<TransactionItem>>,
          ({
            String? transactionId,
            String? branchId,
            String? requestId,
            bool fetchRemote,
            bool doneWithTransaction,
            bool forceRealData,
          })
        > {
  const TransactionItemsStreamFamily._()
    : super(
        retry: null,
        name: r'transactionItemsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionItemsStreamProvider call({
    String? transactionId,
    String? branchId,
    String? requestId,
    bool fetchRemote = false,
    bool doneWithTransaction = false,
    bool forceRealData = true,
  }) => TransactionItemsStreamProvider._(
    argument: (
      transactionId: transactionId,
      branchId: branchId,
      requestId: requestId,
      fetchRemote: fetchRemote,
      doneWithTransaction: doneWithTransaction,
      forceRealData: forceRealData,
    ),
    from: this,
  );

  @override
  String toString() => r'transactionItemsStreamProvider';
}
