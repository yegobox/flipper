import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/receipt_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';

mixin ReceiptMixin implements ReceiptInterface {
  Repository get repository;

  @override
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter,
      required int invoiceNumber}) async {
    int branchId = ProxyService.box.getBranchId()!;

    Receipt receipt = Receipt(
        branchId: branchId,
        resultCd: signature.resultCd,
        resultMsg: signature.resultMsg,
        rcptNo: signature.data?.rcptNo ?? 0,
        intrlData: signature.data?.intrlData ?? "",
        rcptSign: signature.data?.rcptSign ?? "",
        qrCode: qrCode,
        receiptType: receiptType,
        invoiceNumber: invoiceNumber,
        vsdcRcptPbctDate: signature.data?.vsdcRcptPbctDate ?? "",
        sdcId: signature.data?.sdcId ?? "",
        totRcptNo: signature.data?.totRcptNo ?? 0,
        mrcNo: signature.data?.mrcNo ?? "",
        transactionId: transaction.id,
        invcNo: counter.invcNo,
        whenCreated: whenCreated,
        resultDt: signature.resultDt ?? "");
    Receipt? existingReceipt = (await repository.get<Receipt>(
            query: Query(where: [
      Where('transactionId').isExactly(transaction.id),
    ])))
        .firstOrNull;

    if (existingReceipt != null) {
      existingReceipt
        ..resultCd = receipt.resultCd
        ..resultMsg = receipt.resultMsg
        ..rcptNo = receipt.rcptNo
        ..intrlData = receipt.intrlData
        ..rcptSign = receipt.rcptSign
        ..qrCode = receipt.qrCode
        ..receiptType = receipt.receiptType
        ..invoiceNumber = receipt.invoiceNumber
        ..vsdcRcptPbctDate = receipt.vsdcRcptPbctDate
        ..sdcId = receipt.sdcId
        ..totRcptNo = receipt.totRcptNo
        ..mrcNo = receipt.mrcNo
        ..invcNo = receipt.invcNo
        ..whenCreated = receipt.whenCreated
        ..resultDt = receipt.resultDt;
      return await repository.upsert(existingReceipt,
          query: Query(
            action: QueryAction.update,
          ));
    } else {
      return await repository.upsert(receipt,
          query: Query(
            action: QueryAction.insert,
          ));
    }
  }
}
