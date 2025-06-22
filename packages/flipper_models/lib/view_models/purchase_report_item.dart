import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/brick/models/purchase.model.dart';

class PurchaseReportItem {
  final Variant variant;
  final Purchase? purchase; // Purchase can be null if not found

  PurchaseReportItem({required this.variant, this.purchase});

  // Convenience getters
  String? get supplierName => purchase?.spplrNm;
  String? get supplierTin => purchase?.spplrTin;
}
