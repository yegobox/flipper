library pos;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class KeyPadView extends StatelessWidget {
  const KeyPadView({Key? key, required this.model}) : super(key: key);
  final BusinessHomeViewModel model;
  // final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Column(
          children: [Keyboard(model: model)],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Keyboard extends StatelessWidget {
  Keyboard({Key? key, required this.model}) : super(key: key);
  final BusinessHomeViewModel model;
  var myDynamicAspectRatio = 1000 / 1;
  OverlayEntry? sticky;
  double maxHeight = 0;
  double maxWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: (isWindows || isMacOs)
            ? EdgeInsets.only(left: 1.w, right: 15.w, bottom: 1.h)
            : EdgeInsets.all(0),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('1');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height.h,
                              width: MediaQuery.of(context).size.width.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffc1c6cb),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '1',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 30.sp.sp,
                                        color: const Color(0xff3d454c),
                                        fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('2');
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height.h.h,
                            width: MediaQuery.of(context).size.width.w.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffc1c6cb)),
                                right: BorderSide(color: Color(0xffc1c6cb)),
                                bottom: BorderSide(color: Color(0xffc1c6cb)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '2',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 30.sp.sp,
                                      color: const Color(0xff3d454c),
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('3');
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height.h,
                            width: MediaQuery.of(context).size.width.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffc1c6cb)),
                                right: BorderSide(color: Color(0xffc1c6cb)),
                                bottom: BorderSide(color: Color(0xffc1c6cb)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '3',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 30.sp,
                                      color: const Color(0xff3d454c),
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('4');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height.h,
                              width: MediaQuery.of(context).size.width.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Color(0xffc1c6cb)),
                                  right: BorderSide(color: Color(0xffc1c6cb)),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '4',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 30.sp,
                                        color: const Color(0xff3d454c),
                                        fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('5');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height.h,
                              width: MediaQuery.of(context).size.width.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Color(0xffc1c6cb)),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '5',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 30.sp,
                                        color: const Color(0xff3d454c),
                                        fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('6');
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height.h,
                            width: MediaQuery.of(context).size.width.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xffc1c6cb)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '6',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 30.sp,
                                      color: const Color(0xff3d454c),
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('7');
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height.h,
                            width: MediaQuery.of(context).size.width.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffc1c6cb)),
                                left: BorderSide(color: Color(0xffc1c6cb)),
                                right: BorderSide(color: Color(0xffc1c6cb)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '7',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 30.sp,
                                      color: const Color(0xff3d454c),
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('8');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height.h,
                              width: MediaQuery.of(context).size.width.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Color(0xffc1c6cb)),
                                  right: BorderSide(color: Color(0xffc1c6cb)),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '8',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 30.sp,
                                        color: const Color(0xff3d454c),
                                        fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('9');
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height.h,
                            width: MediaQuery.of(context).size.width.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffc1c6cb)),
                                right: BorderSide(color: Color(0xffc1c6cb)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '9',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 30.sp,
                                      color: const Color(0xff3d454c),
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('C');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height.h,
                              width: MediaQuery.of(context).size.width.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Color(0xffc1c6cb)),
                                  left: BorderSide(color: Color(0xffc1c6cb)),
                                  right: BorderSide(color: Color(0xffc1c6cb)),
                                  bottom: BorderSide(color: Color(0xffc1c6cb)),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'C',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 30.sp,
                                        color: const Color(0xff3d454c),
                                        fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('0');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height.h,
                              width: MediaQuery.of(context).size.width.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Color(0xffc1c6cb)),
                                  right: BorderSide(color: Color(0xffc1c6cb)),
                                  bottom: BorderSide(color: Color(0xffc1c6cb)),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '0',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 30.sp,
                                        color: const Color(0xff3d454c),
                                        fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            model.addKey('+');
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height.h,
                            width: MediaQuery.of(context).size.width.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffc1c6cb)),
                                right: BorderSide(color: Color(0xffc1c6cb)),
                                bottom: BorderSide(color: Color(0xffc1c6cb)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 40,
                                      color: const Color(0xff2996cc),
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  const KeyboardKey(this._keyValue, this.model);

  final BusinessHomeViewModel model;
  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 100.w,
        height: MediaQuery.of(context).size.height.h,
        child: InkWell(
          onTap: () => {model.addKey(_keyValue)},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                width: 0.w,
              ),
            ),
            child: Center(
              child: Text(
                _keyValue,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 30.sp, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
