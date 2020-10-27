import 'package:flipper/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'build_payable.dart';

class PayableView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      color: Theme.of(context)
          .copyWith(canvasColor: Colors.blue)
          .canvasColor,
      child: const BuildPayable(),
    );
  }
}
