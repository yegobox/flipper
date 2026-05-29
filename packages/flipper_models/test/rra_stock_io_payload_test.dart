import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _stockLine({
  required String id,
  num qty = 12,
  double supplyUnit = 25,
  double retailUnit = 60,
  String? regrId,
  String? modrId,
}) {
  return TransactionItem(
    id: id,
    name: 'Smoke 005',
    qty: qty,
    price: retailUnit,
    discount: 0,
    prc: retailUnit,
    ttCatCd: 'A',
    itemCd: 'RW2AMCT0000138',
    itemClsCd: '5020230602',
    itemNm: 'Smoke 005',
    itemTyCd: '2',
    supplyPrice: supplyUnit,
    regrId: regrId,
    modrId: modrId,
    regrNm: regrId,
    modrNm: modrId,
  );
}

void main() {
  group('isIncomingRraStockIo', () {
    test('stock-in and adjustments are incoming', () {
      expect(isIncomingRraStockIo(StockInOutType.adjustmentIn), isTrue);
      expect(isIncomingRraStockIo(StockInOutType.returnIn), isTrue);
    });

    test('sale and sale return-out are not incoming', () {
      expect(isIncomingRraStockIo(StockInOutType.sale), isFalse);
      expect(isIncomingRraStockIo(StockInOutType.returnOut), isFalse);
    });
  });

  group('rraStockIoRegistrarFields', () {
    test('uses variant registrar ids when present', () {
      final fields = rraStockIoRegistrarFields([
        _stockLine(id: 'l1', regrId: '31283', modrId: '25431'),
      ]);
      expect(fields['regrId'], '31283');
      expect(fields['modrId'], '25431');
    });
  });

  group('mapRraStockIoItemToJson', () {
    test('matches data-connector stock-in line shape', () {
      final line = mapRraStockIoItemToJson(
        _stockLine(id: 'l1', regrId: '31283', modrId: '25431'),
        bhfId: '00',
        itemSeq: 1,
        fallbackModId: () => 'SHOULD_NOT_USE',
      );

      expect(line['pkg'], 1);
      expect(line['qty'], 12.0);
      expect(line['splyAmt'], 25.0);
      expect(line['taxAmt'], 0);
      expect(line['taxblAmt'], 720.0);
      expect(line['totAmt'], 720.0);
      expect(line['modrId'], '25431');
      expect(line['orgnNatCd'], 'RW');
      expect(line['isrcAplcbYn'], 'N');
      expect(line.containsKey('useYn'), isFalse);
    });

    test('uses prc when price is zero', () {
      final line = mapRraStockIoItemToJson(
        TransactionItem(
          id: 'l2',
          name: 'X',
          qty: 5,
          price: 0,
          prc: 60,
          discount: 0,
          ttCatCd: 'A',
          itemCd: 'RW2AMCT0000999',
          itemClsCd: '5020230602',
          itemNm: 'X',
          itemTyCd: '2',
          supplyPrice: 25,
        ),
        bhfId: '00',
      );
      expect(line['prc'], 60.0);
      expect(line['totAmt'], 300.0);
    });
  });

  group('buildRraSaveStockItemsRequest', () {
    test('stock-in (06): no customer fields, variant registrar, envelope totals × qty', () {
      final item = _stockLine(id: 'l1', regrId: '31283', modrId: '25431');
      final line = mapRraStockIoItemToJson(item, bhfId: '00', itemSeq: 1);

      final body = buildRraSaveStockItemsRequest(
        items: [item],
        itemList: [line],
        tinNumber: '999909695',
        bhfId: '00',
        sarTyCd: StockInOutType.adjustmentIn,
        regTyCd: 'A',
        ocrnDt: '20260529',
        totalSupplyPrice: 25 * 12,
        totalvat: 0,
        totalAmount: 60 * 12,
        remark: 'Stock In from adding new item',
        sarNo: '4836',
        orgSarNo: 4836,
        fallbackRegistrarId: () => 'RANDOM',
      );

      expect(body['sarTyCd'], '06');
      expect(body['totTaxblAmt'], 300.0);
      expect(body['totAmt'], 720.0);
      expect(body['regrId'], '31283');
      expect(body['modrId'], '25431');
      expect(body.containsKey('custNm'), isFalse);
      expect(body.containsKey('custTin'), isFalse);
      expect(body.containsKey('custBhfId'), isFalse);

      final list = body['itemList'] as List;
      expect(list.single['pkg'], 1);
    });

    test('sale (11): always includes custNm (defaults to N/A)', () {
      final item = _stockLine(id: 'l1');
      final line = mapRraStockIoItemToJson(item, bhfId: '00');

      final body = buildRraSaveStockItemsRequest(
        items: [item],
        itemList: [line],
        tinNumber: '999909695',
        bhfId: '00',
        sarTyCd: StockInOutType.sale,
        regTyCd: 'A',
        ocrnDt: '20260529',
        totalSupplyPrice: 100,
        totalvat: 18,
        totalAmount: 118,
        remark: 'Sale',
        sarNo: '100',
        orgSarNo: 100,
      );

      expect(body['sarTyCd'], '11');
      expect(body['custNm'], 'N/A');
    });

    test('sale (11): includes customer name', () {
      final item = _stockLine(id: 'l1');
      final line = mapRraStockIoItemToJson(item, bhfId: '00');

      final body = buildRraSaveStockItemsRequest(
        items: [item],
        itemList: [line],
        tinNumber: '999909695',
        bhfId: '00',
        sarTyCd: StockInOutType.sale,
        regTyCd: 'A',
        ocrnDt: '20260529',
        totalSupplyPrice: 100,
        totalvat: 18,
        totalAmount: 118,
        remark: 'Sale',
        sarNo: '100',
        orgSarNo: 100,
        saleCustomerName: 'Walk-in Customer',
      );

      expect(body['sarTyCd'], '11');
      expect(body['custNm'], 'Walk-in Customer');
    });
  });

  group('resolveRraStockIoSarTyCd', () {
    test('post-sale NS must not default to stock-in 06', () {
      expect(
        resolveRraStockIoSarTyCd(receiptType: 'NS'),
        StockInOutType.sale,
      );
      expect(resolveRraStockIoSarTyCd(receiptType: 'NS'), isNot('06'));
    });
  });
}
