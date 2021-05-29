import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_platform/universal_platform.dart';

final isAndroid = UniversalPlatform.isAndroid;

class SaleIndicator extends StatelessWidget {
  const SaleIndicator(
      {Key? key,
      this.totalAmount = 0,
      this.counts = 0,
      required this.onClick,
      required this.onLogout})
      : super(key: key);
  final double totalAmount;
  final int counts;
  final Function onClick;
  final Function onLogout;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      title: Container(
        color: Theme.of(context)
            .copyWith(canvasColor: Colors.transparent)
            .canvasColor,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Row(children: <Widget>[
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  onClick();
                },
                child: totalAmount == 0
                    ? Text(
                        'No Sale',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 16,
                              color: const Color(0xff363f47),
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Current Sale'),
                          Stack(
                            alignment: isAndroid
                                ? AlignmentDirectional.bottomCenter
                                : AlignmentDirectional.center,
                            children: [
                              Text(counts.toString()),
                              const IconButton(
                                icon: FaIcon(FontAwesomeIcons.clone),
                                onPressed: null,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onLogout();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: Text(
                  'Log Out',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 15,
                      color: const Color(0xff363f47),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
