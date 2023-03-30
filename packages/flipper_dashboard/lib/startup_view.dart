library flipper_dashboard;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_socials/ui/common/ui_helpers.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key, this.invokeLogin}) : super(key: key);
  final bool? invokeLogin;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      onViewModelReady: (model) =>
          SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          model.runStartupLogic(
            invokeLogin: invokeLogin ?? false,
            loginInfo: loginInfo,
            navigationCallback: (nav) async {
              if (nav == "login") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("A Fresh login is required!"),
                  ),
                );
                GoRouter.of(context).push("/login");
              } else if (nav == "signup") {
                String? countryName =
                    await ProxyService.country.getCountryName();
                loginInfo.country = countryName!;
                loginInfo.needSignUp = true;
                loginInfo.isLoggedIn = false;
                loginInfo.redirecting = false;
                GoRouter.of(context).push("/signup/$countryName");
              } else {
                GoRouter.of(context).push('/${nav}');
              }
            },
          );
        },
      ),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Flipper',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.w900),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'A revolutionary business software ...',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    horizontalSpaceSmall,
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 6,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
