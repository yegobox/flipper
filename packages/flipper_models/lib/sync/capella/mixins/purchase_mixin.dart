import 'dart:async';

import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:supabase_models/brick/models/purchase.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaPurchaseMixin implements PurchaseInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastRequestdate,
  }) async {
    throw UnimplementedError(
        'selectImportItems needs to be implemented for Capella');
  }

  @override
  Future<List<Variant>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
    required String lastRequestdate,
  }) async {
    throw UnimplementedError(
        'selectPurchases needs to be implemented for Capella');
  }

  @override
  Future<void> saveVariant(
    Variant item,
    Business business,
    int branchId,
  ) async {
    throw UnimplementedError('saveVariant needs to be implemented for Capella');
  }

  @override
  Future<List<Purchase>> purchases() {
    throw UnimplementedError('purchases needs to be implemented for Capella');
  }

  @override
  FutureOr<Purchase?> getPurchase({
    required String id,
  }) {
    throw UnimplementedError('getPurchase needs to be implemented for Capella');
  }

  @override
  Future<List<Variant>> allImportsToDate() {
    throw UnimplementedError(
        'allImportsToDate needs to be implemented for Capella');
  }

  @override
  Future<List<PurchaseReportItem>> allPurchasesToDate() {
    throw UnimplementedError(
        'allPurchasesToDate needs to be implemented for Capella');
  }
}
