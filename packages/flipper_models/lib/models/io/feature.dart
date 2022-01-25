import './subscription.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class Feature {
  Feature({this.id = 0, required this.name});

  @Id(assignable: true)
  int id;
  String name;

  final subscription = ToOne<Subscription>();
  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );

factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
