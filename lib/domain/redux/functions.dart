import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/viewmodels/open_business_model.dart';
import 'package:flutter/material.dart';

Future<void> openBusiness({
  OpenBusinessModel model,
  CommonViewModel vm,
  bool open = false,
  String documentId,
  String businessState,
  TextEditingController note,
  TextEditingController float
}) async {
  model.openBusiness(
    vm: vm,
    documentId: documentId,
    float: double.parse(float.text),
    businessState:businessState,
    note: note.text,
  );
}
