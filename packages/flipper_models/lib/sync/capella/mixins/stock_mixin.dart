import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaStockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Stock?> getStockById({required String id}) async {
    throw UnimplementedError(
        'getStockById needs to be implemented for Capella');
  }

  @override
  Future<void> updateStock({required Stock stock}) async {
    throw UnimplementedError('updateStock needs to be implemented for Capella');
  }

  @override
  Future<List<InventoryRequest>> requests({required String requestId}) async {
    throw UnimplementedError('requests needs to be implemented for Capella');
  }
}
