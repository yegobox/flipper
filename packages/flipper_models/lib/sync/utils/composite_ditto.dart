import 'package:ditto_live/ditto_live.dart';
import 'package:supabase_models/brick/models/composite.model.dart';

/// A Ditto `composites` document (as `CapellaSync.saveComposite` writes it)
/// as a [Composite]. Numbers may arrive as int or double.
Composite compositeFromDittoDoc(Map<dynamic, dynamic> doc) {
  double? number(Object? value) => value is num ? value.toDouble() : null;
  String? text(Object? value) => value?.toString();
  return Composite(
    id: text(doc['id']) ?? text(doc['_id']),
    productId: text(doc['productId']),
    variantId: text(doc['variantId']),
    qty: number(doc['qty']),
    branchId: text(doc['branchId']),
    businessId: text(doc['businessId']),
    actualPrice: number(doc['actualPrice']),
  );
}

/// A combo's components from the Ditto `composites` collection, by parent
/// product and/or component variant. Empty when neither is given.
Future<List<Composite>> readCompositesFromDitto(
  Ditto ditto, {
  String? productId,
  String? variantId,
}) async {
  if (productId == null && variantId == null) return const [];
  final where = <String>[
    if (productId != null) 'productId = :productId',
    if (variantId != null) 'variantId = :variantId',
  ];
  final result = await ditto.store.execute(
    'SELECT * FROM composites WHERE ${where.join(' AND ')}',
    arguments: {
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
    },
  );
  return result.items.map((item) => compositeFromDittoDoc(item.value)).toList();
}
