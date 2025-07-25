import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/notice_interface.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;

abstract class TaxApi implements NoticeInterface {
  Future<RwApiResponse> saveStockMaster(
      {required Variant variant, required String URI, num? approvedQty});

  Future<bool> stockIn(
      {required Map<String, Object?> json,
      required String URI,
      required String sarTyCd});
  Future<bool> stockOut(
      {required Map<String, Object?> json,
      required String URI,
      required String sarTyCd});
  Future<RwApiResponse> savePurchases({
    required Purchase item,
    required String URI,
    required String bhfId,
    String rcptTyCd = "S",
    required List<Variant> variants,
    required Business business,
    required String pchsSttsCd,
  });
  Future<RwApiResponse> saveStockItems(
      {required ITransaction transaction,
      required String tinNumber,
      required String bhFId,
      String? customerName,
      String? custTin,
      String? regTyCd = "A",
      //sarTyCd 11 is for sale
      required String sarTyCd,
      bool isStockIn = false,
      String? custBhfId,
      required double totalSupplyPrice,
      required double totalvat,
      required double totalAmount,
      required String remark,
      required DateTime ocrnDt,
      /// when doing sale we send it as invoice no otherwise for import and purchase we send 
      String? sarNo,
      required String URI, num? invoiceNumber, num? approvedQty});
  Future<RwApiResponse> saveCustomer({required ICustomer customer, required String URI});
  Future<BusinessInfo> initApi(
      {required String tinNumber,
      required String bhfId,
      required String dvcSrlNo,
      required String URI});
  Future<bool> selectItems(
      {required String tinNumber,
      required String bhfId,
      String lastReqDt,
      required String URI});

  Future<RwApiResponse> generateReceiptSignature(
      {required ITransaction transaction,
      required String receiptType,
      required brick.Counter counter,
      String? purchaseCode,
      required String URI,
      required String salesSttsCd,
      int? originalInvoiceNumber,
      String? sarTyCd,
      required DateTime timeToUser});
  Future<RwApiResponse> saveItem(
      {required Variant variation, required String URI});

  // Future<RwApiResponse> savePurchases(
  //     {required SaleList item, required String URI});
  Future<RwApiResponse> selectTrnsPurchaseSales(
      {required int tin,
      required String bhfId,
      required String lastReqDt,
      required String URI});

  Future<RwApiResponse> selectImportItems(
      {required int tin,
      required String bhfId,
      required String lastReqDt,
      required String URI});

  Future<RwApiResponse> updateImportItems(
      {required Variant item, required String URI});

  Future<List<Configurations>> taxConfigs({required int branchId});
}
