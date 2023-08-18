class ReceiptSignature {
  ReceiptSignature({
    required this.resultCd,
    required this.resultMsg,
    required this.resultDt,
    required this.data,
  });

  String resultCd;
  String resultMsg;
  String resultDt;
  Data data;

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCd'] = resultCd;
    data['resultMsg'] = resultMsg;
    data['resultDt'] = resultDt;
    data['data'] = this.data.toJson();
    return data;
  }

  // from json encoding
  factory ReceiptSignature.fromJson(Map<String, dynamic> json) {
    return ReceiptSignature(
      resultCd: json['resultCd'] as String,
      resultMsg: json['resultMsg'] as String,
      resultDt: json['resultDt'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Data {
  Data({
    required this.rcptNo,
    required this.intrlData,
    required this.rcptSign,
    required this.totRcptNo,
    required this.vsdcRcptPbctDate,
    required this.sdcId,
    required this.mrcNo,
  });

  int rcptNo;
  String intrlData;
  String rcptSign;
  int totRcptNo;
  String vsdcRcptPbctDate;
  String sdcId;
  String mrcNo;
  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rcptNo'] = rcptNo;
    data['intrlData'] = intrlData;
    data['rcptSign'] = rcptSign;
    data['totRcptNo'] = totRcptNo;
    data['vsdcRcptPbctDate'] = vsdcRcptPbctDate;
    data['sdcId'] = sdcId;
    data['mrcNo'] = mrcNo;
    return data;
  }

  // from json
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      rcptNo: json['rcptNo'] as int,
      intrlData: json['intrlData'] as String,
      rcptSign: json['rcptSign'] as String,
      totRcptNo: json['totRcptNo'] as int,
      vsdcRcptPbctDate: json['vsdcRcptPbctDate'] as String,
      sdcId: json['sdcId'] as String,
      mrcNo: json['mrcNo'] as String,
    );
  }
}
