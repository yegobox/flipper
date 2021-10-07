library flipper_models;

import 'package:objectbox/objectbox.dart';

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
@Entity()
class Attendance {
  Attendance({this.id = 0});

  @Id(assignable: true)
  int id;
}
