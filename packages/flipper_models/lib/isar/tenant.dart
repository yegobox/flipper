library flipper_models;

import 'package:flipper_models/isar_models.dart';

part 'tenant.g.dart';

@Collection()
class ITenant {
  ITenant(
      {this.id,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.businessId});
  Id? id = Isar.autoIncrement;
  late String name;
  late String phoneNumber;
  late String email;
  late int businessId;
}
