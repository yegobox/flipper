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

/// Branches whose EBM Ditto subscription is already registered this session.
/// Guards [CapellaEbmMixin.ebm] against re-subscribing + re-delaying on every
/// call (bulk import calls it many times per row for EBM-less customers).
final Set<String> _capellaEbmSubscribedBranches = <String>{};

mixin CapellaEbmMixin implements EbmInterface {
  Repository get repository;
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  /// Ditto document for an EBM row, keyed `_id == id`.
  static Map<String, dynamic> _ebmToDittoDoc(Ebm ebm) => {
        '_id': ebm.id,
        'id': ebm.id,
        'mrc': ebm.mrc,
        'bhfId': ebm.bhfId,
        'tinNumber': ebm.tinNumber,
        'dvcSrlNo': ebm.dvcSrlNo,
        'userId': ebm.userId,
        'taxServerUrl': ebm.taxServerUrl,
        'businessId': ebm.businessId,
        'branchId': ebm.branchId,
        'vatEnabled': ebm.vatEnabled,
        'remoteServerUrl': ebm.remoteServerUrl,
        'dataConnectorUrl': ebm.dataConnectorUrl,
      };

  /// Accepts both shapes: Ditto docs carry the Dart names, Supabase rows are
  /// snake_case.
  Ebm _ebmFromMap(Map data, String branchId) {
    final tinRaw = data['tinNumber'] ?? data['tin_number'];
    final tinNumber = tinRaw is num
        ? tinRaw.toInt()
        : int.tryParse(tinRaw?.toString() ?? '') ?? 0;

    return Ebm(
      id: (data['id'] ?? data['_id'])?.toString(),
      mrc: data['mrc']?.toString() ?? '',
      bhfId: (data['bhfId'] ?? data['bhf_id'])?.toString() ?? '',
      tinNumber: tinNumber,
      dvcSrlNo: (data['dvcSrlNo'] ?? data['dvc_srl_no'])?.toString() ?? '',
      userId: (data['userId'] ?? data['user_id'])?.toString() ??
          ProxyService.box.getUserId(),
      taxServerUrl:
          (data['taxServerUrl'] ?? data['tax_server_url'])?.toString() ?? '',
      businessId: (data['businessId'] ?? data['business_id'])?.toString() ??
          ProxyService.box.getBusinessId() ??
          '',
      branchId:
          (data['branchId'] ?? data['branch_id'])?.toString() ?? branchId,
      vatEnabled: (data['vatEnabled'] ?? data['vat_enabled']) as bool?,
      remoteServerUrl:
          (data['remoteServerUrl'] ?? data['remote_server_url'])?.toString(),
      dataConnectorUrl:
          (data['dataConnectorUrl'] ?? data['data_connector_url'])?.toString(),
    );
  }

  /// EBM config with Ditto as an offline cache over Supabase.
  ///
  /// `ebms` is server-owned — [saveEbm] upserts it to Supabase, and nothing
  /// else populates the Ditto collection — so a Ditto miss must fall through to
  /// Supabase and seed the cache. Reading Ditto alone would return null on any
  /// device that has not written its own EBM, taking VAT, RRA and receipt
  /// signing down with it.
  @override
  Future<Ebm?> ebm({required String branchId, bool fetchRemote = true}) async {
    try {
      final ditto = dittoService.dittoInstance;

      if (ditto != null && !fetchRemote) {
        const dittoQuery = 'SELECT * FROM ebms WHERE branchId = :branchId';
        final arguments = {'branchId': branchId};

        // Register the subscription (and pay the initial sync wait) only once
        // per branch; repeat calls reuse the live subscription. Otherwise a
        // bulk import leaks subscriptions and stalls Ditto sync mid-batch.
        if (_capellaEbmSubscribedBranches.add(branchId)) {
          final prepared = prepareDqlSyncSubscription(dittoQuery, arguments);
          await ditto.sync.registerSubscription(
            prepared.dql,
            arguments: prepared.arguments,
          );
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final result = await ditto.store.execute(
          dittoQuery,
          arguments: arguments,
        );
        if (result.items.isNotEmpty) {
          return _ebmFromMap(result.items.first.value as Map, branchId);
        }
      }

      final row = await Supabase.instance.client
          .from('ebms')
          .select()
          .eq('branch_id', branchId)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;

      final ebm = _ebmFromMap(Map<String, dynamic>.from(row), branchId);
      await cacheEbmInDitto(ebm);
      return ebm;
    } catch (e, st) {
      talker.error('Capella ebm: Error fetching EBM: $e\n$st');
      return null;
    }
  }

  /// Writes [ebm] into the Ditto cache. Safe to call repeatedly.
  Future<void> cacheEbmInDitto(Ebm ebm) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    try {
      await ditto.store.execute(
        'INSERT INTO ebms DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': _ebmToDittoDoc(ebm)},
      );
    } catch (e) {
      talker.warning('Caching EBM ${ebm.id} into Ditto failed: $e');
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
  Future<bool> saveEbm({
    required String mrc,
    required String branchId,
    required String severUrl,
    required String bhFId,
    bool vatEnabled = false,
    String? dataConnectorUrl,
  }) async {
    try {
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);

      if (business == null) {
        throw Exception('Business not found');
      }

      // Existing row comes from Supabase, which owns this table.
      final existingRow = await Supabase.instance.client
          .from('ebms')
          .select()
          .eq('branch_id', branchId)
          .eq('bhf_id', bhFId)
          .limit(1)
          .maybeSingle();
      final existingEbm = existingRow == null
          ? null
          : _ebmFromMap(Map<String, dynamic>.from(existingRow), branchId);

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
            dataConnectorUrl: dataConnectorUrl,
          );

      if (existingEbm != null) {
        updatedEbm.taxServerUrl = severUrl;
        updatedEbm.vatEnabled = vatEnabled;
        updatedEbm.mrc = mrc;
        updatedEbm.dataConnectorUrl = dataConnectorUrl;
      } else if (dataConnectorUrl != null) {
        updatedEbm.dataConnectorUrl = dataConnectorUrl;
      }

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
        'data_connector_url': updatedEbm.dataConnectorUrl,
      });

      // Keep the Ditto cache in step so the next `ebm()` does not have to make
      // a round trip — and so it is correct while offline.
      await cacheEbmInDitto(updatedEbm);
      return true;
    } catch (e) {
      talker.error('Capella saveEbm: Error saving EBM: $e');
      return false;
    }
  }
}
