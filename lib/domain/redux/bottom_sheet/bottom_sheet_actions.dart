import 'package:flipper_models/sheet.dart';
import 'package:flutter/material.dart';

class OnBottomSheetClosed {}

@immutable
class OnBottomSheetChanged {
  final Sheets sheet;

  const OnBottomSheetChanged({@required this.sheet});

  @override
  String toString() {
    return 'OnBranchLoaded{OnBottomSheetChanged: $sheet}';
  }
}
