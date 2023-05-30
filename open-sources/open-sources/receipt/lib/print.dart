library receipt;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pdf/widgets.dart';
import 'package:receipt/omni_printer.dart';

class Print {
  DateTime dateTime = DateTime.now();
  String date = "";
  String time = "";
  double totalPrice = 0;
  double totalItems = 0;
  List<TableRow> rows = [];
  List<OrderItem> orderItems = [];
  ImageProvider? netImage;
  Future<String> receiptQr(String url) async {
    return url;
  }

  Future<List<TableRow>> feed(
    List<OrderItem> items,
  ) async {
    date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    time = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    orderItems = items;
    for (var item in items) {
      // if the isRefunded is null i.e the item has not been refunded so we add it to the total price
      if (item.isRefunded == null) {
        totalItems = totalItems + 1;
        double total = item.price * item.qty;
        totalPrice = total + totalPrice;
        String taxLabel = item.isTaxExempted ? "-EX" : "-B";
        rows.add(TableRow(children: [
          Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
        ]));
        rows.add(TableRow(children: [
          Text((item.price).toString()),
          Text(item.qty.toString()),
          Text(
            "$total $taxLabel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ]));
        rows.add(TableRow(children: [
          SizedBox(height: 1),
        ]));
      }
    }
    return rows;
  }

  print({
    required double grandTotal,
    required String currencySymbol,
    required String totalTax,
    required double totalB,
    required String totalB18,
    required double totalAEx,
    required double cash,
    required double received,
    required String sdcId,
    required String sdcReceiptNum,
    required int invoiceNum,
    required String brandName,
    required String brandAddress,
    required String brandTel,
    required String brandTIN,
    required String brandDescription,
    required String brandFooter,
    required String cashierName,
    required String payMode,
    required String mrc,
    required String internalData,
    required String receiptSignature,
    required String receiptQrCode,
    required List<String> emails,
    required String? customerTin,
    required String receiptType,
  }) {
    receiptQr(receiptQrCode).then((qrCode) {
      OmniPrinter printer;
      printer = OmniPrinter();
      if (ProxyService.box.isAutoPrintEnabled()) {
        printer.generatePdfAndPrint(
          brandName: brandName,
          brandAddress: brandAddress,
          brandDescription: brandDescription,
          brandTel: brandTel,
          brandTIN: brandTIN,
          brandFooter: brandFooter,
          emails: emails,
          customerTin: customerTin.toString(),
          receiptType: receiptType,
          sdcReceiptNum: sdcReceiptNum,
          items: orderItems,
          totalAEx: totalAEx,
          totalB18: totalB18,
          totalB: totalB,
          totalTax: totalTax,
          cash: cash,
          cashierName: cashierName,
          received: received,
          payMode: payMode,
          date: date,
          time: time,
          sdcId: sdcId,
          internalData: internalData,
          receiptSignature: receiptSignature,
          receiptQrCode: qrCode,
          invoiceNum: invoiceNum,
          mrc: mrc,
          totalPrice: 0,
        );
      } else {
        printer.generatePdfAndPrint(
          brandName: brandName,
          brandAddress: brandAddress,
          brandDescription: brandDescription,
          brandTel: brandTel,
          brandTIN: brandTIN,
          brandFooter: brandFooter,
          emails: emails,
          customerTin: customerTin.toString(),
          receiptType: receiptType,
          sdcReceiptNum: sdcReceiptNum,
          items: orderItems,
          totalAEx: totalAEx,
          totalB18: totalB18,
          totalB: totalB,
          totalTax: totalTax,
          cash: cash,
          cashierName: cashierName,
          received: received,
          payMode: payMode,
          date: date,
          time: time,
          sdcId: sdcId,
          internalData: internalData,
          receiptSignature: receiptSignature,
          receiptQrCode: qrCode,
          invoiceNum: invoiceNum,
          mrc: mrc,
          totalPrice: 0,
        );
      }
    });
  }
}
