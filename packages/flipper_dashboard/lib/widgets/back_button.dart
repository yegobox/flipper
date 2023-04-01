import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class BackButton extends StatelessWidget {
  BackButton({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: OutlinedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/arrow_left.svg',
              height: 14,
              width: 14,
              color: Colors.white,
            ),
            const Gap(5),
            Text('Back', style: TextStyle(color: Colors.white)),
          ],
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
          side: MaterialStateProperty.resolveWith<BorderSide>(
              (states) => BorderSide(
                    color: const Color(0xff006AFE),
                  )),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.blue.withOpacity(0.04);
              }
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed)) {
                return Colors.blue.withOpacity(0.12);
              }
              return null;
            },
          ),
        ),
        onPressed: () {
          _routerService.pop();
        },
      ),
    );
  }
}
