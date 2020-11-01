import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

import 'build_payable.dart';

class PayableView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      color: Theme.of(context)
          .copyWith(canvasColor: HexColor('#2996CC'))
          .canvasColor,
      child: const BuildPayable(),
    );
  }
}
