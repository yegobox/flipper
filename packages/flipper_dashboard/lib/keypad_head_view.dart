import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyPadHead extends StatelessWidget {
  KeyPadHead(
      {Key? key,
      this.amount = 0.0,
      this.note,
      required this.onClick,
      required this.controller,
      this.payable,
      required this.tab})
      : super(key: key);
  final double amount;
  final String? note;
  final Function onClick;
  final TextEditingController controller;
  final Widget? payable;
  final int tab;
  final log = getLogger('KeyPadHead');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: payable ?? const SizedBox.shrink(),
        ),
        tab == 0
            ? InkWell(
                onTap: () {
                  onClick();
                },
                child: IgnorePointer(
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10.w,
                      top: 30.h,
                      left: 10.w,
                      bottom: 15.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: const TextButton(
                                onPressed: null,
                                child: Text(
                                  'AddNote',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'FRw' + amount.toString(),
                            textAlign: TextAlign.right,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 25.0,
                              color: Color(0xffc2c7cc),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
