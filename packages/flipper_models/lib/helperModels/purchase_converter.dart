import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_models/brick/models/purchase.model.dart' as models;

class PurchaseConverter implements JsonConverter<models.Purchase, Map<String, dynamic>> {
  const PurchaseConverter();

  @override
  models.Purchase fromJson(Map<String, dynamic> json) {
    return models.Purchase.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(models.Purchase purchase) {
    return purchase.toFlipperJson();
  }
}
