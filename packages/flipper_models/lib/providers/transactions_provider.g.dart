// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'36a7d8bc2b048b7d15bf0bec0cdf5b30ad944214';

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
    r'79136bc5c6efbcac0f105c0ef570f743aa3d0713';

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
    r'66c1029d77ce311e4972e6835f2c6c6650c74640';

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

String _$expensesStreamHash() => r'4854314e44df0c38869e5ac7649c9fc59c2496a6';

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
  }) {
    return ExpensesStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
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
  }) : this._internal(
          (ref) => expensesStream(
            ref as ExpensesStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
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
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;

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
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

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
}

String _$netProfitStreamHash() => r'65379b57513ada4e739e070f25bfce289fc9a1d7';

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
  }) {
    return NetProfitStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
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
  }) : this._internal(
          (ref) => netProfitStream(
            ref as NetProfitStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
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
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;

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
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

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
}

String _$grossProfitStreamHash() => r'2bcfc75a48a00bb8930f83d532f303bbe9241f40';

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
  }) {
    return GrossProfitStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
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
  }) : this._internal(
          (ref) => grossProfitStream(
            ref as GrossProfitStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
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
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;

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
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

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
}

String _$totalIncomeStreamHash() => r'9a991821d8aa3d9db713a855407c6f30607af810';

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
  }) {
    return TotalIncomeStreamProvider(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
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
  }) : this._internal(
          (ref) => totalIncomeStream(
            ref as TotalIncomeStreamRef,
            startDate: startDate,
            endDate: endDate,
            branchId: branchId,
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
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int? branchId;

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
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

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
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
