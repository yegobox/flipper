import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart';

/// A utility class for generating dummy transaction data for testing and development.
class DummyTransactionGenerator {
  static final _faker = Faker();
  static final _uuid = const Uuid();

  /// Generates a list of dummy transactions with associated items
  /// [count] - Number of transactions to generate
  /// [branchId] - Branch ID for the transactions
  /// [withItems] - Whether to generate transaction items for each transaction
  static List<ITransaction> generateDummyTransactions({
    int count = 10,
    required int branchId,
    bool withItems = true,
    String? status,
    String? transactionType,
  }) {
    final transactions = <ITransaction>[];

    for (var i = 0; i < count; i++) {
      final transaction = _generateDummyTransaction(
        branchId: branchId,
        status: status,
        transactionType: transactionType,
      );

      if (withItems) {
        final itemCount = _faker.randomGenerator.integer(5, min: 1);
        final items = generateDummyTransactionItems(
          transactionId: transaction.id,
          count: itemCount,
          branchId: branchId,
        );

        // Calculate totals based on items
        final subTotal =
            items.fold(0.0, (sum, item) => sum + (item.taxblAmt ?? 0.0));
        final taxAmount =
            items.fold(0.0, (sum, item) => sum + (item.taxAmt ?? 0.0));
        final total = subTotal + taxAmount;

        transaction.subTotal = subTotal;
        transaction.taxAmount = taxAmount;
        transaction.cashReceived = total;
        transaction.customerChangeDue = 0.0;

        // Add items to transaction (assuming the transaction model has a way to store items)
        // This might need adjustment based on your actual model structure
        transaction.items = items;
      }

      transactions.add(transaction);
    }

    return transactions;
  }

  /// Generates a single dummy transaction
  static ITransaction _generateDummyTransaction({
    required int branchId,
    String? status,
    String? transactionType,
  }) {
    final now = DateTime.now();
    final randomDays = _faker.randomGenerator.integer(30, min: 1);
    final transactionDate = now.subtract(Duration(days: randomDays));
    final transactionId =
        'trx_${DateTime.now().millisecondsSinceEpoch}_${_faker.randomGenerator.integer(9999)}';

    return ITransaction(
      id: transactionId,
      branchId: branchId,
      status: status ??
          _faker.randomGenerator.element(
              ['01', '02', '04']), // Assuming these are valid status codes
      transactionType: transactionType ??
          _faker.randomGenerator.element(['SALE', 'PURCHASE', 'RETURN']),
      subTotal: 0.0, // Will be updated if items are added
      taxAmount: 0.0, // Will be updated if items are added
      cashReceived: 0.0, // Will be updated if items are added

      customerChangeDue: 0.0,
      isExpense: false,
      isIncome: true,
      isOriginalTransaction: true,
      receiptType:
          _faker.randomGenerator.element(['NS', 'TR', 'NR', 'CS', 'CR']),
      paymentType: _faker.randomGenerator.element(['CASH', 'CARD', 'TRANSFER']),
      customerId: _faker.randomGenerator.boolean() ? _uuid.v4() : null,
      customerName:
          _faker.randomGenerator.boolean() ? _faker.person.name() : null,
      note: _faker.randomGenerator.boolean() ? _faker.lorem.sentence() : null,
      createdAt: transactionDate,
      updatedAt: transactionDate,
      lastTouched: now,
      // Add other required fields from ITransaction
    );
  }

  /// Generates dummy transaction items
  static List<TransactionItem> generateDummyTransactionItems({
    required String transactionId,
    required int branchId,
    int count = 1,
  }) {
    final items = <TransactionItem>[];

    for (var i = 0; i < count; i++) {
      final quantity = _faker.randomGenerator.decimal(min: 1, scale: 10);
      final price = _faker.randomGenerator.decimal(min: 10, scale: 1000);
      final discountRate = _faker.randomGenerator.decimal(min: 0, scale: 30);
      final discountAmount = (price * quantity * discountRate) / 100;
      final taxableAmount = (price * quantity) - discountAmount;
      final taxRate = 18.0; // Assuming 18% tax rate
      final taxAmount = (taxableAmount * taxRate) / 100;
      final totalAmount = taxableAmount + taxAmount;
      final variantId = const Uuid().v4();
      final itemId = const Uuid().v4();

      items.add(
        TransactionItem(
          id: itemId,
          name: '${_faker.food.cuisine()} ${_faker.food.dish()}',
          transactionId: transactionId,
          variantId: variantId,
          qty: quantity,
          price: price,
          branchId: branchId.toString(),
          remainingStock: _faker.randomGenerator.decimal(min: 0, scale: 1000),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          prc: price,
          discount: discountAmount,
          dcRt: discountRate,
          dcAmt: discountAmount,
          taxblAmt: taxableAmount,
          taxAmt: taxAmount,
          totAmt: totalAmount,
          itemSeq: _faker.randomGenerator.integer(999999),
          isrccCd: _faker.randomGenerator.string(5),
          isrccNm: _faker.randomGenerator.string(5),
          isrcRt: _faker.randomGenerator.integer(100),
          isrcAmt: _faker.randomGenerator.integer(100),
          taxTyCd: _faker.randomGenerator.string(5),
          bcd: _faker.randomGenerator.string(5),
          itemClsCd: _faker.randomGenerator.string(5),
          itemTyCd: _faker.randomGenerator.string(5),
          itemStdNm: _faker.randomGenerator.string(5),
          orgnNatCd: _faker.randomGenerator.string(5),
          pkg: _faker.randomGenerator.integer(100),
          itemCd: _faker.randomGenerator.string(5),
          pkgUnitCd: _faker.randomGenerator.string(5),
          qtyUnitCd: _faker.randomGenerator.string(5),
          itemNm: '${_faker.food.cuisine()} ${_faker.food.dish()}',
          splyAmt: _faker.randomGenerator.decimal(min: 1, scale: 1000),
          tin: _faker.randomGenerator.integer(999999),
          bhfId: _faker.randomGenerator.string(5),
          dftPrc: _faker.randomGenerator.decimal(min: 1, scale: 1000),
          addInfo: _faker.randomGenerator.string(5),
          isrcAplcbYn: _faker.randomGenerator.string(5),
          useYn: _faker.randomGenerator.string(5),
          regrId: _faker.randomGenerator.string(5),
          regrNm: _faker.randomGenerator.string(5),
          modrId: _faker.randomGenerator.string(5),
          modrNm: _faker.randomGenerator.string(5),
          lastTouched: DateTime.now(),
        ),
      );
    }

    return items;
  }
}
