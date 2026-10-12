import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:supabase_models/brick/models/notice.model.dart';

/// Keeps every RRA call off the wire in local mode, where EBM is unavailable.
///
/// `isTaxEnabled` already returns false in local mode, but stock I/O, branch
/// transfer, production, recount, hotel rooms and the cron jobs reach
/// [TaxApi] without asking it. Calls fail the way an unreachable tax server
/// does (never a fake success), so nothing is marked as reported to RRA.
/// The flag is read per call: the service is a lazy singleton and the mode can
/// change during a session (signup, opt-in).
class LocalModeTaxGuard implements TaxApi {
  LocalModeTaxGuard(this._inner);

  final TaxApi _inner;

  static const unavailableCode = 'LOCAL_MODE';

  static RwApiResponse _unavailable() => RwApiResponse(
    resultCd: unavailableCode,
    resultMsg: 'EBM is not available in offline mode',
  );

  @override
  Future<RwApiResponse> saveStockMaster({
    required Variant variant,
    required String URI,
    num? approvedQty,
    double? stockMasterQty,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.saveStockMaster(
      variant: variant,
      URI: URI,
      approvedQty: approvedQty,
      stockMasterQty: stockMasterQty,
    );
  }

  @override
  Future<bool> stockIn({
    required Map<String, Object?> json,
    required String URI,
    required String sarTyCd,
  }) async {
    if (LocalMode.isOn) return false;
    return _inner.stockIn(json: json, URI: URI, sarTyCd: sarTyCd);
  }

  @override
  Future<bool> stockOut({
    required Map<String, Object?> json,
    required String URI,
    required String sarTyCd,
  }) async {
    if (LocalMode.isOn) return false;
    return _inner.stockOut(json: json, URI: URI, sarTyCd: sarTyCd);
  }

  @override
  Future<RwApiResponse> savePurchases({
    required Purchase item,
    required String URI,
    required String bhfId,
    String rcptTyCd = "S",
    String regTyCd = "A",
    required List<Variant> variants,
    required Business business,
    required String pchsSttsCd,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.savePurchases(
      item: item,
      URI: URI,
      bhfId: bhfId,
      rcptTyCd: rcptTyCd,
      regTyCd: regTyCd,
      variants: variants,
      business: business,
      pchsSttsCd: pchsSttsCd,
    );
  }

  @override
  Future<RwApiResponse> saveStockItems({
    required List<TransactionItem> items,
    bool updateMaster = true,
    required String tinNumber,
    required String bhFId,
    String? customerName,
    String? custTin,
    String? regTyCd = "A",
    required String sarTyCd,
    bool isStockIn = false,
    String? custBhfId,
    required double totalSupplyPrice,
    required double totalvat,
    required double totalAmount,
    required String remark,
    required DateTime ocrnDt,
    String? sarNo,
    required String URI,
    num? invoiceNumber,
    num? approvedQty,
    bool includeCustomerFields = false,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.saveStockItems(
      items: items,
      updateMaster: updateMaster,
      tinNumber: tinNumber,
      bhFId: bhFId,
      customerName: customerName,
      custTin: custTin,
      regTyCd: regTyCd,
      sarTyCd: sarTyCd,
      isStockIn: isStockIn,
      custBhfId: custBhfId,
      totalSupplyPrice: totalSupplyPrice,
      totalvat: totalvat,
      totalAmount: totalAmount,
      remark: remark,
      ocrnDt: ocrnDt,
      sarNo: sarNo,
      URI: URI,
      invoiceNumber: invoiceNumber,
      approvedQty: approvedQty,
      includeCustomerFields: includeCustomerFields,
    );
  }

  @override
  Future<RwApiResponse> saveCustomer({
    required ICustomer customer,
    required String URI,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.saveCustomer(customer: customer, URI: URI);
  }

  @override
  Future<BusinessInfo> initApi({
    required String tinNumber,
    required String bhfId,
    required String dvcSrlNo,
    required String URI,
  }) async {
    if (LocalMode.isOn) {
      throw StateError('EBM is not available in offline mode');
    }
    return _inner.initApi(
      tinNumber: tinNumber,
      bhfId: bhfId,
      dvcSrlNo: dvcSrlNo,
      URI: URI,
    );
  }

  @override
  Future<bool> selectItems({
    required String tinNumber,
    required String bhfId,
    String? lastReqDt,
    required String URI,
  }) async {
    if (LocalMode.isOn) return false;
    // RWTax fills in "now" when lastReqDt is omitted; forward it only if given.
    return lastReqDt == null
        ? _inner.selectItems(tinNumber: tinNumber, bhfId: bhfId, URI: URI)
        : _inner.selectItems(
            tinNumber: tinNumber,
            bhfId: bhfId,
            lastReqDt: lastReqDt,
            URI: URI,
          );
  }

  @override
  Future<RwApiResponse> generateReceiptSignature({
    required ITransaction transaction,
    required String receiptType,
    String? purchaseCode,
    required String URI,
    required String salesSttsCd,
    int? originalInvoiceNumber,
    String? sarTyCd,
    String? custMblNo,
    required String customerName,
    Customer? customer,
    required DateTime timeToUser,
    List<TransactionItem>? preloadedItems,
    bool deferStockSync = false,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.generateReceiptSignature(
      transaction: transaction,
      receiptType: receiptType,
      purchaseCode: purchaseCode,
      URI: URI,
      salesSttsCd: salesSttsCd,
      originalInvoiceNumber: originalInvoiceNumber,
      sarTyCd: sarTyCd,
      custMblNo: custMblNo,
      customerName: customerName,
      customer: customer,
      timeToUser: timeToUser,
      preloadedItems: preloadedItems,
      deferStockSync: deferStockSync,
    );
  }

  @override
  Future<void> syncStockAfterSuccessfulSaveSales({
    required String receiptType,
    required List<TransactionItem> items,
    required ITransaction transaction,
    required int highestInvcNo,
    String? sarTyCd,
  }) async {
    if (LocalMode.isOn) return;
    return _inner.syncStockAfterSuccessfulSaveSales(
      receiptType: receiptType,
      items: items,
      transaction: transaction,
      highestInvcNo: highestInvcNo,
      sarTyCd: sarTyCd,
    );
  }

  @override
  Future<RwApiResponse> saveItem({
    required Variant variation,
    required String URI,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.saveItem(variation: variation, URI: URI);
  }

  @override
  Future<RwApiResponse> selectTrnsPurchaseSales({
    required int tin,
    required String bhfId,
    required String lastReqDt,
    required String URI,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.selectTrnsPurchaseSales(
      tin: tin,
      bhfId: bhfId,
      lastReqDt: lastReqDt,
      URI: URI,
    );
  }

  @override
  Future<RwApiResponse> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastReqDt,
    required String URI,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.selectImportItems(
      tin: tin,
      bhfId: bhfId,
      lastReqDt: lastReqDt,
      URI: URI,
    );
  }

  @override
  Future<RwApiResponse> updateImportItems({
    required Variant item,
    required String URI,
  }) async {
    if (LocalMode.isOn) return _unavailable();
    return _inner.updateImportItems(item: item, URI: URI);
  }

  @override
  Future<List<Configurations>> taxConfigs({required String branchId}) async {
    if (LocalMode.isOn) return const [];
    return _inner.taxConfigs(branchId: branchId);
  }

  // Notices are stored locally, so reading them stays allowed.
  @override
  Future<List<Notice>> notices({required String branchId}) =>
      _inner.notices(branchId: branchId);

  @override
  Future<List<Notice>> fetchNotices({required String URI}) async {
    if (LocalMode.isOn) return const [];
    return _inner.fetchNotices(URI: URI);
  }
}
