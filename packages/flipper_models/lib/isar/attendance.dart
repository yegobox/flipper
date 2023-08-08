library flipper_models;

/// open on using the feature
/// the attendance google sheet document is created if does not exist
/// it is added to the config of the user with type, now type = attendance
/// rename other exisiting config as report as type
/// change in report controller to look for type == report when looging for exising sheet for report
/// google sheet attendance document has name,phone number,date,checkin,checkout,total hours
/// the ticky part is that the information of one user should be in one row
/// the user use his smartphone to checkin and checkout, user bring his phone to the office and near to our NFC tag to check in and checkout
/// should have flipper, any be flipper social or business it works regardless
/// the user can checkin and checkout multiple times
/// the algorithm knows if is the first time per day to check in and checkout otherwise
/// so if per day we have 1/2 checkin and 1/2 checkout, the algorithm will know that is the first time
/// if 2/2 checkin and 2/2 checkout, the algorithm will know that is the second time
/// if 3/2 checkin and 3/2 checkout, the algorithm will know that is the third time then checkin
///

class AttendanceSync {
  AttendanceSync({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.fullName,
    required this.phoneNumber,
    required this.checkInDate,
    required this.checkInTime,
    required this.vaccinationCode,
    required this.livingAt,
    required this.cell,
    required this.district,
  });

  late String id;

  int businessId;
  String businessName;
  String fullName;
  String phoneNumber;
  String checkInDate;
  String checkInTime;
  String vaccinationCode;
  String livingAt;
  String cell;
  String district;

  factory AttendanceSync.fromJson(Map<dynamic, dynamic> json) => AttendanceSync(
        id: json["id"],
        businessId: json["businessId"],
        businessName: json["businessName"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        checkInDate: json["checkInDate"],
        checkInTime: json["checkInTime"],
        vaccinationCode: json["vaccinationCode"],
        livingAt: json["livingAt"],
        cell: json["cell"],
        district: json["district"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "businessName": businessName,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "checkInDate": checkInDate,
        "checkInTime": checkInTime,
        "vaccinationCode": vaccinationCode,
        "livingAt": livingAt,
        "cell": cell,
        "district": district
      };
}
