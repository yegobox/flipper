import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:go_router/go_router.dart';

final isAndroid = UniversalPlatform.isAndroid;
final isIos = UniversalPlatform.isIOS;

class AddProductButtons extends StatefulWidget {
  const AddProductButtons({Key? key}) : super(key: key);

  @override
  State<AddProductButtons> createState() => _AddProductButtonsState();
}

class _AddProductButtonsState extends State<AddProductButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 62, left: 58, right: 58),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 64,
                  child: TextButton(
                    child: Text('Add Product',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Color(0xff006AFE))),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffF2F2F2)),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.blue.withOpacity(0.04);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.blue.withOpacity(0.12);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).push(Routes.create + "/product");
                    },
                  ),
                ),
              ),
              if (isIos ||
                  isAndroid ||
                  kDebugMode && ProxyService.remoteConfig.isDiscountAvailable())
                Padding(
                  padding: const EdgeInsets.only(top: 31, left: 58, right: 58),
                  child: Container(
                    color: Colors.white70,
                    width: double.infinity,
                    height: 64,
                    child: TextButton(
                      child: Text('Add Discount',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: Color(0xff006AFE))),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffF2F2F2)),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blue.withOpacity(0.04);
                            }
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)) {
                              return Colors.blue.withOpacity(0.12);
                            }
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        GoRouter.of(context).push(Routes.discount);
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 31, left: 58, right: 58, bottom: 20),
                child: Container(
                  width: double.infinity,
                  height: 64,
                  child: TextButton(
                    child: Text('Dismiss',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Color(0xff006AFE))),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
