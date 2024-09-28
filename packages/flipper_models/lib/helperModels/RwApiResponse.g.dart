// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RwApiResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RwApiResponse _$RwApiResponseFromJson(Map<String, dynamic> json) =>
    RwApiResponse(
      resultCd: json['resultCd'] as String,
      resultMsg: json['resultMsg'] as String,
      resultDt: json['resultDt'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RwApiResponseToJson(RwApiResponse instance) =>
    <String, dynamic>{
      'resultCd': instance.resultCd,
      'resultMsg': instance.resultMsg,
      'resultDt': instance.resultDt,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      rcptNo: (json['rcptNo'] as num?)?.toInt(),
      intrlData: json['intrlData'] as String?,
      rcptSign: json['rcptSign'] as String?,
      totRcptNo: (json['totRcptNo'] as num?)?.toInt(),
      vsdcRcptPbctDate: json['vsdcRcptPbctDate'] as String?,
      sdcId: json['sdcId'] as String?,
      mrcNo: json['mrcNo'] as String?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      saleList: (json['saleList'] as List<dynamic>?)
          ?.map((e) => SaleList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'rcptNo': instance.rcptNo,
      'intrlData': instance.intrlData,
      'rcptSign': instance.rcptSign,
      'totRcptNo': instance.totRcptNo,
      'vsdcRcptPbctDate': instance.vsdcRcptPbctDate,
      'sdcId': instance.sdcId,
      'mrcNo': instance.mrcNo,
      'itemList': instance.itemList,
      'saleList': instance.saleList,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      taskCd: json['taskCd'] as String,
      dclDe: json['dclDe'] as String,
      itemSeq: (json['itemSeq'] as num).toInt(),
      dclNo: json['dclNo'] as String,
      hsCd: json['hsCd'] as String,
      itemNm: json['itemNm'] as String,
      imptItemsttsCd: json['imptItemsttsCd'] as String,
      orgnNatCd: json['orgnNatCd'] as String,
      exptNatCd: json['exptNatCd'] as String,
      pkg: (json['pkg'] as num).toInt(),
      pkgUnitCd: json['pkgUnitCd'],
      qty: (json['qty'] as num).toInt(),
      qtyUnitCd: json['qtyUnitCd'] as String,
      totWt: (json['totWt'] as num).toInt(),
      netWt: (json['netWt'] as num).toInt(),
      spplrNm: json['spplrNm'] as String,
      agntNm: json['agntNm'] as String,
      invcFcurAmt: (json['invcFcurAmt'] as num).toInt(),
      invcFcurCd: json['invcFcurCd'] as String,
      invcFcurExcrt: (json['invcFcurExcrt'] as num).toDouble(),
      supplyPrice: (json['supplyPrice'] as num?)?.toDouble(),
      retailPrice: (json['retailPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'taskCd': instance.taskCd,
      'dclDe': instance.dclDe,
      'itemSeq': instance.itemSeq,
      'dclNo': instance.dclNo,
      'hsCd': instance.hsCd,
      'itemNm': instance.itemNm,
      'imptItemsttsCd': instance.imptItemsttsCd,
      'orgnNatCd': instance.orgnNatCd,
      'exptNatCd': instance.exptNatCd,
      'pkg': instance.pkg,
      'pkgUnitCd': instance.pkgUnitCd,
      'qty': instance.qty,
      'qtyUnitCd': instance.qtyUnitCd,
      'totWt': instance.totWt,
      'netWt': instance.netWt,
      'spplrNm': instance.spplrNm,
      'agntNm': instance.agntNm,
      'invcFcurAmt': instance.invcFcurAmt,
      'invcFcurCd': instance.invcFcurCd,
      'invcFcurExcrt': instance.invcFcurExcrt,
      'supplyPrice': instance.supplyPrice,
      'retailPrice': instance.retailPrice,
    };

SaleList _$SaleListFromJson(Map<String, dynamic> json) => SaleList(
      spplrTin: json['spplrTin'] as String,
      spplrNm: json['spplrNm'] as String,
      spplrBhfId: json['spplrBhfId'] as String,
      spplrInvcNo: (json['spplrInvcNo'] as num).toInt(),
      rcptTyCd: json['rcptTyCd'] as String,
      pmtTyCd: json['pmtTyCd'] as String,
      cfmDt: json['cfmDt'] as String,
      salesDt: json['salesDt'] as String,
      stockRlsDt: json['stockRlsDt'] as String?,
      totItemCnt: (json['totItemCnt'] as num).toInt(),
      taxblAmtA: (json['taxblAmtA'] as num).toDouble(),
      taxblAmtB: (json['taxblAmtB'] as num).toDouble(),
      taxblAmtC: (json['taxblAmtC'] as num).toDouble(),
      taxblAmtD: (json['taxblAmtD'] as num).toDouble(),
      taxRtA: (json['taxRtA'] as num).toDouble(),
      taxRtB: (json['taxRtB'] as num).toDouble(),
      taxRtC: (json['taxRtC'] as num).toDouble(),
      taxRtD: (json['taxRtD'] as num).toDouble(),
      taxAmtA: (json['taxAmtA'] as num).toDouble(),
      taxAmtB: (json['taxAmtB'] as num).toDouble(),
      taxAmtC: (json['taxAmtC'] as num).toDouble(),
      taxAmtD: (json['taxAmtD'] as num).toDouble(),
      totTaxblAmt: (json['totTaxblAmt'] as num).toDouble(),
      totTaxAmt: (json['totTaxAmt'] as num).toDouble(),
      totAmt: (json['totAmt'] as num).toDouble(),
      remark: json['remark'] as String?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => ItemList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SaleListToJson(SaleList instance) => <String, dynamic>{
      'spplrTin': instance.spplrTin,
      'spplrNm': instance.spplrNm,
      'spplrBhfId': instance.spplrBhfId,
      'spplrInvcNo': instance.spplrInvcNo,
      'rcptTyCd': instance.rcptTyCd,
      'pmtTyCd': instance.pmtTyCd,
      'cfmDt': instance.cfmDt,
      'salesDt': instance.salesDt,
      'stockRlsDt': instance.stockRlsDt,
      'totItemCnt': instance.totItemCnt,
      'taxblAmtA': instance.taxblAmtA,
      'taxblAmtB': instance.taxblAmtB,
      'taxblAmtC': instance.taxblAmtC,
      'taxblAmtD': instance.taxblAmtD,
      'taxRtA': instance.taxRtA,
      'taxRtB': instance.taxRtB,
      'taxRtC': instance.taxRtC,
      'taxRtD': instance.taxRtD,
      'taxAmtA': instance.taxAmtA,
      'taxAmtB': instance.taxAmtB,
      'taxAmtC': instance.taxAmtC,
      'taxAmtD': instance.taxAmtD,
      'totTaxblAmt': instance.totTaxblAmt,
      'totTaxAmt': instance.totTaxAmt,
      'totAmt': instance.totAmt,
      'remark': instance.remark,
      'itemList': instance.itemList,
    };

ItemList _$ItemListFromJson(Map<String, dynamic> json) => ItemList(
      itemSeq: (json['itemSeq'] as num).toInt(),
      itemCd: json['itemCd'] as String,
      itemClsCd: json['itemClsCd'] as String,
      itemNm: json['itemNm'] as String,
      bcd: json['bcd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String,
      pkg: (json['pkg'] as num).toInt(),
      qtyUnitCd: json['qtyUnitCd'] as String,
      qty: (json['qty'] as num).toInt(),
      prc: (json['prc'] as num).toDouble(),
      splyAmt: (json['splyAmt'] as num).toDouble(),
      dcRt: (json['dcRt'] as num).toDouble(),
      dcAmt: (json['dcAmt'] as num).toDouble(),
      taxTyCd: json['taxTyCd'] as String,
      taxblAmt: (json['taxblAmt'] as num).toDouble(),
      taxAmt: (json['taxAmt'] as num).toDouble(),
      totAmt: (json['totAmt'] as num).toDouble(),
    );

Map<String, dynamic> _$ItemListToJson(ItemList instance) => <String, dynamic>{
      'itemSeq': instance.itemSeq,
      'itemCd': instance.itemCd,
      'itemClsCd': instance.itemClsCd,
      'itemNm': instance.itemNm,
      'bcd': instance.bcd,
      'pkgUnitCd': instance.pkgUnitCd,
      'pkg': instance.pkg,
      'qtyUnitCd': instance.qtyUnitCd,
      'qty': instance.qty,
      'prc': instance.prc,
      'splyAmt': instance.splyAmt,
      'dcRt': instance.dcRt,
      'dcAmt': instance.dcAmt,
      'taxTyCd': instance.taxTyCd,
      'taxblAmt': instance.taxblAmt,
      'taxAmt': instance.taxAmt,
      'totAmt': instance.totAmt,
    };
