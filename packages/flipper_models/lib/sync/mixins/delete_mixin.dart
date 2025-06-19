import 'dart:async' show FutureOr;
import 'dart:io';

import 'package:flipper_models/sync/interfaces/delete_interface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/talker.dart';

//
mixin DeleteMixin implements DeleteInterface {
  Repository get repository;
  Future<Product?> getProduct({
    String? id,
    String? barCode,
    required int branchId,
    String? name,
    required int businessId,
  }) async {
    final query = Query(where: [
      if (id != null) Where('id').isExactly(id),
      if (barCode != null) Where('barCode').isExactly(barCode),
      if (name != null) Where('name').isExactly(name),
      Where('branchId').isExactly(branchId),
      Where('businessId').isExactly(businessId),
    ]);

    final result = await repository.get<Product>(query: query);
    return result.firstOrNull;
  }

  Future<Variant?> getVariant({required String id});
  Future<Stock?> getStockById({required String id});
  FutureOr<List<Customer>> customers(
      {required int branchId, String? key, String? id});
  // FutureOr<List<InventoryRequest>> requests({int? branchId, String? requestId});
  @override
  Future<void> deleteTransactionItemAndResequence({required String id}) async {
    try {
      final transactionItemToDelete = await repository.get<TransactionItem>(
        query: Query(
          where: [Where('id').isExactly(id)],
          limit: 1,
        ),
      );

      if (transactionItemToDelete.isEmpty) {
        print('Transaction item with ID $id not found.');
        return;
      }

      final itemToDelete = transactionItemToDelete.first;
      final transactionId = itemToDelete.transactionId;

      await repository.delete<TransactionItem>(
        itemToDelete,
        query: Query(
          action: QueryAction.delete,
          where: [Where('id').isExactly(id)],
        ),
      );

      final remainingItems = await repository.get<TransactionItem>(
        query: Query(
          where: [Where('transactionId').isExactly(transactionId)],
        ),
      );

      remainingItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      for (var i = 0; i < remainingItems.length; i++) {
        remainingItems[i].itemSeq = i + 1;
        await repository.upsert<TransactionItem>(remainingItems[i]);
      }
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<bool> flipperDelete(
      {required String id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient}) async {
    switch (endPoint) {
      case 'product':
        final product = await getProduct(
            id: id,
            branchId: ProxyService.box.getBranchId()!,
            businessId: ProxyService.box.getBusinessId()!);
        if (product != null) {
          await repository.delete<Product>(product);
        }
        break;
      case 'variant':
        try {
          final variant = await getVariant(id: id);
          final stock = await getStockById(id: variant!.stockId ?? "");

          await repository.delete<Variant>(
            variant,
            query: Query(
                action: QueryAction.delete, where: [Where('id').isExactly(id)]),
          );
          await repository.delete<Stock>(
            stock!,
            query: Query(
                action: QueryAction.delete, where: [Where('id').isExactly(id)]),
          );
        } catch (e, s) {
          final variant = await getVariant(id: id);
          await repository.delete<Variant>(
            variant!,
            query: Query(
                action: QueryAction.delete, where: [Where('id').isExactly(id)]),
          );
          talker.warning(s);
          rethrow;
        }

        break;

      case 'transactionItem':
        await deleteTransactionItemAndResequence(id: id);
        break;
      case 'customer':
        final customer =
            (await customers(id: id, branchId: ProxyService.box.getBranchId()!))
                .firstOrNull;
        if (customer != null) {
          await repository.delete<Customer>(
            customer,
            query: Query(
                action: QueryAction.delete, where: [Where('id').isExactly(id)]),
          );
        }
        break;
      case 'stockRequest':
        final request = (await ProxyService.strategy.requests(
          requestId: id,
        ))
            .firstOrNull;
        if (request != null) {
          // get dependent first
          if (request.financing != null) {
            final financing = await repository.get<Financing>(
              query:
                  Query(where: [Where('id').isExactly(request.financing!.id)]),
            );
            try {
              await repository.delete<Financing>(
                financing.first,
                query: Query(
                    action: QueryAction.delete,
                    where: [Where('id').isExactly(financing.first.id)]),
              );
            } catch (e) {
              talker.warning(e);
            }
          }

          await repository.delete<InventoryRequest>(
            request,
            query: Query(
                action: QueryAction.delete, where: [Where('id').isExactly(id)]),
          );
        }
      case 'tenant':
        final tenant = (await ProxyService.strategy.tenant(
          fetchRemote: false,
          id: id,
        ));
        if (tenant != null) {
          await repository.delete<Tenant>(tenant);
        }
      case 'transaction':
        final transaction = (await ProxyService.strategy.getTransaction(
          id: id,
          branchId: ProxyService.box.getBranchId()!,
        ));
        if (transaction != null) {
          await repository.delete<ITransaction>(
            transaction,
            query: Query(
                action: QueryAction.delete, where: [Where('id').isExactly(id)]),
          );
        }
        break;
    }
    return true;
  }
}
