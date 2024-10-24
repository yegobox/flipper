import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';
part 'branch.g.dart'; // Needed for JSON serialization

@freezed
class Branch with _$Branch {
  factory Branch({
    int? id,   
    int? serverId,
    bool? active,
    String? description,
    String? name,
    int? businessId,
    String? longitude,
    String? latitude,
    String? location,

    @Default(false) bool isDefault,
    DateTime? lastTouched,
    DateTime? deletedAt,
    @Default(false) bool isOnline,
  }) = _Branch;

  // Optional: factory constructor for creating the object from JSON
  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
