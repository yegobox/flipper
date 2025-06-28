import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart';

// Helper function to format date as YYYYMMDD
String _formatDate(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year$month$day';
}

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
        'trx_${now.millisecondsSinceEpoch}_${_faker.randomGenerator.integer(9999)}';

    // Generate a receipt number between 1000 and 9999
    final receiptNumber = 1000 + _faker.randomGenerator.integer(9000);

    // Generate a transaction number in format TRX-YYYYMMDD-XXXXX
    final transactionNum =
        'TRX-${_formatDate(now)}-${_faker.randomGenerator.integer(99999).toString().padLeft(5, '0')}';

    return ITransaction(
      id: transactionId,
      branchId: branchId,
      status: status ?? '01', // Default to '01' for completed status
      transactionType: transactionType ?? 'SALE',
      subTotal: 0.0, // Will be updated if items are added
      taxAmount: 0.0, // Will be updated if items are added
      cashReceived: 0.0, // Will be updated if items are added
      customerChangeDue: 0.0,
      isExpense: false,
      isIncome: true,
      isOriginalTransaction: true,
      receiptType: 'NS', // Normal sale receipt type
      paymentType: 'CASH',
      customerId: _faker.randomGenerator.boolean() ? _uuid.v4() : null,
      customerName: _faker.randomGenerator.boolean()
          ? _faker.person.name()
          : 'Walk-in Customer',
      note: _faker.randomGenerator.boolean() ? _faker.lorem.sentence() : null,
      createdAt: transactionDate,
      updatedAt: now,
      lastTouched: now,
      transactionNumber: transactionNum,
      receiptNumber: receiptNumber,
      totalReceiptNumber: 1,
      invoiceNumber: receiptNumber,
      isDigitalReceiptGenerated: true,
      ebmSynced: true,
      isRefunded: false,
      isLoan: false,
      isAutoBilled: false,
      numberOfItems: 0, // Will be updated if items are added
      discountAmount: 0.0,
    );
  }

  /// Generates dummy transaction items
  static List<TransactionItem> generateDummyTransactionItems({
    required String transactionId,
    required int branchId,
    int count = 1,
  }) {
    final items = <TransactionItem>[];
    final now = DateTime.now();
    final branchIdStr = branchId.toString();

    for (var i = 0; i < count; i++) {
      // Generate random values within ranges
      final quantity =
          _faker.randomGenerator.decimal(scale: 2) * 9 + 1; // 1.0 - 10.0
      final price =
          _faker.randomGenerator.decimal(scale: 2) * 990 + 10; // 10.0 - 1000.0
      final discountRate =
          _faker.randomGenerator.decimal(scale: 2) * 30; // 0.0 - 30.0
      final discountAmount = (price * quantity * discountRate) / 100;
      final taxableAmount = (price * quantity) - discountAmount;
      final taxRate = 18.0; // 18% tax rate
      final taxAmount = (taxableAmount * taxRate) / 100;
      final totalAmount = taxableAmount + taxAmount;
      final variantId =
          'var_${now.millisecondsSinceEpoch}_${_faker.randomGenerator.integer(9999)}';
      final itemId =
          'item_${now.millisecondsSinceEpoch}_${_faker.randomGenerator.integer(9999)}';
      final itemName = '${_faker.food.cuisine()} ${_faker.food.dish()}';
      final itemCode =
          'ITM-${_faker.randomGenerator.string(6, min: 6).toUpperCase()}';
      final tin = _faker.randomGenerator.integer(999999);

      items.add(
        TransactionItem(
          id: itemId,
          name: itemName,
          transactionId: transactionId,
          variantId: variantId,
          qty: quantity,
          price: price,
          branchId: branchIdStr,
          remainingStock:
              _faker.randomGenerator.decimal(scale: 2) * 1000, // 0.0 - 1000.0
          createdAt: now,
          updatedAt: now,
          prc: price,
          discount: discountAmount,
          dcRt: discountRate,
          dcAmt: discountAmount,
          taxblAmt: taxableAmount,
          taxAmt: taxAmount,
          totAmt: totalAmount,
          itemSeq: i + 1,
          isrccCd: '0',
          isrccNm: 'Standard',
          isrcRt: 0,
          isrcAmt: 0,
          taxTyCd: 'VAT',
          bcd: '0',
          itemClsCd: 'GENERAL',
          itemTyCd: 'PRODUCT',
          itemStdNm: itemName,
          orgnNatCd: 'TZ',
          pkg: 1,
          itemCd: itemCode,
          pkgUnitCd: 'PCS',
          qtyUnitCd: 'PCS',
          itemNm: itemName,
          splyAmt: taxableAmount,
          tin: tin,
          bhfId: '01',
          dftPrc: price,
          addInfo: '',
          isrcAplcbYn: 'N',
          useYn: 'Y',
          regrId: 'system',
          regrNm: 'System',
          modrId: 'system',
          modrNm: 'System',
          lastTouched: now,
          isRefunded: false,
          ebmSynced: true,
          partOfComposite: false,
          compositePrice: 0.0,
        ),
      );
    }

    return items;
  }
}
