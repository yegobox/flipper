 ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [http-request] [POST] http://localhost:8080/rra1/items/saveItems
flutter: │ Data: "{\"_id\":\"f8888d48-5d46-4088-a8af-05a866486ed5\",\"id\":\"f8888d48-5d46-4088-a8af-05a866486ed5\",\"name\":\"FP0059\",\"color\":\"#DF2763\",\"sku\":\"822781973094639\",\"productId\":\"51947f62-7b77-416f-934d-86c8e6f7f0ff\",\"unit\":\"Per Item\",\"productName\":\"FP0059\",\"categoryId\":\"22bc25df-c1d1-4fed-b3e7-6b924572b8d5\",\"categoryName\":\"22bc25df-c1d1-4fed-b3e7-6b924572b8d5\",\"branchId\":\"7c19b5e8-1201-47cc-ae23-8fa13be6d39e\",\"taxName\":\"B\",\"taxPercentage\":18.0,\"itemSeq\":0,\"isrcRt\":0,\"taxTyCd\":\"B\",\"bcd\":\"FP0059\",\"itemClsCd\":\"5020230602\",\"itemTyCd\":\"2\",\"itemStdNm\":\"FP0059\",\"orgnNatCd\":\"RW\",\"pkg\":1,\"itemCd\":\"RW2CTCT0001386\",\"pkgUnitCd\":\"CT\",\"qtyUnitCd\":\"U\",\"itemNm\":\"FP0059\",\"prc\":3500.0,\"splyAmt\":2500.0,\"tin\":999909695,\"bhfId\":\"00\",\"dftPrc\":3500.0,\"addInfo\":\"A\",\"isrcAplcbYn\":\"N\",\"useYn\":\"N\",\"regrId\":\"82057\",\"regrNm\":\"FP0059\",\"modrId\":\"30357\",\"modrNm\":\"30357\",\"supplyPrice\":2500.0,\"retailPrice\":3500.0,\"spplrItemNm\":\"FP0059\",\"ebmSynced\":false,\"dcRt\":0.0,\"rsdQty\":10.0,\"qty\":10.0}"
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [http-response] [POST] http://localhost:8080/rra1/items/saveItems
flutter: │ Status: 200
flutter: │ Message: 
flutter: │ Data: {
flutter: │   "resultCd": "000",
flutter: │   "resultMsg": "It is succeeded",
flutter: │   "resultDt": "20260530091724",
flutter: │   "data": null
flutter: │ }
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: Response received: 200
flutter: Upserting: Instance of 'Sar'
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [info] | 8:09:15 307ms | {totItemCnt: 1, tin: 999909695, bhfId: 00, regTyCd: A, sarTyCd: 06, ocrnDt: 20260530, totTaxblAmt: 25000.0, totTaxAmt: 0.0, totAmt: 35000.0, remark: Stock In from adding new item, regrId: 82057, regrNm: FP0059, modrId: 30357, modrNm: 30357, sarNo: 4846, orgSarNo: 4846, itemList: [{itemSeq: 1, itemCd: RW2CTCT0001386, itemClsCd: 5020230602, itemNm: FP0059, itemTyCd: 2, itemStdNm: FP0059, qtyUnitCd: U, pkgUnitCd: CT, pkg: 1, qty: 10.0, prc: 3500.0, splyAmt: 2500.0, taxTyCd: B, taxblAmt: 35000.0, taxAmt: 0, totAmt: 35000.0, totDcAmt: 0, orgnNatCd: RW, isrcAplcbYn: N, regrId: 82057, regrNm: FP0059, modrId: 30357, modrNm: 30357, bcd: FP0059}]}
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [http-request] [POST] http://localhost:8080/rra1/stock/saveStockItems
flutter: │ Data: "{\"totItemCnt\":1,\"tin\":\"999909695\",\"bhfId\":\"00\",\"regTyCd\":\"A\",\"sarTyCd\":\"06\",\"ocrnDt\":\"20260530\",\"totTaxblAmt\":25000.0,\"totTaxAmt\":0.0,\"totAmt\":35000.0,\"remark\":\"Stock In from adding new item\",\"regrId\":\"82057\",\"regrNm\":\"FP0059\",\"modrId\":\"30357\",\"modrNm\":\"30357\",\"sarNo\":\"4846\",\"orgSarNo\":4846,\"itemList\":[{\"itemSeq\":1,\"itemCd\":\"RW2CTCT0001386\",\"itemClsCd\":\"5020230602\",\"itemNm\":\"FP0059\",\"itemTyCd\":\"2\",\"itemStdNm\":\"FP0059\",\"qtyUnitCd\":\"U\",\"pkgUnitCd\":\"CT\",\"pkg\":1,\"qty\":10.0,\"prc\":3500.0,\"splyAmt\":2500.0,\"taxTyCd\":\"B\",\"taxblAmt\":35000.0,\"taxAmt\":0,\"totAmt\":35000.0,\"totDcAmt\":\"0\",\"orgnNatCd\":\"RW\",\"isrcAplcbYn\":\"N\",\"regrId\":\"82057\",\"regrNm\":\"FP0059\",\"modrId\":\"30357\",\"modrNm\":\"30357\",\"bcd\":\"FP0059\"}]}"
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [http-response] [POST] http://localhost:8080/rra1/stock/saveStockItems
flutter: │ Status: 200
flutter: │ Message: 
flutter: │ Data: {
flutter: │   "resultCd": "000",
flutter: │   "resultMsg": "It is succeeded",
flutter: │   "resultDt": "20260530091725",
flutter: │   "data": null
flutter: │ }
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: Response received: 200
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [warning] | 8:09:15 947ms | RSD QTY (from stock.currentStock): {_id: f8888d48-5d46-4088-a8af-05a866486ed5, id: f8888d48-5d46-4088-a8af-05a866486ed5, name: FP0059, color: #DF2763, sku: 822781973094639, productId: 51947f62-7b77-416f-934d-86c8e6f7f0ff, unit: Per Item, productName: FP0059, categoryId: 22bc25df-c1d1-4fed-b3e7-6b924572b8d5, categoryName: 22bc25df-c1d1-4fed-b3e7-6b924572b8d5, branchId: 7c19b5e8-1201-47cc-ae23-8fa13be6d39e, taxName: B, taxPercentage: 18.0, itemSeq: 0, isrccCd: null, isrccNm: , isrcRt: 0, isrcAmt: null, taxTyCd: B, bcd: FP0059, itemClsCd: 5020230602, itemTyCd: 2, itemStdNm: FP0059, orgnNatCd: RW, pkg: 1, itemCd: RW2CTCT0001386, pkgUnitCd: CT, qtyUnitCd: U, itemNm: FP0059, prc: 3500.0, splyAmt: 2500.0, tin: 999909695, bhfId: 00, dftPrc: 3500.0, addInfo: A, imageUrl: null, isrcAplcbYn: N, useYn: N, regrId: 82057, regrNm: FP0059, modrId: 30357, modrNm: 30357, supplyPrice: 2500.0, retailPrice: 3500.0, spplrItemClsCd: , spplrItemCd: , spplrItemNm: FP0059, ebmSynced: false, dcRt: 0.0, rsdQty: 10.0, totWt: null, netWt: null, spplrNm: null, agntNm: null, invcFcurAmt: null, invcFcurCd: null, invcFcurExcrt: null, exptNatCd: null, dclNo: null, taskCd: null, dclDe: null, hsCd: null, imptItemSttsCd: null, totAmt: null, taxblAmt: null, taxAmt: null, dcAmt: 0.0, lastTouched: null, qty: 10.0, purchaseId: null, propertyTyCd: null, roomTypeCd: null, ttCatCd: null}
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [http-request] [POST] http://localhost:8080/rra1/stockMaster/saveStockMaster
flutter: │ Data: "{\"_id\":\"f8888d48-5d46-4088-a8af-05a866486ed5\",\"id\":\"f8888d48-5d46-4088-a8af-05a866486ed5\",\"name\":\"FP0059\",\"color\":\"#DF2763\",\"sku\":\"822781973094639\",\"productId\":\"51947f62-7b77-416f-934d-86c8e6f7f0ff\",\"unit\":\"Per Item\",\"productName\":\"FP0059\",\"categoryId\":\"22bc25df-c1d1-4fed-b3e7-6b924572b8d5\",\"categoryName\":\"22bc25df-c1d1-4fed-b3e7-6b924572b8d5\",\"branchId\":\"7c19b5e8-1201-47cc-ae23-8fa13be6d39e\",\"taxName\":\"B\",\"taxPercentage\":18.0,\"itemSeq\":0,\"isrccCd\":null,\"isrccNm\":\"\",\"isrcRt\":0,\"isrcAmt\":null,\"taxTyCd\":\"B\",\"bcd\":\"FP0059\",\"itemClsCd\":\"5020230602\",\"itemTyCd\":\"2\",\"itemStdNm\":\"FP0059\",\"orgnNatCd\":\"RW\",\"pkg\":1,\"itemCd\":\"RW2CTCT0001386\",\"pkgUnitCd\":\"CT\",\"qtyUnitCd\":\"U\",\"itemNm\":\"FP0059\",\"prc\":3500.0,\"splyAmt\":2500.0,\"tin\":999909695,\"bhfId\":\"00\",\"dftPrc\":3500.0,\"addInfo\":\"A\",\"imageUrl\":null,\"isrcAplcbYn\":\"N\",\"useYn\":\"N\",\"regrId\":\"82057\",\"regrNm\":\"FP0059\",\"modrId\":\"30357\",\"modrNm\":\"30357\",\"supplyPrice\":2500.0,\"retailPrice\":3500.0,\"spplrItemClsCd\":\"\",\"spplrItemCd\":\"\",\"spplrItemNm\":\"FP0059\",\"ebmSynced\":false,\"dcRt\":0.0,\"rsdQty\":10.0,\"totWt\":null,\"netWt\":null,\"spplrNm\":null,\"agntNm\":null,\"invcFcurAmt\":null,\"invcFcurCd\":null,\"invcFcurExcrt\":null,\"exptNatCd\":null,\"dclNo\":null,\"taskCd\":null,\"dclDe\":null,\"hsCd\":null,\"imptItemSttsCd\":null,\"totAmt\":null,\"taxblAmt\":null,\"taxAmt\":null,\"dcAmt\":0.0,\"lastTouched\":null,\"qty\":10.0,\"purchaseId\":null,\"propertyTyCd\":null,\"roomTypeCd\":null,\"ttCatCd\":null}"
flutter: └──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ [http-response] [POST] http://localhost:8080/rra1/stockMaster/saveStockMaster
flutter: │ Status: 200
flutter: │ Message: 
flutter: │ Data: {
flutter: │   "resultCd": "000",
flutter: │   "resultMsg": "It is succeeded",
flutter: │   "resultDt": "20260530091725",
flutter: │   "data": null
flutter: │ }