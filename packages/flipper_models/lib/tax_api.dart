import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';

abstract class TaxApi {
  Future<bool> saveStock(
      {required IStock stock, required IVariant variant, required String URI});
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

  Future<RwApiResponse?> generateReceiptSignature(
      {required ITransaction transaction,
      required String receiptType,
      required Counter counter,
      String? purchaseCode,
      required String URI});
  Future<bool> saveItem({required IVariant variation, required String URI});

  Future<RwApiResponse> savePurchases(
      {required SaleList item, required String URI});
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
      {required Item item, required String URI});
}
