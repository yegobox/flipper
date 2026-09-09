import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/sync/utils/bulk_desktop_variant_prep.dart';

/// Registering a hotel room with RRA.
///
/// A room is not a good: RRA takes it as a **service** (`itemTyCd` `3`) in the
/// tourism-tax category (`ttCatCd` `TT`, 3%), with a property type and a room
/// type code. `rw_tax.dart` strips `ttCatCd`/`propertyTyCd`/`roomTypeCd` from
/// anything that is not `itemTyCd` `3`, because RRA answers 603 otherwise — so
/// these fields only ever travel together.
///
/// This mirrors what `AddRoomDialog` does, kept as logic the hotel module can
/// call without a dialog.

/// The only room type codes EBM accepts.
const hotelRraRoomTypeCodes = <String, String>{
  'Single': '01',
  'Double': '02',
  'Suite': '03',
  'Deluxe': '04',
};

/// RRA property type. `01` is the code Flipper registers rooms under.
const hotelRraPropertyTyCd = '01';

/// Tourism tax is a flat 3%.
const hotelRraTourismTaxPercentage = 3.0;

/// Item class used for accommodation services, matching the default the rest
/// of Flipper registers products under.
const hotelRraItemClsCd = '5020230602';

/// Packaging unit RRA expects for a night, rather than a carton.
const hotelRraPackagingUnit = 'NT';

/// Maps a property's own room-type name onto one of RRA's four codes.
///
/// Properties name rooms far more finely than RRA classifies them, so the
/// extra names collapse: a twin sells as a double, and every suite tier is a
/// suite. Unmatched names fall back to `03`, which is what `AddRoomDialog`
/// does when no type is picked.
String hotelRraRoomTypeCd(String roomType) {
  final normalised = roomType.trim().toLowerCase();
  if (normalised.isEmpty) return '03';

  final exact = hotelRraRoomTypeCodes.entries.where(
    (entry) => entry.key.toLowerCase() == normalised,
  );
  if (exact.isNotEmpty) return exact.first.value;

  if (normalised.contains('single')) return '01';
  if (normalised.contains('twin') || normalised.contains('double')) return '02';
  // Checked before "suite" so a "Deluxe Suite" bills as deluxe.
  if (normalised.contains('deluxe')) return '04';
  if (normalised.contains('suite') || normalised.contains('presidential')) {
    return '03';
  }
  return '03';
}

/// Builds the RRA service variant that represents [room].
///
/// Uses the same field set as every other registered product
/// ([prepareBulkVariantLikeDesktopAdd], which also allocates the `itemCd`),
/// then overlays what makes it accommodation rather than stock.
Future<Variant> buildHotelRoomVariant({
  required Product product,
  required HotelRoom room,
  required String branchId,
  required String taxTyCd,
  required int sku,
  Business? business,
}) async {
  final variant = await prepareBulkVariantLikeDesktopAdd(
    product: product,
    productName: room.name,
    branchId: branchId,
    taxTyCd: taxTyCd,
    itemClsCd: hotelRraItemClsCd,
    itemTyCd: '3',
    retailPrice: room.nightlyRate,
    supplyPrice: room.nightlyRate,
    barCode: null,
    sku: sku,
    packagingUnitCode: hotelRraPackagingUnit,
    business: business,
  );

  return applyHotelRoomRraFields(variant: variant, room: room);
}

/// Stamps the tourism-tax fields onto [variant].
///
/// Separate from [buildHotelRoomVariant] so an existing room variant can be
/// brought up to date — a rename or a rate change — without being rebuilt.
Variant applyHotelRoomRraFields({
  required Variant variant,
  required HotelRoom room,
}) {
  variant
    ..name = room.name
    ..itemNm = room.name
    ..productName = room.name
    ..itemStdNm = room.name
    ..retailPrice = room.nightlyRate
    ..supplyPrice = room.nightlyRate
    ..prc = room.nightlyRate
    ..dftPrc = room.nightlyRate
    ..splyAmt = room.nightlyRate
    ..itemTyCd = '3'
    ..ttCatCd = 'TT'
    ..taxName = 'TT'
    ..taxPercentage = hotelRraTourismTaxPercentage
    ..propertyTyCd = hotelRraPropertyTyCd
    ..roomTypeCd = hotelRraRoomTypeCd(room.roomType)
    ..pkgUnitCd = hotelRraPackagingUnit
    ..qtyUnitCd = 'U';
  return variant;
}

/// Whether [variant] is registered with RRA as a tourism-tax room service.
bool isHotelRoomVariantRegistered(Variant? variant) {
  if (variant == null) return false;
  final itemCd = variant.itemCd?.trim();
  return itemCd != null &&
      itemCd.isNotEmpty &&
      variant.itemTyCd == '3' &&
      variant.ttCatCd == 'TT';
}

/// Whether this branch is on EBM at all.
///
/// A property that does not file with RRA has no EBM row, or one without the
/// TIN and branch code every call carries. Registering its rooms is not a
/// failure to report — there is nothing to report to, so the room is simply
/// sold without a tourism-tax item.
bool hotelBranchSupportsRra(Ebm? ebm) {
  if (ebm == null) return false;
  return ebm.tinNumber != 0 && ebm.bhfId.trim().isNotEmpty;
}

/// Whether RRA explicitly rejected the registration.
///
/// [registerVariantWithRraForAdd] throws with RRA's own `resultMsg` and
/// `resultCd` when `saveItems` answers anything but `000`. A rejection means
/// RRA did **not** take the item, so the locally allocated `itemCd` is not an
/// identity it holds — unlike a timeout, where it may well have.
///
/// The distinction matters: a rejection is deterministic. Resuming it replays
/// the same payload for the same answer forever, leaving a half-registered
/// room behind every time.
bool hotelRraRejectedRegistration(Object error) {
  final message = error.toString();
  return message.contains('RRA saveItems failed') ||
      message.contains('RRA saveStockItems failed') ||
      message.contains('RRA saveStockMaster failed');
}

/// Whether a failed registration attempt can drop [variant] and its product.
///
/// Only while the item never reached RRA. Once `saveItems` has answered, the
/// `itemCd` is an identity RRA now holds; deleting it locally would make the
/// retry allocate a second code and register the same room twice.
bool hotelRoomRegistrationCanRollBack(Variant variant) {
  final itemCd = variant.itemCd?.trim();
  return itemCd == null || itemCd.isEmpty;
}
