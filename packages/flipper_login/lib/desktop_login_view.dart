import 'package:flipper_login/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DesktopLoginView extends StatelessWidget {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blue,
                alignment: Alignment.center,
                width: double.infinity,
                height: 100.0,
              ),
              Expanded(
                child: Container(
                  color: HexColor('#dddbd1'),
                  alignment: Alignment.center,
                  width: double.infinity,
                ),
              )
            ],
          ),
          Positioned(
            top: 40,
            left: 200,
            right: 200,
            bottom: 20,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              //
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 100.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const Spacer(),
                  /// the code here will be listened to,
                  /// when android scann it will pick the code and send it to the server along with
                  /// the business/user that want to log in
                  /// the server will return the business that is trying to log in
                  /// the app will be in logged in state if we have an object
                  /// go to initial page continue as normal.
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 350, right: 40.0, top: 120),
                    child: SizedBox(
                      height: 100.0,
                      width: 200.0,
                      child: QrImage(
                        data: "1234567890",
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
