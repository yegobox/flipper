import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/interfaces/hotel_interface.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

mixin CoreHotelStubMixin implements HotelInterface {
  void _warn(String method) {
    talker.warning('Hotel Mode is available on Capella only; $method ignored.');
  }

  @override
  Future<HotelBranchSettings?> hotelBranchSettings({
    required String branchId,
  }) async {
    _warn('hotelBranchSettings');
    return null;
  }

  @override
  Stream<HotelBranchSettings?> hotelBranchSettingsStream({
    required String branchId,
  }) {
    _warn('hotelBranchSettingsStream');
    return Stream.value(null);
  }

  @override
  Future<void> saveHotelBranchSettings(HotelBranchSettings settings) async =>
      _warn('saveHotelBranchSettings');

  @override
  Stream<List<HotelRoom>> hotelRoomsStream({required String branchId}) {
    _warn('hotelRoomsStream');
    return Stream.value(<HotelRoom>[]);
  }

  @override
  Future<List<HotelRoom>> hotelRooms({required String branchId}) async {
    _warn('hotelRooms');
    return [];
  }

  @override
  Future<void> saveHotelRoom(HotelRoom room) async => _warn('saveHotelRoom');

  @override
  Future<void> deleteHotelRoom({
    required String id,
    required String branchId,
  }) async =>
      _warn('deleteHotelRoom');

  @override
  Future<void> seedDefaultRooms({required String branchId}) async =>
      _warn('seedDefaultRooms');

  @override
  Future<void> setHotelRoomHousekeeping({
    required String roomId,
    required String branchId,
    required HotelHousekeeping housekeeping,
  }) async =>
      _warn('setHotelRoomHousekeeping');

  @override
  Stream<List<HotelStay>> hotelStaysStream({required String branchId}) {
    _warn('hotelStaysStream');
    return Stream.value(<HotelStay>[]);
  }

  @override
  Future<List<HotelStay>> hotelStays({required String branchId}) async {
    _warn('hotelStays');
    return [];
  }

  @override
  Future<HotelStay?> hotelStayForRoom({
    required String branchId,
    required String roomId,
  }) async {
    _warn('hotelStayForRoom');
    return null;
  }

  @override
  Future<HotelStay?> hotelStayById({required String id}) async {
    _warn('hotelStayById');
    return null;
  }

  @override
  Future<void> saveHotelStay(HotelStay stay) async => _warn('saveHotelStay');

  @override
  Future<HotelStay> checkInGuest({
    required String branchId,
    required HotelRoom room,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    required String clerkTenantId,
    required String clerkName,
    String? guestPhone,
    int adults = 1,
    int children = 0,
    String? note,
  }) async {
    _warn('checkInGuest');
    throw UnsupportedError('Hotel Mode requires Capella strategy');
  }

  @override
  Future<void> cancelHotelStay({required HotelStay stay}) async =>
      _warn('cancelHotelStay');

  @override
  Future<List<HotelStay>> hotelStaysInRange({
    required String branchId,
    required DateTime from,
    required DateTime to,
  }) async {
    _warn('hotelStaysInRange');
    return [];
  }

  @override
  Future<HotelStay> reserveRoom({
    required String branchId,
    required HotelRoom room,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    required String clerkTenantId,
    required String clerkName,
    String? guestPhone,
    int adults = 1,
    int children = 0,
    String? note,
  }) async {
    _warn('reserveRoom');
    throw UnsupportedError('Hotel Mode requires Capella strategy');
  }

  @override
  Future<HotelStay> checkInReservation({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    _warn('checkInReservation');
    throw UnsupportedError('Hotel Mode requires Capella strategy');
  }

  @override
  Future<List<HotelStay>> chargeableStays({required String branchId}) async {
    _warn('chargeableStays');
    return [];
  }

  @override
  Future<int> transferCartToFolio({
    required String cartTransactionId,
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    _warn('transferCartToFolio');
    throw UnsupportedError('Hotel Mode requires Capella strategy');
  }

  @override
  Stream<List<HotelQuotation>> hotelQuotationsStream({
    required String branchId,
  }) {
    _warn('hotelQuotationsStream');
    return Stream.value(const <HotelQuotation>[]);
  }

  @override
  Future<List<HotelQuotation>> hotelQuotations({
    required String branchId,
  }) async {
    _warn('hotelQuotations');
    return [];
  }

  @override
  Future<void> saveHotelQuotation(HotelQuotation quotation) async =>
      _warn('saveHotelQuotation');

  @override
  Future<void> deleteHotelQuotation({
    required String id,
    required String branchId,
  }) async =>
      _warn('deleteHotelQuotation');

  @override
  Future<HotelStay> convertQuotationToReservation({
    required HotelQuotation quotation,
    required HotelRoom room,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    _warn('convertQuotationToReservation');
    throw UnsupportedError('Hotel Mode requires Capella strategy');
  }

  @override
  Future<ITransaction?> hotelFolio({required String transactionId}) async {
    _warn('hotelFolio');
    return null;
  }

  @override
  Future<List<ITransaction>> hotelOpenFolios({
    required String branchId,
  }) async {
    _warn('hotelOpenFolios');
    return [];
  }

  @override
  Stream<List<ITransaction>> hotelOpenFoliosStream({
    required String branchId,
  }) {
    _warn('hotelOpenFoliosStream');
    return Stream.value(const <ITransaction>[]);
  }

  @override
  Future<List<TransactionItem>> hotelFolioLines({
    required String transactionId,
  }) async {
    _warn('hotelFolioLines');
    return [];
  }

  @override
  Stream<List<TransactionItem>> hotelFolioLinesStream({
    required String transactionId,
  }) {
    _warn('hotelFolioLinesStream');
    return Stream.value(<TransactionItem>[]);
  }

  @override
  Future<void> addChargeToFolio({
    required String transactionId,
    required String branchId,
    required String variantId,
    required String productName,
    required num defaultPrice,
    required num stock,
    required String clerkTenantId,
    required String clerkName,
    num qty = 1,
    String? color,
    String? sku,
  }) async =>
      _warn('addChargeToFolio');

  @override
  Future<void> postRoomCharge({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async =>
      _warn('postRoomCharge');

  @override
  Future<void> setFolioLineQty({
    required String lineId,
    required String transactionId,
    required num qty,
    required num stockCap,
  }) async =>
      _warn('setFolioLineQty');

  @override
  Future<void> setFolioLinePrice({
    required String lineId,
    required String transactionId,
    required num price,
  }) async =>
      _warn('setFolioLinePrice');

  @override
  Future<void> deleteFolioLine({
    required String lineId,
    required String transactionId,
  }) async =>
      _warn('deleteFolioLine');

  @override
  Future<void> refreshFolioSubTotal({required String transactionId}) async =>
      _warn('refreshFolioSubTotal');

  @override
  Future<ITransaction> checkOutGuest({
    required HotelStay stay,
    required ITransaction transaction,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  }) async {
    _warn('checkOutGuest');
    throw UnsupportedError('Hotel Mode requires Capella strategy');
  }
}
