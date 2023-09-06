import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_socials/ui/common/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'app_center_model.dart';

const double _graphicSize = 60;

class AppCenter extends StackedView<AppCenterModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final String logoAsset = 'assets/logo.png';
  final _routerService = locator<RouterService>();
  AppCenter({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AppCenterModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  verticalSpaceTiny,
                  SizedBox(
                    width: _graphicSize,
                    height: _graphicSize,
                    child: Stack(
                      children: [
                        InkWell(
                          child: Image.asset(logoAsset,
                              package: "flipper_socials"),
                          onTap: () {
                            ProxyService.box
                                .writeString(key: 'defaultApp', value: "1");
                            // navigate
                            _routerService.navigateTo(const FlipperAppRoute());
                          },
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Inventory",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AppCenterModel viewModelBuilder(BuildContext context) => AppCenterModel();
}
