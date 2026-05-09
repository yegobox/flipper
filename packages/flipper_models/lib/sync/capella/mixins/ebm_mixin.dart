import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaEbmMixin implements EbmInterface {
  Repository get repository;
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  @override
  Future<Ebm?> ebm({required String branchId, bool fetchRemote = false}) async {
    try {
      final query = Query(
        where: [Where('branchId').isExactly(branchId)],
      );

      final policy = fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly;

      final fetchedEbms = await repository.get<Ebm>(
        query: query,
        policy: policy,
      );

      if (fetchedEbms.isEmpty) {
        final ditto = dittoService.dittoInstance;
        if (ditto != null) {
          const dittoQuery = 'SELECT * FROM ebms WHERE branchId = :branchId';
          final arguments = {'branchId': branchId};

          final preparedEbmFetch =
              prepareDqlSyncSubscription(dittoQuery, arguments);
          await ditto.sync.registerSubscription(
            preparedEbmFetch.dql,
            arguments: preparedEbmFetch.arguments,
          );
          await Future.delayed(const Duration(milliseconds: 500));

          final result =
              await ditto.store.execute(dittoQuery, arguments: arguments);
          final items = result.items.toList();

          if (items.isNotEmpty) {
            final ebmData = items.first.value as Map;
            final tinRaw =
                ebmData['tinNumber'] ?? ebmData['tin_number'];
            final tinNumber = tinRaw is num
                ? tinRaw.toInt()
                : int.tryParse(tinRaw?.toString() ?? '') ?? 0;

            final ebm = Ebm(
              id: ebmData['id'] as String? ?? ebmData['_id'] as String?,
              mrc: ebmData['mrc'] as String? ?? '',
              bhfId: ebmData['bhfId'] as String? ??
                  ebmData['bhf_id'] as String? ??
                  '',
              tinNumber: tinNumber,
              dvcSrlNo: ebmData['dvcSrlNo'] as String? ??
                  ebmData['dvc_srl_no'] as String? ??
                  '',
              userId: ebmData['userId'] as String? ??
                  ebmData['user_id'] as String? ??
                  ProxyService.box.getUserId(),
              taxServerUrl: ebmData['taxServerUrl'] as String? ??
                  ebmData['tax_server_url'] as String? ??
                  '',
              businessId: ebmData['businessId'] as String? ??
                  ebmData['business_id'] as String? ??
                  ProxyService.box.getBusinessId() ??
                  '',
              branchId: ebmData['branchId'] as String? ??
                  ebmData['branch_id'] as String? ??
                  branchId,
              vatEnabled: ebmData['vatEnabled'] as bool? ??
                  ebmData['vat_enabled'] as bool?,
            );

            await repository.upsert<Ebm>(ebm);
            return ebm;
          }
        }
      }

      return fetchedEbms.isNotEmpty ? fetchedEbms.first : null;
    } catch (e, st) {
      talker.error('Capella ebm: Error fetching EBM: $e\n$st');
      return null;
    }
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) async {
    final query =
        Query(where: [Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<Product>(query: query);
    return result.firstOrNull;
  }

  @override
  Future<void> saveEbm({
    required String mrc,
    required String branchId,
    required String severUrl,
    required String bhFId,
    bool vatEnabled = false,
  }) async {
    try {
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);

      if (business == null) {
        throw Exception('Business not found');
      }

      final query = Query(where: [
        Where('branchId').isExactly(branchId),
        Where('bhfId').isExactly(bhFId),
      ]);

      final ebm = await repository.get<Ebm>(
        query: query,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      final existingEbm = ebm.firstOrNull;

      final resolvedTin =
          (await effectiveTin(business: business, branchId: branchId));

      if (resolvedTin == null) {
        throw Exception(
          'Could not resolve TIN number for EBM creation. Business or branch may not have a valid TIN.',
        );
      }

      var updatedEbm = existingEbm ??
          Ebm(
            mrc: mrc,
            bhfId: bhFId,
            tinNumber: resolvedTin,
            dvcSrlNo: business.dvcSrlNo ?? 'vsdcyegoboxltd',
            userId: ProxyService.box.getUserId()!,
            taxServerUrl: severUrl,
            businessId: business.id,
            branchId: branchId,
            vatEnabled: vatEnabled,
          );

      if (existingEbm != null) {
        updatedEbm.taxServerUrl = severUrl;
        updatedEbm.vatEnabled = vatEnabled;
        updatedEbm.mrc = mrc;
      }

      await repository.upsert(updatedEbm);

      final supabase = Supabase.instance.client;
      await supabase.from('ebms').upsert({
        'id': updatedEbm.id,
        'bhf_id': updatedEbm.bhfId,
        'tin_number': updatedEbm.tinNumber,
        'dvc_srl_no': updatedEbm.dvcSrlNo,
        'user_id': updatedEbm.userId,
        'tax_server_url': updatedEbm.taxServerUrl,
        'business_id': updatedEbm.businessId,
        'branch_id': updatedEbm.branchId,
        'vat_enabled': updatedEbm.vatEnabled,
        'mrc': updatedEbm.mrc,
      });
    } catch (e) {
      talker.error('Capella saveEbm: Error saving EBM: $e');
    }
  }
}
