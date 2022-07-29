library flipper_models;

import 'package:isar/isar.dart';
part 'counter.g.dart';

@Collection()
class Counter {
  Counter({this.id, this.backed = false});
  Id? id = Isar.autoIncrement;
  late int businessId;
  late int branchId;
  late String receiptType;
  late int totRcptNo;
  late int curRcptNo;

  /// this means that the server and the app has same counter
  /// otherwise the receipt could be generated until next sync with server is completed
  bool? backed;

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "businessId": businessId,
        "receiptType": receiptType,
        "branchId": branchId,
        "totRcptNo": totRcptNo,
        "curRcptNo": curRcptNo,
        "backed": backed
      };
}
