library flipper_login;

import 'package:flipper_login/colors.dart';
import 'package:flipper_login/signup_login_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flipper_services/proxy.dart';

class MobileLogin extends StatefulWidget {
  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  Future<bool> _onWillPop() async {
    return false;
  }

  bool _systemSet = false;
  void getTimeAutomatic() async {
    bool isTimeAutomatic;
    isTimeAutomatic = await ProxyService.systemTime.isSystemTime();

    setState(() {
      _systemSet = isTimeAutomatic;
    });
  }

  @override
  void initState() {
    getTimeAutomatic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Column(
        children: <Widget>[
          Container(
            color: AppColors.mainColor,
            width: double.infinity,
            height: 400.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/fliper-logo.png',
                  width: 80.w,
                  height: 80.h,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Flipper',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Interact and grow your bussiness',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: SignUpLoginButton(
                isSystemTimeSet: _systemSet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
