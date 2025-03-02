class BusinessInfoResponse {
  final String resultCd;
  final String resultMsg;
  final String resultDt;
  final BusinessInfoData data;

  BusinessInfoResponse({
    required this.resultCd,
    required this.resultMsg,
    required this.resultDt,
    required this.data,
  });

  factory BusinessInfoResponse.fromJson(Map<String, dynamic> json) {
    return BusinessInfoResponse(
      resultCd: json['resultCd'] as String,
      resultMsg: json['resultMsg'] as String,
      resultDt: json['resultDt'] as String,
      data: BusinessInfoData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultCd': resultCd,
      'resultMsg': resultMsg,
      'resultDt': resultDt,
      'data': data.toJson(),
    };
  }
}

class BusinessInfoData {
  final BusinessInfo info;

  BusinessInfoData({
    required this.info,
  });

  factory BusinessInfoData.fromJson(Map<String, dynamic> json) {
    return BusinessInfoData(
      info: BusinessInfo.fromJson(json['info'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
    };
  }
}

class BusinessInfo {
  final String tin;
  final String taxprNm;
  final String? bsnsActv; // Can be null
  final String bhfId;
  final String bhfNm;
  final String bhfOpenDt;
  final String prvncNm;
  final String dstrtNm;
  final String sctrNm;
  final String locDesc;
  final String hqYn;
  final String mgrNm;
  final String mgrTelNo;
  final String mgrEmail;
  final String? sdcId; // Can be null
  final String? mrcNo; // Can be null
  final String dvcId;
  final String? intrlKey; // Can be null
  final String? signKey; // Can be null
  final String? cmcKey; // Can be null
  final int lastPchsInvcNo;
  final String? lastSaleRcptNo; // Can be null
  final String? lastInvcNo; // Can be null
  final int? lastSaleInvcNo; // Can be null
  final String? lastTrainInvcNo; // Can be null
  final String? lastProfrmInvcNo; // Can be null
  final String? lastCopyInvcNo; // Can be null
  final int vatTyCd;

  BusinessInfo({
    required this.tin,
    required this.taxprNm,
    this.bsnsActv,
    required this.bhfId,
    required this.bhfNm,
    required this.bhfOpenDt,
    required this.prvncNm,
    required this.dstrtNm,
    required this.sctrNm,
    required this.locDesc,
    required this.hqYn,
    required this.mgrNm,
    required this.mgrTelNo,
    required this.mgrEmail,
    this.sdcId,
    this.mrcNo,
    required this.dvcId,
    this.intrlKey,
    this.signKey,
    this.cmcKey,
    required this.lastPchsInvcNo,
    this.lastSaleRcptNo,
    this.lastInvcNo,
    this.lastSaleInvcNo,
    this.lastTrainInvcNo,
    this.lastProfrmInvcNo,
    this.lastCopyInvcNo,
    required this.vatTyCd,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      tin: json['tin'] as String,
      taxprNm: json['taxprNm'] as String,
      bsnsActv: json['bsnsActv'] as String?,
      bhfId: json['bhfId'] as String,
      bhfNm: json['bhfNm'] as String,
      bhfOpenDt: json['bhfOpenDt'] as String,
      prvncNm: json['prvncNm'] as String,
      dstrtNm: json['dstrtNm'] as String,
      sctrNm: json['sctrNm'] as String,
      locDesc: json['locDesc'] as String,
      hqYn: json['hqYn'] as String,
      mgrNm: json['mgrNm'] as String,
      mgrTelNo: json['mgrTelNo'] as String,
      mgrEmail: json['mgrEmail'] as String,
      sdcId: json['sdcId'] as String?,
      mrcNo: json['mrcNo'] as String?,
      dvcId: json['dvcId'] as String,
      intrlKey: json['intrlKey'] as String?,
      signKey: json['signKey'] as String?,
      cmcKey: json['cmcKey'] as String?,
      lastPchsInvcNo: json['lastPchsInvcNo'] as int,
      lastSaleRcptNo: json['lastSaleRcptNo'] as String?,
      lastInvcNo: json['lastInvcNo'] as String?,
      lastSaleInvcNo: json['lastSaleInvcNo'] as int?,
      lastTrainInvcNo: json['lastTrainInvcNo'] as String?,
      lastProfrmInvcNo: json['lastProfrmInvcNo'] as String?,
      lastCopyInvcNo: json['lastCopyInvcNo'] as String?,
      vatTyCd: json['vatTyCd'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tin': tin,
      'taxprNm': taxprNm,
      'bsnsActv': bsnsActv,
      'bhfId': bhfId,
      'bhfNm': bhfNm,
      'bhfOpenDt': bhfOpenDt,
      'prvncNm': prvncNm,
      'dstrtNm': dstrtNm,
      'sctrNm': sctrNm,
      'locDesc': locDesc,
      'hqYn': hqYn,
      'mgrNm': mgrNm,
      'mgrTelNo': mgrTelNo,
      'mgrEmail': mgrEmail,
      'sdcId': sdcId,
      'mrcNo': mrcNo,
      'dvcId': dvcId,
      'intrlKey': intrlKey,
      'signKey': signKey,
      'cmcKey': cmcKey,
      'lastPchsInvcNo': lastPchsInvcNo,
      'lastSaleRcptNo': lastSaleRcptNo,
      'lastInvcNo': lastInvcNo,
      'lastSaleInvcNo': lastSaleInvcNo,
      'lastTrainInvcNo': lastTrainInvcNo,
      'lastProfrmInvcNo': lastProfrmInvcNo,
      'lastCopyInvcNo': lastCopyInvcNo,
      'vatTyCd': vatTyCd,
    };
  }
}
