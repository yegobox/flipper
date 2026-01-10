// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionList)
const transactionListProvider = TransactionListFamily._();

final class TransactionListProvider extends $FunctionalProvider<
        AsyncValue<List<ITransaction>>,
        List<ITransaction>,
        Stream<List<ITransaction>>>
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const TransactionListProvider._(
      {required TransactionListFamily super.from, required bool super.argument})
      : super(
          retry: null,
          name: r'transactionListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionListHash();

  @override
  String toString() {
    return r'transactionListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ITransaction>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument = this.argument as bool;
    return transactionList(
      ref,
      forceRealData: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionListHash() => r'663c941ffbd2e136425ff6e9b7c465ce4fdf8e61';

final class TransactionListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ITransaction>>, bool> {
  const TransactionListFamily._()
      : super(
          retry: null,
          name: r'transactionListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TransactionListProvider call({
    required bool forceRealData,
  }) =>
      TransactionListProvider._(argument: forceRealData, from: this);

  @override
  String toString() => r'transactionListProvider';
}

@ProviderFor(transactions)
const transactionsProvider = TransactionsFamily._();

final class TransactionsProvider extends $FunctionalProvider<
        AsyncValue<List<ITransaction>>,
        List<ITransaction>,
        Stream<List<ITransaction>>>
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const TransactionsProvider._(
      {required TransactionsFamily super.from, required bool super.argument})
      : super(
          retry: null,
          name: r'transactionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionsHash();

  @override
  String toString() {
    return r'transactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ITransaction>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument = this.argument as bool;
    return transactions(
      ref,
      forceRealData: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionsHash() => r'991ab7155e61940e2235a2d1cfaa33af7579ca17';

final class TransactionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ITransaction>>, bool> {
  const TransactionsFamily._()
      : super(
          retry: null,
          name: r'transactionsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TransactionsProvider call({
    bool forceRealData = true,
  }) =>
      TransactionsProvider._(argument: forceRealData, from: this);

  @override
  String toString() => r'transactionsProvider';
}

@ProviderFor(transactionItemList)
const transactionItemListProvider = TransactionItemListProvider._();

final class TransactionItemListProvider extends $FunctionalProvider<
        AsyncValue<List<TransactionItem>>,
        List<TransactionItem>,
        Stream<List<TransactionItem>>>
    with
        $FutureModifier<List<TransactionItem>>,
        $StreamProvider<List<TransactionItem>> {
  const TransactionItemListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transactionItemListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionItemListHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionItem>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionItem>> create(Ref ref) {
    return transactionItemList(ref);
  }
}

String _$transactionItemListHash() =>
    r'5558a8643d77d7e7a09937f6fef6a058ea001aa5';

@ProviderFor(pendingTransactionStream)
const pendingTransactionStreamProvider = PendingTransactionStreamFamily._();

final class PendingTransactionStreamProvider extends $FunctionalProvider<
        AsyncValue<ITransaction>, ITransaction, Stream<ITransaction>>
    with $FutureModifier<ITransaction>, $StreamProvider<ITransaction> {
  const PendingTransactionStreamProvider._(
      {required PendingTransactionStreamFamily super.from,
      required ({
        bool isExpense,
        bool forceRealData,
      })
          super.argument})
      : super(
          retry: null,
          name: r'pendingTransactionStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pendingTransactionStreamHash();

  @override
  String toString() {
    return r'pendingTransactionStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<ITransaction> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<ITransaction> create(Ref ref) {
    final argument = this.argument as ({
      bool isExpense,
      bool forceRealData,
    });
    return pendingTransactionStream(
      ref,
      isExpense: argument.isExpense,
      forceRealData: argument.forceRealData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PendingTransactionStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingTransactionStreamHash() =>
    r'361ae491b2d035f279b89e9dd076f815273218cc';

final class PendingTransactionStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<ITransaction>,
            ({
              bool isExpense,
              bool forceRealData,
            })> {
  const PendingTransactionStreamFamily._()
      : super(
          retry: null,
          name: r'pendingTransactionStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PendingTransactionStreamProvider call({
    required bool isExpense,
    bool forceRealData = true,
  }) =>
      PendingTransactionStreamProvider._(argument: (
        isExpense: isExpense,
        forceRealData: forceRealData,
      ), from: this);

  @override
  String toString() => r'pendingTransactionStreamProvider';
}

@ProviderFor(expensesStream)
const expensesStreamProvider = ExpensesStreamFamily._();

final class ExpensesStreamProvider extends $FunctionalProvider<
        AsyncValue<List<ITransaction>>,
        List<ITransaction>,
        Stream<List<ITransaction>>>
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const ExpensesStreamProvider._(
      {required ExpensesStreamFamily super.from,
      required ({
        DateTime startDate,
        DateTime endDate,
        String? branchId,
        bool forceRealData,
      })
          super.argument})
      : super(
          retry: null,
          name: r'expensesStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expensesStreamHash();

  @override
  String toString() {
    return r'expensesStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<ITransaction>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument = this.argument as ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    });
    return expensesStream(
      ref,
      startDate: argument.startDate,
      endDate: argument.endDate,
      branchId: argument.branchId,
      forceRealData: argument.forceRealData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesStreamHash() => r'3b6f5b5b81b8ac303aa35ddfe290e8ac18e14f71';

final class ExpensesStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<ITransaction>>,
            ({
              DateTime startDate,
              DateTime endDate,
              String? branchId,
              bool forceRealData,
            })> {
  const ExpensesStreamFamily._()
      : super(
          retry: null,
          name: r'expensesStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExpensesStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    String? branchId,
    bool forceRealData = true,
  }) =>
      ExpensesStreamProvider._(argument: (
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ), from: this);

  @override
  String toString() => r'expensesStreamProvider';
}

@ProviderFor(netProfitStream)
const netProfitStreamProvider = NetProfitStreamFamily._();

final class NetProfitStreamProvider
    extends $FunctionalProvider<AsyncValue<double>, double, Stream<double>>
    with $FutureModifier<double>, $StreamProvider<double> {
  const NetProfitStreamProvider._(
      {required NetProfitStreamFamily super.from,
      required ({
        DateTime startDate,
        DateTime endDate,
        String? branchId,
        bool forceRealData,
      })
          super.argument})
      : super(
          retry: null,
          name: r'netProfitStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$netProfitStreamHash();

  @override
  String toString() {
    return r'netProfitStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<double> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<double> create(Ref ref) {
    final argument = this.argument as ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    });
    return netProfitStream(
      ref,
      startDate: argument.startDate,
      endDate: argument.endDate,
      branchId: argument.branchId,
      forceRealData: argument.forceRealData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NetProfitStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$netProfitStreamHash() => r'52a02baa42b1221bb59497f06c9a8c7d82c87085';

final class NetProfitStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<double>,
            ({
              DateTime startDate,
              DateTime endDate,
              String? branchId,
              bool forceRealData,
            })> {
  const NetProfitStreamFamily._()
      : super(
          retry: null,
          name: r'netProfitStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NetProfitStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    String? branchId,
    bool forceRealData = true,
  }) =>
      NetProfitStreamProvider._(argument: (
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ), from: this);

  @override
  String toString() => r'netProfitStreamProvider';
}

@ProviderFor(grossProfitStream)
const grossProfitStreamProvider = GrossProfitStreamFamily._();

final class GrossProfitStreamProvider
    extends $FunctionalProvider<AsyncValue<double>, double, Stream<double>>
    with $FutureModifier<double>, $StreamProvider<double> {
  const GrossProfitStreamProvider._(
      {required GrossProfitStreamFamily super.from,
      required ({
        DateTime startDate,
        DateTime endDate,
        String? branchId,
        bool forceRealData,
      })
          super.argument})
      : super(
          retry: null,
          name: r'grossProfitStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$grossProfitStreamHash();

  @override
  String toString() {
    return r'grossProfitStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<double> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<double> create(Ref ref) {
    final argument = this.argument as ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    });
    return grossProfitStream(
      ref,
      startDate: argument.startDate,
      endDate: argument.endDate,
      branchId: argument.branchId,
      forceRealData: argument.forceRealData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GrossProfitStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$grossProfitStreamHash() => r'7a75cb980b1197e176be77825df1c854f2937076';

final class GrossProfitStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<double>,
            ({
              DateTime startDate,
              DateTime endDate,
              String? branchId,
              bool forceRealData,
            })> {
  const GrossProfitStreamFamily._()
      : super(
          retry: null,
          name: r'grossProfitStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GrossProfitStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    String? branchId,
    bool forceRealData = true,
  }) =>
      GrossProfitStreamProvider._(argument: (
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ), from: this);

  @override
  String toString() => r'grossProfitStreamProvider';
}

@ProviderFor(totalIncomeStream)
const totalIncomeStreamProvider = TotalIncomeStreamFamily._();

final class TotalIncomeStreamProvider
    extends $FunctionalProvider<AsyncValue<double>, double, Stream<double>>
    with $FutureModifier<double>, $StreamProvider<double> {
  const TotalIncomeStreamProvider._(
      {required TotalIncomeStreamFamily super.from,
      required ({
        DateTime startDate,
        DateTime endDate,
        String? branchId,
        bool forceRealData,
      })
          super.argument})
      : super(
          retry: null,
          name: r'totalIncomeStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalIncomeStreamHash();

  @override
  String toString() {
    return r'totalIncomeStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<double> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<double> create(Ref ref) {
    final argument = this.argument as ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    });
    return totalIncomeStream(
      ref,
      startDate: argument.startDate,
      endDate: argument.endDate,
      branchId: argument.branchId,
      forceRealData: argument.forceRealData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TotalIncomeStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalIncomeStreamHash() => r'0474739c23c0d1451a22b880a256179e76ee1aef';

final class TotalIncomeStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<double>,
            ({
              DateTime startDate,
              DateTime endDate,
              String? branchId,
              bool forceRealData,
            })> {
  const TotalIncomeStreamFamily._()
      : super(
          retry: null,
          name: r'totalIncomeStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TotalIncomeStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    String? branchId,
    bool forceRealData = true,
  }) =>
      TotalIncomeStreamProvider._(argument: (
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ), from: this);

  @override
  String toString() => r'totalIncomeStreamProvider';
}
