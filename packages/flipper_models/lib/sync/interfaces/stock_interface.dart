import 'package:flipper_models/realm_model_export.dart';

abstract class StockInterface {
  Future<Stock?> getStockById({required String id});
  Future<void> updateStock({required Stock stock});
  Future<List<InventoryRequest>> requests({required String requestId});
}
