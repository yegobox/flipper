// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coreTransactionsStream)
const coreTransactionsStreamProvider = CoreTransactionsStreamFamily._();

final class CoreTransactionsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ITransaction>>,
          List<ITransaction>,
          Stream<List<ITransaction>>
        >
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const CoreTransactionsStreamProvider._({
    required CoreTransactionsStreamFamily super.from,
    required ({
      DateTime startDate,
      DateTime endDate,
      String branchId,
      bool forceRealData,
      bool includeParked,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'coreTransactionsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coreTransactionsStreamHash();

  @override
  String toString() {
    return r'coreTransactionsStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<ITransaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              DateTime startDate,
              DateTime endDate,
              String branchId,
              bool forceRealData,
              bool includeParked,
            });
    return coreTransactionsStream(
      ref,
      startDate: argument.startDate,
      endDate: argument.endDate,
      branchId: argument.branchId,
      forceRealData: argument.forceRealData,
      includeParked: argument.includeParked,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoreTransactionsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coreTransactionsStreamHash() =>
    r'79c101c9a679b0234682b9a87d6c64f9290ac653';

final class CoreTransactionsStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<ITransaction>>,
          ({
            DateTime startDate,
            DateTime endDate,
            String branchId,
            bool forceRealData,
            bool includeParked,
          })
        > {
  const CoreTransactionsStreamFamily._()
    : super(
        retry: null,
        name: r'coreTransactionsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoreTransactionsStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    required String branchId,
    bool forceRealData = true,
    bool includeParked = false,
  }) => CoreTransactionsStreamProvider._(
    argument: (
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
      includeParked: includeParked,
    ),
    from: this,
  );

  @override
  String toString() => r'coreTransactionsStreamProvider';
}

@ProviderFor(transactionReportSnapshot)
const transactionReportSnapshotProvider = TransactionReportSnapshotFamily._();

final class TransactionReportSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransactionReportSnapshot>,
          TransactionReportSnapshot,
          Stream<TransactionReportSnapshot>
        >
    with
        $FutureModifier<TransactionReportSnapshot>,
        $StreamProvider<TransactionReportSnapshot> {
  const TransactionReportSnapshotProvider._({
    required TransactionReportSnapshotFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'transactionReportSnapshotProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionReportSnapshotHash();

  @override
  String toString() {
    return r'transactionReportSnapshotProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<TransactionReportSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TransactionReportSnapshot> create(Ref ref) {
    final argument = this.argument as bool;
    return transactionReportSnapshot(ref, forceRealData: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionReportSnapshotProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionReportSnapshotHash() =>
    r'944206634f9f8782a3d105a8a6ed47fa62edf5d0';

final class TransactionReportSnapshotFamily extends $Family
    with $FunctionalFamilyOverride<Stream<TransactionReportSnapshot>, bool> {
  const TransactionReportSnapshotFamily._()
    : super(
        retry: null,
        name: r'transactionReportSnapshotProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionReportSnapshotProvider call({required bool forceRealData}) =>
      TransactionReportSnapshotProvider._(argument: forceRealData, from: this);

  @override
  String toString() => r'transactionReportSnapshotProvider';
}

@ProviderFor(transactionList)
const transactionListProvider = TransactionListFamily._();

final class TransactionListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ITransaction>>,
          List<ITransaction>,
          Stream<List<ITransaction>>
        >
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const TransactionListProvider._({
    required TransactionListFamily super.from,
    required bool super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument = this.argument as bool;
    return transactionList(ref, forceRealData: argument);
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

String _$transactionListHash() => r'db42881764e145f5888d2c9aab0f105f54278827';

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

  TransactionListProvider call({required bool forceRealData}) =>
      TransactionListProvider._(argument: forceRealData, from: this);

  @override
  String toString() => r'transactionListProvider';
}

@ProviderFor(transactions)
const transactionsProvider = TransactionsFamily._();

final class TransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ITransaction>>,
          List<ITransaction>,
          Stream<List<ITransaction>>
        >
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const TransactionsProvider._({
    required TransactionsFamily super.from,
    required bool super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument = this.argument as bool;
    return transactions(ref, forceRealData: argument);
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

String _$transactionsHash() => r'e7bdac77e49e750203974771e4eec3e4aa2af7de';

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

  TransactionsProvider call({bool forceRealData = true}) =>
      TransactionsProvider._(argument: forceRealData, from: this);

  @override
  String toString() => r'transactionsProvider';
}

@ProviderFor(transactionItemList)
const transactionItemListProvider = TransactionItemListProvider._();

final class TransactionItemListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionItem>>,
          List<TransactionItem>,
          Stream<List<TransactionItem>>
        >
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionItem>> create(Ref ref) {
    return transactionItemList(ref);
  }
}

String _$transactionItemListHash() =>
    r'615c2480b070c4c7b267d88f4562d02f2bdb4c34';

@ProviderFor(expensesStream)
const expensesStreamProvider = ExpensesStreamFamily._();

final class ExpensesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ITransaction>>,
          List<ITransaction>,
          Stream<List<ITransaction>>
        >
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const ExpensesStreamProvider._({
    required ExpensesStreamFamily super.from,
    required ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    })
    super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    final argument =
        this.argument
            as ({
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

String _$expensesStreamHash() => r'8fd11314a0605d7727e1306728996338ba771db4';

final class ExpensesStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<ITransaction>>,
          ({
            DateTime startDate,
            DateTime endDate,
            String? branchId,
            bool forceRealData,
          })
        > {
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
  }) => ExpensesStreamProvider._(
    argument: (
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    ),
    from: this,
  );

  @override
  String toString() => r'expensesStreamProvider';
}

@ProviderFor(grossProfitStream)
const grossProfitStreamProvider = GrossProfitStreamFamily._();

final class GrossProfitStreamProvider
    extends $FunctionalProvider<AsyncValue<double>, double, Stream<double>>
    with $FutureModifier<double>, $StreamProvider<double> {
  const GrossProfitStreamProvider._({
    required GrossProfitStreamFamily super.from,
    required ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    })
    super.argument,
  }) : super(
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
    final argument =
        this.argument
            as ({
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

String _$grossProfitStreamHash() => r'12c26b454d540ce8b5a8a81cb56b76ec7b8ccc30';

final class GrossProfitStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<double>,
          ({
            DateTime startDate,
            DateTime endDate,
            String? branchId,
            bool forceRealData,
          })
        > {
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
  }) => GrossProfitStreamProvider._(
    argument: (
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    ),
    from: this,
  );

  @override
  String toString() => r'grossProfitStreamProvider';
}

@ProviderFor(netProfitStream)
const netProfitStreamProvider = NetProfitStreamFamily._();

final class NetProfitStreamProvider
    extends $FunctionalProvider<AsyncValue<double>, double, Stream<double>>
    with $FutureModifier<double>, $StreamProvider<double> {
  const NetProfitStreamProvider._({
    required NetProfitStreamFamily super.from,
    required ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    })
    super.argument,
  }) : super(
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
    final argument =
        this.argument
            as ({
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

String _$netProfitStreamHash() => r'd934af19fc3c25ee0bc16ec46bd1a633a71fb3b8';

final class NetProfitStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<double>,
          ({
            DateTime startDate,
            DateTime endDate,
            String? branchId,
            bool forceRealData,
          })
        > {
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
  }) => NetProfitStreamProvider._(
    argument: (
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    ),
    from: this,
  );

  @override
  String toString() => r'netProfitStreamProvider';
}

@ProviderFor(totalIncomeStream)
const totalIncomeStreamProvider = TotalIncomeStreamFamily._();

final class TotalIncomeStreamProvider
    extends $FunctionalProvider<AsyncValue<double>, double, Stream<double>>
    with $FutureModifier<double>, $StreamProvider<double> {
  const TotalIncomeStreamProvider._({
    required TotalIncomeStreamFamily super.from,
    required ({
      DateTime startDate,
      DateTime endDate,
      String? branchId,
      bool forceRealData,
    })
    super.argument,
  }) : super(
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
    final argument =
        this.argument
            as ({
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

String _$totalIncomeStreamHash() => r'fd22078d57b4afb9391c246c2ee5b397e81f0413';

final class TotalIncomeStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<double>,
          ({
            DateTime startDate,
            DateTime endDate,
            String? branchId,
            bool forceRealData,
          })
        > {
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
  }) => TotalIncomeStreamProvider._(
    argument: (
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    ),
    from: this,
  );

  @override
  String toString() => r'totalIncomeStreamProvider';
}

@ProviderFor(pendingTransactionStream)
const pendingTransactionStreamProvider = PendingTransactionStreamFamily._();

final class PendingTransactionStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<ITransaction>,
          ITransaction,
          Stream<ITransaction>
        >
    with $FutureModifier<ITransaction>, $StreamProvider<ITransaction> {
  const PendingTransactionStreamProvider._({
    required PendingTransactionStreamFamily super.from,
    required ({bool isExpense, bool forceRealData}) super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ITransaction> create(Ref ref) {
    final argument = this.argument as ({bool isExpense, bool forceRealData});
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
    r'0fba69b3a7dc8c4ae8da6ec4d3653f3c107a9e0b';

final class PendingTransactionStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<ITransaction>,
          ({bool isExpense, bool forceRealData})
        > {
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
  }) => PendingTransactionStreamProvider._(
    argument: (isExpense: isExpense, forceRealData: forceRealData),
    from: this,
  );

  @override
  String toString() => r'pendingTransactionStreamProvider';
}

@ProviderFor(transactionById)
const transactionByIdProvider = TransactionByIdFamily._();

final class TransactionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<ITransaction?>,
          ITransaction?,
          Stream<ITransaction?>
        >
    with $FutureModifier<ITransaction?>, $StreamProvider<ITransaction?> {
  const TransactionByIdProvider._({
    required TransactionByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transactionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionByIdHash();

  @override
  String toString() {
    return r'transactionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ITransaction?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ITransaction?> create(Ref ref) {
    final argument = this.argument as String;
    return transactionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionByIdHash() => r'4f98047ec2606f7a5a46119389e9fb67168def1f';

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ITransaction?>, String> {
  const TransactionByIdFamily._()
    : super(
        retry: null,
        name: r'transactionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionByIdProvider call(String transactionId) =>
      TransactionByIdProvider._(argument: transactionId, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}
