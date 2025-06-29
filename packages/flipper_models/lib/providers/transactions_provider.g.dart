// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionListHash() => r'c51c783107e59416dffe9026fbcb734138294c22';

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

/// See also [transactionList].
@ProviderFor(transactionList)
const transactionListProvider = TransactionListFamily();

/// See also [transactionList].
class TransactionListFamily extends Family<AsyncValue<List<ITransaction>>> {
  /// See also [transactionList].
  const TransactionListFamily();

  /// See also [transactionList].
  TransactionListProvider call({
    required bool forceRealData,
  }) {
    return TransactionListProvider(
      forceRealData: forceRealData,
    );
  }

  @override
  TransactionListProvider getProviderOverride(
    covariant TransactionListProvider provider,
  ) {
    return call(
      forceRealData: provider.forceRealData,
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
  String? get name => r'transactionListProvider';
}

/// See also [transactionList].
class TransactionListProvider
    extends AutoDisposeStreamProvider<List<ITransaction>> {
  /// See also [transactionList].
  TransactionListProvider({
    required bool forceRealData,
  }) : this._internal(
          (ref) => transactionList(
            ref as TransactionListRef,
            forceRealData: forceRealData,
          ),
          from: transactionListProvider,
          name: r'transactionListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionListHash,
          dependencies: TransactionListFamily._dependencies,
          allTransitiveDependencies:
              TransactionListFamily._allTransitiveDependencies,
          forceRealData: forceRealData,
        );

  TransactionListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.forceRealData,
  }) : super.internal();

  final bool forceRealData;

  @override
  Override overrideWith(
    Stream<List<ITransaction>> Function(TransactionListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionListProvider._internal(
        (ref) => create(ref as TransactionListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        forceRealData: forceRealData,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ITransaction>> createElement() {
    return _TransactionListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionListProvider &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionListRef on AutoDisposeStreamProviderRef<List<ITransaction>> {
  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _TransactionListProviderElement
    extends AutoDisposeStreamProviderElement<List<ITransaction>>
    with TransactionListRef {
  _TransactionListProviderElement(super.provider);

  @override
  bool get forceRealData => (origin as TransactionListProvider).forceRealData;
}

String _$transactionsHash() => r'9b8885fcae2217e3df1090a23d2db3c84777e4fd';

/// See also [transactions].
@ProviderFor(transactions)
const transactionsProvider = TransactionsFamily();

/// See also [transactions].
class TransactionsFamily extends Family<AsyncValue<List<ITransaction>>> {
  /// See also [transactions].
  const TransactionsFamily();

  /// See also [transactions].
  TransactionsProvider call({
    bool forceRealData = true,
  }) {
    return TransactionsProvider(
      forceRealData: forceRealData,
    );
  }

  @override
  TransactionsProvider getProviderOverride(
    covariant TransactionsProvider provider,
  ) {
    return call(
      forceRealData: provider.forceRealData,
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
  String? get name => r'transactionsProvider';
}

/// See also [transactions].
class TransactionsProvider
    extends AutoDisposeStreamProvider<List<ITransaction>> {
  /// See also [transactions].
  TransactionsProvider({
    bool forceRealData = true,
  }) : this._internal(
          (ref) => transactions(
            ref as TransactionsRef,
            forceRealData: forceRealData,
          ),
          from: transactionsProvider,
          name: r'transactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionsHash,
          dependencies: TransactionsFamily._dependencies,
          allTransitiveDependencies:
              TransactionsFamily._allTransitiveDependencies,
          forceRealData: forceRealData,
        );

  TransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.forceRealData,
  }) : super.internal();

  final bool forceRealData;

  @override
  Override overrideWith(
    Stream<List<ITransaction>> Function(TransactionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionsProvider._internal(
        (ref) => create(ref as TransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        forceRealData: forceRealData,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ITransaction>> createElement() {
    return _TransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsProvider &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionsRef on AutoDisposeStreamProviderRef<List<ITransaction>> {
  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _TransactionsProviderElement
    extends AutoDisposeStreamProviderElement<List<ITransaction>>
    with TransactionsRef {
  _TransactionsProviderElement(super.provider);

  @override
  bool get forceRealData => (origin as TransactionsProvider).forceRealData;
}

String _$transactionItemListHash() =>
    r'ec1b3cabdc58cf23b937071ddcfb60abb93df1d3';

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
    r'e9d20c5cab6b53d6ef52df3d99ed4032248fd4ba';

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
    bool forceRealData = true,
  }) {
    return PendingTransactionStreamProvider(
      isExpense: isExpense,
      forceRealData: forceRealData,
    );
  }

  @override
  PendingTransactionStreamProvider getProviderOverride(
    covariant PendingTransactionStreamProvider provider,
  ) {
    return call(
      isExpense: provider.isExpense,
      forceRealData: provider.forceRealData,
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
    bool forceRealData = true,
  }) : this._internal(
          (ref) => pendingTransactionStream(
            ref as PendingTransactionStreamRef,
            isExpense: isExpense,
            forceRealData: forceRealData,
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
          forceRealData: forceRealData,
        );

  PendingTransactionStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isExpense,
    required this.forceRealData,
  }) : super.internal();

  final bool isExpense;
  final bool forceRealData;

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
        forceRealData: forceRealData,
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
        other.isExpense == isExpense &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isExpense.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PendingTransactionStreamRef
    on AutoDisposeStreamProviderRef<ITransaction> {
  /// The parameter `isExpense` of this provider.
  bool get isExpense;

  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _PendingTransactionStreamProviderElement
    extends AutoDisposeStreamProviderElement<ITransaction>
    with PendingTransactionStreamRef {
  _PendingTransactionStreamProviderElement(super.provider);

  @override
  bool get isExpense => (origin as PendingTransactionStreamProvider).isExpense;
  @override
  bool get forceRealData =>
      (origin as PendingTransactionStreamProvider).forceRealData;
}

String _$expensesStreamHash() => r'ffdf5e52919c19ffcc41bf1c3ab7c7062bc610dc';

/// See also [expensesStream].
@ProviderFor(expensesStream)
const expensesStreamProvider = ExpensesStreamFamily();

/// See also [expensesStream].
class ExpensesStreamFamily extends Family<AsyncValue<List<ITransaction>>> {
  /// See also [expensesStream].
  const ExpensesStreamFamily();

  /// See also [expensesStream].
  ExpensesStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) {
    return ExpensesStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    );
  }

  @override
  ExpensesStreamProvider getProviderOverride(
    covariant ExpensesStreamProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      branchId: provider.branchId,
      forceRealData: provider.forceRealData,
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
  String? get name => r'expensesStreamProvider';
}

/// See also [expensesStream].
class ExpensesStreamProvider
    extends AutoDisposeStreamProvider<List<ITransaction>> {
  /// See also [expensesStream].
  ExpensesStreamProvider({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) : this._internal(
          (ref) => expensesStream(
            ref as ExpensesStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
            forceRealData: forceRealData,
          ),
          from: expensesStreamProvider,
          name: r'expensesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expensesStreamHash,
          dependencies: ExpensesStreamFamily._dependencies,
          allTransitiveDependencies:
              ExpensesStreamFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          branchId: branchId,
          forceRealData: forceRealData,
        );

  ExpensesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.branchId,
    required this.forceRealData,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;
  final bool forceRealData;

  @override
  Override overrideWith(
    Stream<List<ITransaction>> Function(ExpensesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesStreamProvider._internal(
        (ref) => create(ref as ExpensesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ITransaction>> createElement() {
    return _ExpensesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesStreamProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.branchId == branchId &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesStreamRef on AutoDisposeStreamProviderRef<List<ITransaction>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `branchId` of this provider.
  int? get branchId;

  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _ExpensesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ITransaction>>
    with ExpensesStreamRef {
  _ExpensesStreamProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as ExpensesStreamProvider).startDate;
  @override
  DateTime get endDate => (origin as ExpensesStreamProvider).endDate;
  @override
  int? get branchId => (origin as ExpensesStreamProvider).branchId;
  @override
  bool get forceRealData => (origin as ExpensesStreamProvider).forceRealData;
}

String _$netProfitStreamHash() => r'95aa5045a5ab14ceb7c0f18c22e521faf2fd9741';

/// See also [netProfitStream].
@ProviderFor(netProfitStream)
const netProfitStreamProvider = NetProfitStreamFamily();

/// See also [netProfitStream].
class NetProfitStreamFamily extends Family<AsyncValue<double>> {
  /// See also [netProfitStream].
  const NetProfitStreamFamily();

  /// See also [netProfitStream].
  NetProfitStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) {
    return NetProfitStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    );
  }

  @override
  NetProfitStreamProvider getProviderOverride(
    covariant NetProfitStreamProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      branchId: provider.branchId,
      forceRealData: provider.forceRealData,
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
  String? get name => r'netProfitStreamProvider';
}

/// See also [netProfitStream].
class NetProfitStreamProvider extends AutoDisposeStreamProvider<double> {
  /// See also [netProfitStream].
  NetProfitStreamProvider({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) : this._internal(
          (ref) => netProfitStream(
            ref as NetProfitStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
            forceRealData: forceRealData,
          ),
          from: netProfitStreamProvider,
          name: r'netProfitStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$netProfitStreamHash,
          dependencies: NetProfitStreamFamily._dependencies,
          allTransitiveDependencies:
              NetProfitStreamFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          branchId: branchId,
          forceRealData: forceRealData,
        );

  NetProfitStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.branchId,
    required this.forceRealData,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;
  final bool forceRealData;

  @override
  Override overrideWith(
    Stream<double> Function(NetProfitStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NetProfitStreamProvider._internal(
        (ref) => create(ref as NetProfitStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<double> createElement() {
    return _NetProfitStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NetProfitStreamProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.branchId == branchId &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NetProfitStreamRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `branchId` of this provider.
  int? get branchId;

  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _NetProfitStreamProviderElement
    extends AutoDisposeStreamProviderElement<double> with NetProfitStreamRef {
  _NetProfitStreamProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as NetProfitStreamProvider).startDate;
  @override
  DateTime get endDate => (origin as NetProfitStreamProvider).endDate;
  @override
  int? get branchId => (origin as NetProfitStreamProvider).branchId;
  @override
  bool get forceRealData => (origin as NetProfitStreamProvider).forceRealData;
}

String _$grossProfitStreamHash() => r'9b5e0d6fcf95c515d27c05e6e27d13aadb946eb9';

/// See also [grossProfitStream].
@ProviderFor(grossProfitStream)
const grossProfitStreamProvider = GrossProfitStreamFamily();

/// See also [grossProfitStream].
class GrossProfitStreamFamily extends Family<AsyncValue<double>> {
  /// See also [grossProfitStream].
  const GrossProfitStreamFamily();

  /// See also [grossProfitStream].
  GrossProfitStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) {
    return GrossProfitStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    );
  }

  @override
  GrossProfitStreamProvider getProviderOverride(
    covariant GrossProfitStreamProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      branchId: provider.branchId,
      forceRealData: provider.forceRealData,
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
  String? get name => r'grossProfitStreamProvider';
}

/// See also [grossProfitStream].
class GrossProfitStreamProvider extends AutoDisposeStreamProvider<double> {
  /// See also [grossProfitStream].
  GrossProfitStreamProvider({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) : this._internal(
          (ref) => grossProfitStream(
            ref as GrossProfitStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
            forceRealData: forceRealData,
          ),
          from: grossProfitStreamProvider,
          name: r'grossProfitStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$grossProfitStreamHash,
          dependencies: GrossProfitStreamFamily._dependencies,
          allTransitiveDependencies:
              GrossProfitStreamFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          branchId: branchId,
          forceRealData: forceRealData,
        );

  GrossProfitStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.branchId,
    required this.forceRealData,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;
  final bool forceRealData;

  @override
  Override overrideWith(
    Stream<double> Function(GrossProfitStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GrossProfitStreamProvider._internal(
        (ref) => create(ref as GrossProfitStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<double> createElement() {
    return _GrossProfitStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GrossProfitStreamProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.branchId == branchId &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GrossProfitStreamRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `branchId` of this provider.
  int? get branchId;

  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _GrossProfitStreamProviderElement
    extends AutoDisposeStreamProviderElement<double> with GrossProfitStreamRef {
  _GrossProfitStreamProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as GrossProfitStreamProvider).startDate;
  @override
  DateTime get endDate => (origin as GrossProfitStreamProvider).endDate;
  @override
  int? get branchId => (origin as GrossProfitStreamProvider).branchId;
  @override
  bool get forceRealData => (origin as GrossProfitStreamProvider).forceRealData;
}

String _$totalIncomeStreamHash() => r'e91d2c42a9af82d3e2e551211ba3863d29fe925f';

/// See also [totalIncomeStream].
@ProviderFor(totalIncomeStream)
const totalIncomeStreamProvider = TotalIncomeStreamFamily();

/// See also [totalIncomeStream].
class TotalIncomeStreamFamily extends Family<AsyncValue<double>> {
  /// See also [totalIncomeStream].
  const TotalIncomeStreamFamily();

  /// See also [totalIncomeStream].
  TotalIncomeStreamProvider call({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) {
    return TotalIncomeStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    );
  }

  @override
  TotalIncomeStreamProvider getProviderOverride(
    covariant TotalIncomeStreamProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      branchId: provider.branchId,
      forceRealData: provider.forceRealData,
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
  String? get name => r'totalIncomeStreamProvider';
}

/// See also [totalIncomeStream].
class TotalIncomeStreamProvider extends AutoDisposeStreamProvider<double> {
  /// See also [totalIncomeStream].
  TotalIncomeStreamProvider({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    bool forceRealData = true,
  }) : this._internal(
          (ref) => totalIncomeStream(
            ref as TotalIncomeStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
            forceRealData: forceRealData,
          ),
          from: totalIncomeStreamProvider,
          name: r'totalIncomeStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalIncomeStreamHash,
          dependencies: TotalIncomeStreamFamily._dependencies,
          allTransitiveDependencies:
              TotalIncomeStreamFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          branchId: branchId,
          forceRealData: forceRealData,
        );

  TotalIncomeStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.branchId,
    required this.forceRealData,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;
  final bool forceRealData;

  @override
  Override overrideWith(
    Stream<double> Function(TotalIncomeStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalIncomeStreamProvider._internal(
        (ref) => create(ref as TotalIncomeStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<double> createElement() {
    return _TotalIncomeStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalIncomeStreamProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.branchId == branchId &&
        other.forceRealData == forceRealData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, forceRealData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TotalIncomeStreamRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `branchId` of this provider.
  int? get branchId;

  /// The parameter `forceRealData` of this provider.
  bool get forceRealData;
}

class _TotalIncomeStreamProviderElement
    extends AutoDisposeStreamProviderElement<double> with TotalIncomeStreamRef {
  _TotalIncomeStreamProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as TotalIncomeStreamProvider).startDate;
  @override
  DateTime get endDate => (origin as TotalIncomeStreamProvider).endDate;
  @override
  int? get branchId => (origin as TotalIncomeStreamProvider).branchId;
  @override
  bool get forceRealData => (origin as TotalIncomeStreamProvider).forceRealData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
