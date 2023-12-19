import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/helpers/stack.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';

class KeyPadService with ListenableServiceMixin {
  final _key = ReactiveValue<String>("0.00");
  Stack stack = Stack<String>();

  final _quantity = ReactiveValue<double>(1.0);

  get quantity => _quantity.value;

  String get key => _key.value;

  final _countTransactionItems = ReactiveValue<int>(0);

  int get countTransactionItems => _countTransactionItems.value;

  final _amountTotal = ReactiveValue<double>(0.00);

  double get amountTotal => _amountTotal.value;

  final _check = ReactiveValue<String>('0');

  String get check => _check.value;

  final _cashReceived = ReactiveValue<double>(0.00);

  get cashReceived => _cashReceived.value;

  void addKey(String key) {
    stack.push(key);
    _key.value = stack.list.join('');
  }

  setAmount({required double amount}) {
    _amountTotal.value = amount;
  }

  setCashReceived({required double amount}) {
    _cashReceived.value = amount;
    notifyListeners();
  }

  void toggleCheckbox({required String variantId}) {
    _check.value = variantId;
  }

  /// all the time we have one transaction being processed at the time.
  /// one transaction can have multiple transaction items.
  final _transaction = ReactiveValue<ITransaction?>(null);

  ITransaction? get transaction => _transaction.value;

  final _totalPayable = ReactiveValue<double>(0.00);
  double get totalPayable => _totalPayable.value;
  void setTotalPayable({required double amount}) {
    _totalPayable.value = amount;
  }

  final _totalDiscount = ReactiveValue<double>(0.00);
  double get totalDiscount => _totalDiscount.value;
  void setTotalDiscount({required double amount}) {
    _totalDiscount.value = amount;
  }

  void setTransaction(ITransaction? transaction) async {
    if (transaction != null) {
      _transaction.value = transaction;
    } else {
      _transaction.value = null;
    }
  }

  /// transaction can not be more than 1 lenght i.e at one instance
  /// we have one transaction but an transaction can have more than 1 transactionitem(s)
  /// it is in this recard in application anywhere else it's okay to access transactions[0]
  Future<ITransaction?> getPendingTransaction({required int branchId}) async {
    ITransaction? transaction = await ProxyService.isar.pendingTransaction(
        branchId: branchId, transactionType: TransactionType.custom);

    if (transaction != null) {
      List<TransactionItem> items = await ProxyService.isar.transactionItems(
          transactionId: transaction.id,
          doneWithTransaction: false,
          active: true);
      _countTransactionItems.value = items.length;
    }
    _transaction.value = transaction;
    return transaction;
  }

  /// this function update _transactions.value the same as getTransactions but this takes id of the transaction we want
  /// it is very important to not fonfuse these functions. later on.
  Future<ITransaction?> getTransactionById({required String id}) async {
    ITransaction? od = await ProxyService.isar.getTransactionById(id: id);
    List<TransactionItem> transactionItems = await ProxyService.isar
        .getTransactionItemsByTransactionId(transactionId: od!.id);
    _countTransactionItems.value = transactionItems.length;

    _transaction.value = od;
    return _transaction.value!;
  }

  void reset() {
    _key.value = '0.0';
    while (stack.isNotEmpty) {
      stack.pop();
    }
    notifyListeners();
  }

  void increaseQty({required bool custom, double? qty}) {
    if (custom) {
      _quantity.value = 0;
      _quantity.value = qty ?? 1.0;
    } else {
      _quantity.value++;
      notifyListeners();
    }
  }

  /// can not set -1 quantity
  void decreaseQty() {
    if (_quantity.value > 0) {
      _quantity.value--;
    }
    if (_quantity.value == 0) {
      _quantity.value = 1;
    }
    notifyListeners();
  }

  /// before I used to remove the last written digit
  /// but with new structure the clear or + button set the key back to 0.0
  /// therefore there is no reason to use pop strategy but I am keeping the code
  /// here for later reference.
  void pop() {
    if (stack.isNotEmpty && stack.length > 1) {
      stack.pop();
      _key.value = stack.list.join('');
    } else if (stack.isNotEmpty) {
      stack.pop();
      _key.value = '0.0';
    }
  }

  //increase quantity

  KeyPadService() {
    listenToReactiveValues([
      _key,
      _transaction,
      _countTransactionItems,
      _quantity,
      _amountTotal,
      _check,
      _cashReceived,
      _totalPayable,
      _totalDiscount
    ]);
  }
}
