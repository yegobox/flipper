import 'dart:convert';

List<JCounter> jCounterFromJson(String str) =>
    List<JCounter>.from(json.decode(str).map((x) => JCounter.fromJson(x)));

String jCounterToJson(List<JCounter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
JCounter jSingleCounterFromJson(String str) =>
    JCounter.fromJson(json.decode(str));

class JCounter {
  JCounter({
    required this.id,
    required this.businessId,
    required this.branchId,
    required this.receiptType,
    required this.totRcptNo,
    required this.curRcptNo,
  });

  late String id;
  int businessId;
  int branchId;
  String receiptType;
  int totRcptNo;
  int curRcptNo;

  factory JCounter.fromJson(Map<String, dynamic> json) => JCounter(
        id: json["id"],
        businessId: json["businessId"],
        branchId: json["branchId"],
        receiptType: json["receiptType"],
        totRcptNo: json["totRcptNo"],
        curRcptNo: json["curRcptNo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "branchId": branchId,
        "receiptType": receiptType,
        "totRcptNo": totRcptNo,
        "curRcptNo": curRcptNo,
      };
}
