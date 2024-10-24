import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    int? id,
    
    // Receipt identification
    int? rcptNo,
    int? totRcptNo,
    int? invcNo,
    int? invoiceNumber,
    String? receiptType,
    
    // Result information
    String? resultCd,
    String? resultMsg,
    String? resultDt,
    
    // Technical data
    String? intrlData,
    String? rcptSign,
    String? vsdcRcptPbctDate,
    String? sdcId,
    String? mrcNo,
    String? qrCode,
    
    // Relationships
    int? branchId,
    int? transactionId,
    
    // Timestamps
    DateTime? lastTouched,
    DateTime? whenCreated,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) => 
      _$ReceiptFromJson(json);
      
  const Receipt._();  // This is needed for custom getters
}

/// Extension methods for Receipt helpers
extension ReceiptHelpers on Receipt {
  /// Checks if receipt has valid identification numbers
  bool get hasValidIdentification =>
      rcptNo != null && totRcptNo != null;
      
  /// Checks if receipt has complete result information
  bool get hasCompleteResult =>
      resultCd != null && 
      resultMsg != null && 
      resultDt != null;
      
  /// Checks if receipt has valid technical data
  bool get hasValidTechnicalData =>
      sdcId != null && 
      mrcNo != null && 
      qrCode != null;
      
  /// Checks if receipt is properly linked to transaction and branch
  bool get isProperlyLinked =>
      branchId != null && 
      transactionId != null;
      
  /// Gets the age of the receipt
  Duration? get age {
    if (whenCreated == null) return null;
    return DateTime.now().difference(whenCreated!);
  }
  
  /// Check if receipt was created today
  bool get isCreatedToday {
    if (whenCreated == null) return false;
    final now = DateTime.now();
    return whenCreated!.year == now.year && 
           whenCreated!.month == now.month && 
           whenCreated!.day == now.day;
  }
}