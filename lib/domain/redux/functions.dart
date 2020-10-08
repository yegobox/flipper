import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/viewmodels/open_business_model.dart';
import 'package:flutter/material.dart';

Future<void> openBusiness({
  OpenBusinessModel model,
  CommonViewModel vm,
  String documentId,
  TextEditingController closeFLoat,
  TextEditingController openFLoat
}) async {
  model.openBusiness(
    vm: vm,
    documentId: documentId,
    closingFloat: double.parse(openFLoat.text),
    openingFloat: double.parse(closeFLoat.text),
  );
}
