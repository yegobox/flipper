library flipper_models;

import './tenant.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class Permissionsync {
  Permissionsync({
    this.id = 0,
    required this.name,
  });
  @Id(assignable: true)
  int id;
  String name;

  final product = ToOne<TenantSync>();

  factory Permissionsync.fromJson(Map<String, dynamic> json) =>
      Permissionsync(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
