import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class BackButton extends StatelessWidget {
  BackButton({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 200,
      child: OutlinedButton(
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
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ),
        onPressed: () {
          _routerService.pop();
        },
      ),
    );
  }
}
