import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

final willPopProvider = StateNotifierProvider<WillPopNotifier, bool>((ref) {
  return WillPopNotifier();
});

class WillPopNotifier extends StateNotifier<bool> {
  WillPopNotifier() : super(false);

  void canGoBack({required bool condition}) {
    state = condition;
  }
}

onWillPop(
    {required BuildContext context,
    required String navigationPurpose,
    required String message}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text(message),
        actions: <Widget>[
          OutlinedButton(
            child: Text('No',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            style: primaryButtonStyle,
            onPressed: () {
              Navigator.pop(context);
              ProviderScope.containerOf(context)
                  .read(willPopProvider.notifier)
                  .canGoBack(condition: false);
            },
          ),
          OutlinedButton(
            child: Text('Yes',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            style: primaryButtonStyle,
            onPressed: () {
              final _routerService = locator<RouterService>();
              if (navigationPurpose == NavigationPurpose.home) {
                _routerService.navigateTo(FlipperAppRoute());
                return;
              }
              Navigator.pop(context);
              Navigator.pop(context);
              ProviderScope.containerOf(context)
                  .read(willPopProvider.notifier)
                  .canGoBack(condition: true);
            },
          ),
        ],
      );
    },
  );
}
