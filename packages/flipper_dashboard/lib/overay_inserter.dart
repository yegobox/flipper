import 'package:flipper_dashboard/pininput.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

void removeOverlay(OverlayEntry overlayEntry) {
  overlayEntry.remove();
}

OverlayEntry insertOverlay(
    {required BuildContext context, required CoreViewModel model}) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(builder: (context) {
    final size = MediaQuery.of(context).size;
    print(size.width);
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Color(0xFF6F2F9).withOpacity(0.6),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            // Handle tap on the overlay
            print('ON TAP OVERLAY!');
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<Branch?>(
                        future: ProxyService.realm.activeBranch(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return SizedBox.shrink();
                          }
                          Branch branch = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12.0), // Adjust spacing
                            child: ProfileWidget(
                              branch: branch,
                              size: 25,
                              sessionActive: branch.isDefault!,
                              showIcon: false,
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.circular(10)),
                        width: 320,
                        height: 140,
                        child: OnlyBottomCursor(model: model),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });

  Overlay.of(context).insert(overlayEntry);
  return overlayEntry;
}
