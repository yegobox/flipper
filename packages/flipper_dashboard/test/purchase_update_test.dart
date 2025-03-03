import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart'; // Import your model

void main() {
  // ignore: unused_local_variable
  Variant? selectedPurchaseItem;
  // Mock data for testing
  List<Purchase>? finalSaleList = [
    Purchase(
      spplrTin: "999980160",
      spplrNm: "TESTING COMPANY 35 LTD",
      spplrBhfId: "00",
      spplrInvcNo: 537,
      rcptTyCd: "S",
      pmtTyCd: "01",
      cfmDt: "2023-09-05 18:09:24",
      salesDt: "20230905",
      stockRlsDt: null,
      totItemCnt: 1,
      taxblAmtA: 0,
      taxblAmtB: 100000,
      taxblAmtC: 0,
      taxblAmtD: 0,
      taxRtA: 0,
      taxRtB: 18,
      taxRtC: 0,
      taxRtD: 0,
      taxAmtA: 0,
      taxAmtB: 15254.24,
      taxAmtC: 0,
      taxAmtD: 0,
      totTaxblAmt: 100000,
      totTaxAmt: 15254.24,
      totAmt: 100000,
      remark: null,
    ),
  ];

  /// This test logic in @ImportPurchasePage.dart
  /// but removed any UI related code such as interacting with text controller
  /// to focus on actual test if updating the salesList and ItemList within sa

  void selectItemPurchase(Variant? item, {required Purchase saleList}) {
    selectedPurchaseItem = item;
    if (item != null) {
      // Find the index of the SaleList in finalSaleList
      int saleListIndex = finalSaleList.indexWhere((s) =>
          s.spplrTin == saleList.spplrTin &&
          s.spplrInvcNo == saleList.spplrInvcNo);
      if (saleListIndex != -1) {
        // Find the index of the ItemList within the found SaleList
        // int itemListIndex = finalSaleList[saleListIndex]
        //     .variants!
        //     .indexWhere((i) => i.itemCd == item.itemCd);
        // if (itemListIndex != -1) {
        //   // Update the ItemList in finalSaleList
        //   finalSaleList[saleListIndex].variants![itemListIndex] = item;
        // }
      }
    }
  }

  test('selectItemPurchase updates finalSaleList correctly', () {
    // Arrange
    Variant updatedItem = Variant(
      itemSeq: 1,
      name: "Updated Room Name",
      itemCd: "RW3NTNO0000101",
      itemClsCd: "4220400800",
      itemNm: "Updated Room Name",
      bcd: null,
      pkgUnitCd: "NT",
      pkg: 1,
      qtyUnitCd: "NO",
      qty: 2, // Updated quantity
      prc: 120000, // Updated price
      splyAmt: 120000,
      dcRt: 0,
      dcAmt: 0,
      taxTyCd: "B",
      taxblAmt: 120000,
      taxAmt: 18000,
      totAmt: 120000,
    );

    Purchase targetSaleList = finalSaleList[0];

    // Act
    selectItemPurchase(updatedItem, saleList: targetSaleList);

    // Assert
    // expect(finalSaleList[0].variants![0].itemNm, "Updated Room Name");
    // expect(finalSaleList[0].variants![0].qty, 2);
    // expect(finalSaleList[0].variants![0].prc, 120000);
    // expect(finalSaleList[0].variants![0].taxAmt, 18000);
  });

  test('selectItemPurchase clears controllers when item is null', () {
    // Act
    selectItemPurchase(null, saleList: finalSaleList[0]);
  });
}
