import 'package:isar/isar.dart';

part 'feature.g.dart';

@Collection()
class Feature {
  Feature({required this.id, required this.name});

  late String id;
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
