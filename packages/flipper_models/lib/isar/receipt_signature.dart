import 'dart:convert';

class EBMApiResponse {
  EBMApiResponse({
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['resultCd'] = resultCd;
    jsonData['resultMsg'] = resultMsg;
    jsonData['resultDt'] = resultDt;
    jsonData['data'] = data.toJson();
    return jsonData;
  }

  String toRawJson() => json.encode(toJson());

  // from json
  factory EBMApiResponse.fromJson(Map<String, dynamic> json) {
    return EBMApiResponse(
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['rcptNo'] = rcptNo;
    jsonData['intrlData'] = intrlData;
    jsonData['rcptSign'] = rcptSign;
    jsonData['totRcptNo'] = totRcptNo;
    jsonData['vsdcRcptPbctDate'] = vsdcRcptPbctDate;
    jsonData['sdcId'] = sdcId;
    jsonData['mrcNo'] = mrcNo;
    return jsonData;
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
