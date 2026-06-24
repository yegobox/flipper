import 'package:supabase_models/brick/models/variant.model.dart';

/// Validates RRA identifiers required before calling tax stock IO during recount submit.
///
/// Caller must skip service variants ([Variant.itemTyCd] == '3') before calling.
String? missingRraIdentifiersMessageForStockRecountIo(Variant variant) {
  final cd = variant.itemCd;
  if (cd == null || cd.isEmpty || cd == 'null') {
    return 'missing item code (itemCd) required for RRA stock recount reporting';
  }
  final cls = variant.itemClsCd;
  if (cls == null || cls.isEmpty) {
    return 'missing item class code (itemClsCd) required for RRA stock recount reporting';
  }
  final nm = variant.itemNm;
  if (nm == null || nm.isEmpty) {
    return 'missing item name (itemNm) required for RRA stock recount reporting';
  }
  return null;
}
