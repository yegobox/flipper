library receipt;

import 'dart:developer';
import 'dart:io';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:flipper_models/isar/order_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart' as c;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;

/// [generatePdfAndPrint] example

class OmniPrinter {
  final doc = Document(version: PdfVersion.pdf_1_5, compress: true);
  Future<void> generatePdfAndPrint({
    String brandName = "yegobox shop",
    String brandAddress = "CITY CENTER, Kigali Rwanda",
    String brandTel = "27131153",
    String brandTIN = "101587390",
    String brandDescription = "We build app that server you!",
    String brandFooter = "yegobox shop",
    List<String>? emails,
    String? customerTin = "000000000",
    required List<OrderItem> items,
    required String receiptType,
    required String sdcReceiptNum,
    required String totalTax,
    required double totalB,
    required String totalB18,
    required double totalAEx,
    required double cash,
    required String cashierName,
    required double received,
    required String payMode,
    required String date,
    required String time,
    required String sdcId,
    required String internalData,
    required String receiptSignature,
    required String receiptQrCode,
    required int invoiceNum,
    required String mrc,
    required double totalPrice,
  }) async {
    ImageProvider? image;
    // https://github.com/flutter/flutter/issues/103803
    if (!kIsWeb) {
      const imageLogo = c.AssetImage(
        'assets/rralogo.jpg',
      );
      image = await flutterImageProvider(imageLogo);
    }

    List<Widget> rows = [];

    rows.add(Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(width: 10),
      image != null ? Image(image) : Text(""),
      Text(
        brandAddress,
      ),
      SizedBox(height: 1),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Tel:$brandTel",
          style: TextStyle(
              font: Font.helvetica(),
              fontBold: Font.helveticaBold(),
              fontSize: 14),
        ),
      ]),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'TIN:',
            style: TextStyle(
              fontBold: Font.helveticaBold(),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            brandTIN,
            style: TextStyle(
              fontBold: Font.helveticaBold(),
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
      SizedBox(height: 1),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Welcome to $brandName',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          'Client ID: $customerTin',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ]),

      // add wording
      if (receiptType == "NR")
        Text(
          'Refund',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      if (receiptType == "NR")
        Text(
          'REF.NORMAL RECEIPT:# $sdcReceiptNum',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
          ),
        ),
      if (receiptType == "NR")
        Text(
          'REFUND IS APPROVED FOR CLIENT ID:$customerTin',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
          ),
        ),
      if (receiptType == "CS")
        Text(
          'COPY',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      if (receiptType == "CS") SizedBox(height: 3),
      if (receiptType == "CS")
        Text(
          'REF.NORMAL RECEIPT#:$sdcReceiptNum',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      if (receiptType != "CS") SizedBox(height: 3),
      if (receiptType == "CS")
        Text(
          'REFUND IS APPROVED FOR CLIENT ID:$customerTin',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      if (receiptType == "TS")
        Text(
          'TRAINING MODE',
          style: TextStyle(
            fontBold: Font.helveticaBold(),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
    ]));
    rows.add(
      Column(children: [
        Divider(height: 1),
      ]),
    );
    // end of heading
    for (OrderItem item in items) {
      double total = item.price * item.qty;

      String taxLabel = item.isTaxExempted ? "-EX" : "-B 18%";
      rows.add(Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(item.name.length > 5 ? item.name.substring(0, 5) : item.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text("RW2BCXU0000001"),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("${item.price} X ${item.qty}"),
          Spacer(),
          Text(
            "$total $taxLabel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ])
      ]));
    }

    Column row = Column(
      children: [],
    );
    if (receiptType != "CS") {
      rows.add(
        Column(children: [SizedBox(height: 10)]),
      );
    }
    if (receiptType == "TS" || receiptType == "PS") {
      row = Column(children: [
        SizedBox(),
        Text(
          'THIS IS NOT AN OFFICIAL RECEIPT',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(),
      ]);
      rows.add(row);
    }
    rows.add(
      Column(children: [
        Divider(height: 1),
      ]),
    );
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'TOTAL:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(),
      Text((receiptType == "NR") ? "-$totalPrice" : "$totalPrice",
          style: TextStyle(fontWeight: FontWeight.bold))
    ]));
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'TOTAL A-EX:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(),
      Text((receiptType == "NR") ? "-$totalAEx" : totalAEx.toString(),
          style: TextStyle(fontWeight: FontWeight.bold))
    ]));
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'TOTAL B-18%:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(),
      Text((receiptType == "NR") ? "-$totalB18" : totalB18,
          style: TextStyle(fontWeight: FontWeight.bold))
    ]));

    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'TOTAL TAX B:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(),
        Text((receiptType == "NR") ? "-$totalB" : totalB.toString(),
            style: TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'TOTAL TAX:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(),
        Text((receiptType == "NR") ? "-$totalTax" : totalTax,
            style: TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 1),
      ]),
    );

    rows.add(
      Column(children: [
        SizedBox(height: 1),
      ]),
    );
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'CASH:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(),
      Text(received.toString(), style: TextStyle(fontWeight: FontWeight.bold))
    ]));
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'ITEMS NUMBER:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(),
      Text(items.length.toString(),
          style: TextStyle(fontWeight: FontWeight.bold))
    ]));
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'Cashier Name:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(),
      Text(cashierName.toString(),
          style: TextStyle(fontWeight: FontWeight.bold))
    ]));

    rows.add(
      Column(children: [
        SizedBox(height: 1),
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'Received Amount: $received',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text("Change: ${cash - received}",
            style: TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 1),
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 10),
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text('Pay Mode:', style: TextStyle(fontWeight: FontWeight.bold)),
        Spacer(),
        Text(
          payMode,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
    );
    rows.add(
      Column(children: [
        Divider(height: 1),
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 10),
      ]),
    );
    if (receiptType == "TS") {
      row = Column(children: [
        SizedBox(),
        Text(
          'TRAINING MODE',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(),
      ]);
      rows.add(row);
    }

    if (receiptType == "PS") {
      row = Column(children: [
        SizedBox(),
        Text(
          'PROFORMA',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(),
      ]);
      rows.add(row);
    }
    //
    var x = 0;
    final dashesInternalData = {2, 3, 4, 5, 6, 7};

    final replacedInternalData = internalData.splitMapJoin(RegExp('....'),
        onNonMatch: (s) => dashesInternalData.contains(x++) ? '-' : '');

    final dashesReceiptSignature = {1, 2, 3, 4};

    var y = 0;
    final replacedReceiptSignature = receiptSignature.splitMapJoin(
        RegExp('....'),
        onNonMatch: (s) => dashesReceiptSignature.contains(y++) ? '-' : '');

    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(),
        Text("SDC INFORMATION",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(),
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 1),
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
            width: 150,
            child: Text(
              'Date Time: $date $time',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ]),
    );
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'SDC ID:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Spacer(),
      Text(sdcId, style: TextStyle(fontWeight: FontWeight.bold))
    ]));
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'RECEIPT NUMBER:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Text("$sdcReceiptNum $receiptType",
            style: TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 10),
      ]),
    );
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text("Internal Data:", style: TextStyle(fontWeight: FontWeight.bold)),
    ]));
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(replacedInternalData,
          style: TextStyle(fontWeight: FontWeight.normal)),
    ]));
    rows.add(
      Column(children: [
        SizedBox(height: 1),
      ]),
    );
    rows.add(
      Column(children: [
        Text("Receipt Signature:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
            replacedReceiptSignature.substring(
                0, replacedReceiptSignature.length - 1),
            style: TextStyle(fontWeight: FontWeight.normal)),
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 4),
      ]),
    );

    rows.add(Column(children: [
      SizedBox(),
      Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(
              errorCorrectLevel: BarcodeQRCorrectionLevel.high,
            ),
            data: receiptQrCode,
          ),
        ),
      ),
      SizedBox(),
    ]));
    rows.add(
      Column(children: [
        SizedBox(height: 4),
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'INVOICE NUMBER:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(invoiceNum.toString(),
            style: TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
    rows.add(
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
            child: Text(
          'DATE TIME: $date $time',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ]),
    );

    rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'MRC',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(mrc, style: TextStyle(fontWeight: FontWeight.bold))
    ]));
    rows.add(
      Column(children: [
        SizedBox(height: 10),
        Text('Thank you!'),
      ]),
    );
    rows.add(
      Column(children: [
        SizedBox(height: 10),
        Text('EBM v2: v1.5'),
      ]),
    );
    // end of footer
    doc.addPage(
      Page(
        pageFormat: PdfPageFormat.roll80,
        orientation: PageOrientation.portrait,
        build: (context) => Column(
          children: rows,
        ),
      ),
    );
    // experiment layout the pdf file
    Uint8List pdfData = await doc.save();

    if (ProxyService.box.isAutoPrintEnabled()) {
      if (isDesktopOrWeb) {
        await Printing.layoutPdf(
            name: DateTime.now()
                .toIso8601String()
                .replaceAll('-', '')
                .replaceAll('.', '')
                .replaceAll(':', ''),
            onLayout: (PdfPageFormat format) async => pdfData);
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.manageExternalStorage
        ].request();
        if (statuses[Permission.storage]!.isGranted) {
          Directory? dir = await DownloadsPath.downloadsDirectory();
          var i = 0;
          final path = dir?.path;
          await for (final page in Printing.raster(pdfData, dpi: 150)) {
            final png = await page.toPng();
            final file = File(p.normalize(
                '$path/page-${i.toString().padLeft(3, DateTime.now().toIso8601String().replaceAll('-', '').replaceAll('.', '').replaceAll(':', ''))}.png'));
            await file.writeAsBytes(png);
            log('Saved to ${file.absolute.path}');
            i++;
          }
        } else {
          log('no permission granted');
        }
      }
    } else {
      await Printing.sharePdf(
        bytes: pdfData,
        filename:
            "${DateTime.now().toIso8601String().replaceAll('-', '').replaceAll('.', '').replaceAll(':', '')}.pdf",
        subject: "receipt",
        body: "Thank you for visiting us",
        emails: emails,
      );
    }
  }
}
