import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class BackButton extends StatelessWidget {
  BackButton({Key? key, this.popCallback}) : super(key: key);

  final VoidCallback? popCallback;
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 200,
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Back',
                style: primaryTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12)),
          ],
        ),
        style: primaryButtonStyle.copyWith(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0.0),
              bottomRight: Radius.circular(2.0),
            ),
          )),
        ),
        onPressed: () {
          if (popCallback != null) {
            popCallback!();
          } else {
            _routerService.pop();
          }
        },
      ),
    );
  }
}
