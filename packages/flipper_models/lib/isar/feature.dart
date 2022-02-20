import 'package:isar/isar.dart';

part 'feature.g.dart';

@Collection()
class Feature {
  Feature({this.id = 0, required this.name});

  late int id = Isar.autoIncrement;
  late String name;

  factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );
  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
