import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/power_sync/schema.dart';

part 'all.g.dart';

@JsonSerializable(explicitToJson: true)
class StockRequest {
  StockRequest({
    this.id,
    required this.main_branch_id,
    required this.sub_branch_id,
    required this.created_at,
    required this.status,
    this.delivery_date,
    this.delivery_note,
    this.order_note,
    this.customer_received_order = false,
    this.driver_request_delivery_confirmation = false,
    this.driver_id,
    required this.items,
    this.updated_at,
  });

  factory StockRequest.fromJson(Map<String, Object?> json) =>
      _$StockRequestFromJson(json);

  // @Id()
  final String? id;

  final int main_branch_id;
  final int sub_branch_id;
  @TimestampConverter()
  final DateTime created_at;
  final String status;
  @TimestampConverter()
  final DateTime? delivery_date;
  final String? delivery_note;
  final String? order_note;
  final bool customer_received_order;
  final bool driver_request_delivery_confirmation;
  final int? driver_id;
  final List<TransactionItem> items;
  @TimestampConverter()
  final DateTime? updated_at;

  Map<String, Object?> toJson() => _$StockRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransactionItem {
  TransactionItem({
    required this.item_id,
    required this.quantity,
    this.id,
    this.name,
    this.quantity_requested,
    this.quantity_approved,
    this.quantity_shipped,
    this.transaction_id,
    this.variant_id,
    this.qty = 0.0,
    this.price = 0.0,
    this.discount = 0.0,
    this.type,
    this.remaining_stock = 0.0,
    this.created_at,
    this.updated_at,
    this.is_tax_exempted = false,
    this.is_refunded = false,
    this.done_with_transaction,
    this.active,
    this.dc_rt = 0.0,
    this.dc_amt = 0.0,
    this.taxbl_amt = 0.0,
    this.tax_amt = 0.0,
    this.tot_amt = 0.0,
    this.item_seq,
    this.isrcc_cd,
    this.isrcc_nm = "",
    this.isrc_rt = 0,
    this.isrc_amt = 0,
    this.tax_ty_cd,
    this.bcd,
    this.item_cls_cd,
    this.item_ty_cd,
    this.item_std_nm,
    this.orgn_nat_cd,
    this.pkg,
    this.item_cd,
    this.pkg_unit_cd = "CT",
    this.qty_unit_cd = "BX",
    this.item_nm,
    this.prc = 0.0,
    this.sply_amt = 0.0,
    this.tin,
    this.bhf_id,
    this.dft_prc,
    this.add_info,
    this.isrc_aplcby_yn,
    this.use_yn,
    this.regr_id,
    this.regr_nm,
    this.modr_id,
    this.modr_nm,
    this.last_touched,
    this.deleted_at,
    this.action,
    this.branch_id,
    this.ebm_synced = false,
    this.part_of_composite = false,
    this.composite_price = 0,
  });

  factory TransactionItem.fromJson(Map<String, Object?> json) =>
      _$TransactionItemFromJson(json);

  final int item_id;
  final int quantity;

  // Common fields
  // @Id()
  final int? id;
  final String? name;
  final int? quantity_requested;
  final int? quantity_approved;
  final int? quantity_shipped;
  final int? transaction_id;
  final int? variant_id;
  final double qty;
  final double price;
  final double discount;
  final String? type;
  final double remaining_stock;
  final String? created_at;
  final String? updated_at;
  final bool is_tax_exempted;
  final bool is_refunded;

  // Transaction-related fields
  final bool? done_with_transaction;
  final bool? active;

  // RRA fields
  final double dc_rt;
  final double dc_amt;
  final double taxbl_amt;
  final double tax_amt;
  final double tot_amt;

  // Variant-related fields
  final int? item_seq;
  final String? isrcc_cd;
  final String? isrcc_nm;
  final int? isrc_rt;
  final int? isrc_amt;
  final String? tax_ty_cd;
  final String? bcd;
  final String? item_cls_cd;
  final String? item_ty_cd;
  final String? item_std_nm;
  final String? orgn_nat_cd;
  final String? pkg;
  final String? item_cd;
  final String? pkg_unit_cd;
  final String? qty_unit_cd;
  final String? item_nm;
  final double prc;
  final double sply_amt;
  final int? tin;
  final String? bhf_id;
  final double? dft_prc;
  final String? add_info;
  final String? isrc_aplcby_yn;
  final String? use_yn;
  final String? regr_id;
  final String? regr_nm;
  final String? modr_id;
  final String? modr_nm;

  final DateTime? last_touched;
  final DateTime? deleted_at;
  final String? action;

  final int? branch_id;
  final bool ebm_synced;
  final bool part_of_composite;
  final double composite_price;

  Map<String, Object?> toJson() => _$TransactionItemToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@Collection<StockRequest>(stockRequestsTable)
final stockRequestsRef = StockRequestCollectionReference();

// class StockRequestCollectionReference {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get a reference to the collection.
//   CollectionReference<StockRequest> get ref =>
//       _firestore.collection(stockRequestsTable).withConverter<StockRequest>(
//             fromFirestore: (snapshot, _) => StockRequest.fromJson(
//                 snapshot.data() as Map<String, dynamic>),
//             toFirestore: (stockRequest, _) => stockRequest.toJson(),
//           );

//   // Add a new stock request.
//   Future<void> addStockRequest(StockRequest stockRequest) async {
//     await ref.add(stockRequest);
//   }

//   // Get a stock request by id.
//   Future<StockRequest?> getStockRequestById(String id) async {
//     DocumentSnapshot<StockRequest> snapshot = await ref.doc(id).get();
//     return snapshot.data();
//   }

//   // Update a stock request.
//   Future<void> updateStockRequest(String id, StockRequest stockRequest) async {
//     await ref.doc(id).update(stockRequest.toJson());
//   }

//   // Delete a stock request.
//   Future<void> deleteStockRequest(String id) async {
//     await ref.doc(id).delete();
//   }

//   // Get a stream of all stock requests.
//   Stream<QuerySnapshot<StockRequest>> getStockRequests() {
//     return ref.snapshots();
//   }
// }
