import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/services/hotel_room_rra_service.dart';
import 'package:flipper_models/sync/utils/hotel_room_rra.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hotelRraRoomTypeCd', () {
    test('maps the four names RRA itself uses', () {
      expect(hotelRraRoomTypeCd('Single'), '01');
      expect(hotelRraRoomTypeCd('Double'), '02');
      expect(hotelRraRoomTypeCd('Suite'), '03');
      expect(hotelRraRoomTypeCd('Deluxe'), '04');
    });

    test('is case and whitespace insensitive', () {
      expect(hotelRraRoomTypeCd('  dOUBLE '), '02');
    });

    test('a twin sells as a double', () {
      expect(hotelRraRoomTypeCd('Twin'), '02');
    });

    test('every suite tier collapses to the suite code', () {
      expect(hotelRraRoomTypeCd('Junior Suite'), '03');
      expect(hotelRraRoomTypeCd('Executive Suite'), '03');
      expect(hotelRraRoomTypeCd('Presidential'), '03');
    });

    test('deluxe wins over suite when a name carries both', () {
      // "Deluxe Suite" is a deluxe room, not a plain suite.
      expect(hotelRraRoomTypeCd('Deluxe Suite'), '04');
    });

    test('an unknown or empty name falls back the way AddRoomDialog does', () {
      expect(hotelRraRoomTypeCd('Garden Bungalow'), '03');
      expect(hotelRraRoomTypeCd(''), '03');
      expect(hotelRraRoomTypeCd('   '), '03');
    });
  });

  group('applyHotelRoomRraFields', () {
    HotelRoom room({
      String name = '204',
      String type = 'Deluxe',
      double rate = 85000,
    }) => HotelRoom(
      id: 'r1',
      branchId: 'b1',
      floorId: 'first',
      floorName: 'First Floor',
      name: name,
      roomType: type,
      capacity: 2,
      nightlyRate: rate,
    );

    test('stamps accommodation as a tourism-tax service, not a good', () {
      final variant = applyHotelRoomRraFields(
        variant: Variant(branchId: 'b1', name: 'x'),
        room: room(),
      );

      // rw_tax.dart drops ttCatCd/propertyTyCd/roomTypeCd together, so these
      // four travel together or not at all.
      expect(variant.itemTyCd, '3');
      expect(variant.ttCatCd, 'TT');
      expect(variant.propertyTyCd, '01');
      expect(variant.roomTypeCd, '04');
    });

    test('a branch without TT registration gets a plain service', () {
      // RRA answers 603 <ttCatCd> for a taxpayer it has not registered for
      // tourism tax, which fails the whole saveItems call. The room still
      // registers — just with no TT coding at all.
      final variant = applyHotelRoomRraFields(
        variant: Variant(branchId: 'b1', name: 'x'),
        room: room(),
        tourismTaxEnabled: false,
      );

      expect(variant.itemTyCd, '3', reason: 'still a service');
      expect(variant.pkgUnitCd, 'NT', reason: 'still sold by the night');
      expect(variant.ttCatCd, isNull);
      expect(variant.propertyTyCd, isNull);
      expect(variant.roomTypeCd, isNull);
    });

    test('turning TT off clears coding a previous registration left behind',
        () {
      final variant = Variant(
        branchId: 'b1',
        name: '204',
        itemTyCd: '3',
        ttCatCd: 'TT',
        propertyTyCd: '01',
        roomTypeCd: '02',
      );

      applyHotelRoomRraFields(
        variant: variant,
        room: room(),
        tourismTaxEnabled: false,
      );

      // Leaving a stale ttCatCd on the row would send it on the next
      // saveItems and reproduce the 603.
      expect(variant.ttCatCd, isNull);
      expect(variant.propertyTyCd, isNull);
      expect(variant.roomTypeCd, isNull);
    });

    test('bills tourism tax at 3%, not VAT', () {
      final variant = applyHotelRoomRraFields(
        variant: Variant(branchId: 'b1', name: 'x'),
        room: room(),
      );
      expect(variant.taxPercentage, 3.0);
      expect(variant.taxName, 'TT');
    });

    test('a night is not a carton', () {
      final variant = applyHotelRoomRraFields(
        variant: Variant(branchId: 'b1', name: 'x'),
        room: room(),
      );
      expect(variant.pkgUnitCd, 'NT');
    });

    test('carries the room number and rate onto every price field', () {
      final variant = applyHotelRoomRraFields(
        variant: Variant(branchId: 'b1', name: 'stale'),
        room: room(name: '301', rate: 120000),
      );

      expect(variant.name, '301');
      expect(variant.itemNm, '301');
      expect(variant.retailPrice, 120000);
      expect(variant.prc, 120000);
      expect(variant.dftPrc, 120000);
    });

    test('a rename or re-rate updates an already-registered item', () {
      final variant = Variant(
        branchId: 'b1',
        name: '204',
        itemCd: 'RW1NTXU0000001',
        itemTyCd: '3',
        ttCatCd: 'TT',
      );

      applyHotelRoomRraFields(variant: variant, room: room(name: '205'));

      expect(variant.name, '205');
      // The registration itself survives; only the details move.
      expect(variant.itemCd, 'RW1NTXU0000001');
    });
  });

  group('hotelRraRejectedRegistration', () {
    test('an RRA rejection is recognised so it is not retried forever', () {
      // registerVariantWithRraForAdd throws with RRA's own message when
      // saveItems answers anything but 000.
      expect(
        hotelRraRejectedRegistration(
          Exception(
            'RRA saveItems failed for 107: Request parameter error : '
            '<ttCatCd> (603)',
          ),
        ),
        isTrue,
      );
      expect(
        hotelRraRejectedRegistration(
          Exception('RRA saveStockItems failed for 107: bad (881)'),
        ),
        isTrue,
      );
    });

    test('a transient failure is not a rejection', () {
      // RRA may well hold the item after a timeout, so the attempt is resumed
      // rather than rolled back.
      expect(
        hotelRraRejectedRegistration(Exception('SocketException: timeout')),
        isFalse,
      );
      expect(
        hotelRraRejectedRegistration(StateError('Ditto not initialized')),
        isFalse,
      );
    });
  });

  group('isHotelRoomVariantRegistered', () {
    test('needs an itemCd and the tourism-tax service coding', () {
      expect(isHotelRoomVariantRegistered(null), isFalse);
      expect(
        isHotelRoomVariantRegistered(Variant(branchId: 'b1', name: 'x')),
        isFalse,
      );
      expect(
        isHotelRoomVariantRegistered(
          Variant(branchId: 'b1', name: 'x', itemCd: 'X', itemTyCd: '2'),
        ),
        isFalse,
        reason: 'a good is not a room',
      );
      expect(
        isHotelRoomVariantRegistered(
          Variant(
            branchId: 'b1',
            name: 'x',
            itemCd: 'X',
            itemTyCd: '3',
            ttCatCd: 'TT',
          ),
        ),
        isTrue,
      );
    });
  });

  group('hotelBranchSupportsRra', () {
    Ebm ebm({int tinNumber = 999909695, String bhfId = '00'}) => Ebm(
      bhfId: bhfId,
      tinNumber: tinNumber,
      dvcSrlNo: 'dvc',
      businessId: 'biz1',
      branchId: 'b1',
      mrc: 'mrc',
    );

    test('a branch with no EBM row does not file with RRA', () {
      expect(hotelBranchSupportsRra(null), isFalse);
    });

    test('an EBM row without a TIN is not a filing branch', () {
      expect(hotelBranchSupportsRra(ebm(tinNumber: 0)), isFalse);
    });

    test('an EBM row without a branch code is not a filing branch', () {
      expect(hotelBranchSupportsRra(ebm(bhfId: '   ')), isFalse);
    });

    test('a configured branch files, VAT-registered or not', () {
      final configured = ebm();
      expect(hotelBranchSupportsRra(configured), isTrue);

      // A TT-only property registers rooms without being on VAT.
      configured.vatEnabled = false;
      expect(
        hotelBranchSupportsRra(configured),
        isTrue,
        reason: 'tourism tax rides on ttCatCd, not on VAT registration',
      );
    });
  });

  group('hotelBranchSupportsTourismTax', () {
    Ebm ebm({
      int tinNumber = 999909695,
      String bhfId = '00',
      bool? tourismTaxEnabled,
    }) =>
        Ebm(
          bhfId: bhfId,
          tinNumber: tinNumber,
          dvcSrlNo: 'dvc',
          businessId: 'biz1',
          branchId: 'b1',
          mrc: 'mrc',
          tourismTaxEnabled: tourismTaxEnabled,
        );

    test('a branch RRA registered for tourism tax may send ttCatCd', () {
      expect(
        hotelBranchSupportsTourismTax(ebm(tourismTaxEnabled: true)),
        isTrue,
      );
    });

    test('defaults to off, because RRA rejects TT it did not register', () {
      // An unset flag is the common case: no RRA endpoint reports the
      // registration back, so the branch has to be told. Sending TT on a
      // guess costs the whole registration with 603.
      expect(hotelBranchSupportsTourismTax(ebm()), isFalse);
      expect(
        hotelBranchSupportsTourismTax(ebm(tourismTaxEnabled: false)),
        isFalse,
      );
    });

    test('a branch that does not file with RRA at all never sends TT', () {
      expect(hotelBranchSupportsTourismTax(null), isFalse);
      expect(
        hotelBranchSupportsTourismTax(
          ebm(tinNumber: 0, tourismTaxEnabled: true),
        ),
        isFalse,
      );
      expect(
        hotelBranchSupportsTourismTax(
          ebm(bhfId: '   ', tourismTaxEnabled: true),
        ),
        isFalse,
      );
    });
  });

  group('hotelRoomRegistrationCanRollBack', () {
    Variant variant({String? itemCd}) =>
        Variant(branchId: 'b1', name: '101', itemCd: itemCd);

    test('an item RRA never answered for can be dropped', () {
      expect(hotelRoomRegistrationCanRollBack(variant()), isTrue);
      expect(hotelRoomRegistrationCanRollBack(variant(itemCd: '')), isTrue);
      expect(hotelRoomRegistrationCanRollBack(variant(itemCd: '  ')), isTrue);
    });

    test('an item that already holds an itemCd must be kept', () {
      // RRA holds this code. Deleting it locally would make the retry
      // register the same room a second time under a new one.
      expect(
        hotelRoomRegistrationCanRollBack(variant(itemCd: 'RW1NTXU0000001')),
        isFalse,
      );
    });
  });

  group('HotelRoom', () {
    test('knows whether it is registered, and round-trips its variant', () {
      const unregistered = HotelRoom(
        id: 'r1',
        branchId: 'b1',
        floorId: 'g',
        floorName: 'G',
        name: '101',
        roomType: 'Double',
        capacity: 2,
        nightlyRate: 50000,
      );
      expect(unregistered.isRegisteredWithRra, isFalse);

      final registered = unregistered.copyWith(variantId: 'v1');
      expect(registered.isRegisteredWithRra, isTrue);
      expect(HotelRoom.fromJson(registered.toJson()).variantId, 'v1');
      expect(
        HotelRoom.fromJson(unregistered.toJson()).variantId,
        isNull,
        reason: 'an absent variant must not read back as an empty string',
      );
    });
  });

  group('background registration sweep', () {
    HotelRoom room(String name, {String? variantId}) => HotelRoom(
      id: 'r-$name',
      branchId: 'b1',
      floorId: 'ground',
      floorName: 'Ground Floor',
      name: name,
      roomType: 'Double',
      capacity: 2,
      nightlyRate: 55000,
      variantId: variantId,
    );

    test('every seeded room starts with no RRA item', () {
      // This is the gap the sweep exists to close: seedDefaultRooms writes
      // these straight to Ditto, so without it the first guest in one pays
      // for the registration at the counter.
      final seeded = defaultHotelRoomPlan(branchId: 'b1');

      expect(seeded, hasLength(15));
      expect(
        seeded.every((r) => !r.isRegisteredWithRra),
        isTrue,
        reason: 'seeding does not register, which is why the sweep runs',
      );
      expect(
        HotelRoomRraService.roomsNeedingRegistration(seeded),
        hasLength(15),
      );
    });

    test('skips rooms that already carry an RRA item', () {
      // Rooms created through Rooms & floors register on creation, so a sweep
      // on an established property must be a no-op rather than re-minting.
      final rooms = [
        room('101', variantId: 'v-101'),
        room('102', variantId: 'v-102'),
      ];
      expect(HotelRoomRraService.roomsNeedingRegistration(rooms), isEmpty);
    });

    test('picks out only the unregistered rooms from a mixed floor', () {
      final rooms = [
        room('101', variantId: 'v-101'),
        room('102'),
        room('103', variantId: 'v-103'),
        room('104'),
      ];

      final pending = HotelRoomRraService.roomsNeedingRegistration(rooms);
      expect(pending.map((r) => r.name), ['102', '104']);
    });

    test('a blank variantId counts as unregistered, not as done', () {
      // A half-written room would otherwise be skipped forever and could
      // never be billed fiscally.
      expect(
        HotelRoomRraService.roomsNeedingRegistration([
          room('101', variantId: ''),
          room('102', variantId: '   '),
        ]),
        hasLength(2),
      );
    });

    test('an empty floor plan needs no work', () {
      expect(HotelRoomRraService.roomsNeedingRegistration(const []), isEmpty);
    });
  });
}
