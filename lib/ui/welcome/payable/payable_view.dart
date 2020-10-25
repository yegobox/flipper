import 'package:flipper/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'build_payable.dart';

class PayableView extends StatefulWidget {
  @override
  _PayableViewState createState() => _PayableViewState();
}

class _PayableViewState extends State<PayableView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      color: Theme.of(context)
          .copyWith(canvasColor: AppColors.darkBlue)
          .canvasColor,
      child: const BuildPayable(),
    );
  }
}
