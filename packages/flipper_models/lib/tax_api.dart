import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart' as api;
import 'package:supabase_models/brick/models/all_models.dart' as brick;

abstract class TaxApi {
  Future<RwApiResponse> saveStockMaster(
      {required IStock stock, required IVariant variant, required String URI});
  Future<RwApiResponse> savePurchases({
    required SaleList item,
    required String URI,
    required String bhfId,
    String rcptTyCd = "S",
  });
  Future<RwApiResponse> saveStockItems(
      {required ITransaction transaction,
      required String tinNumber,
      required String bhFId,
      required String customerName,
      required String custTin,
      String? regTyCd = "A",
      //sarTyCd 11 is for sale
      String sarTyCd = "11",
      String custBhfId = "00",
      required double totalSupplyPrice,
      required double totalvat,
      required double totalAmount,
      required String remark,
      required DateTime ocrnDt,
      required String URI});
  Future saveCustomer({required ICustomer customer, required String URI});
  Future<bool> initApi(
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
      required DateTime timeToUser});
  Future<RwApiResponse> saveItem(
      {required IVariant variation, required String URI});

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
      {required api.Item item, required String URI});
}
