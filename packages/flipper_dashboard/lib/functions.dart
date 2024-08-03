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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Confirm',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'No',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ProviderScope.containerOf(context)
                        .read(willPopProvider.notifier)
                        .canGoBack(condition: false);
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Yes',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    if (navigationPurpose == NavigationPurpose.home) {
                      locator<RouterService>().replaceWithFlipperApp();
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ProviderScope.containerOf(context)
                        .read(willPopProvider.notifier)
                        .canGoBack(condition: true);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
