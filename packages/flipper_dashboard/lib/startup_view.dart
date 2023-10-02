library flipper_dashboard;

import 'package:flipper_dashboard/init_app.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';

class StartUpView extends StatefulWidget {
  const StartUpView({Key? key, this.invokeLogin}) : super(key: key);
  final bool? invokeLogin;

  @override
  State<StartUpView> createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  List<LogicalKeyboardKey> keys = [];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      viewModelBuilder: () => StartupViewModel(),
      onViewModelReady: (viewModel) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
          await viewModel.runStartupLogic(
              refreshCredentials: widget.invokeLogin ?? false);
          if (ProxyService.box.getBranchId() != null &&
              ProxyService.box.getBusinessId() != null &&
              ProxyService.box.getUserId() != null) {
            InitApp.init();

            try {
              ProxyService.remote.listenToChanges();
            } catch (e) {}
          }
        });
      },
      builder: (context, view, child) {
        return RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event) {
            final key = event.logicalKey;

            if (event is RawKeyDownEvent) {
              if (keys.contains(key)) return;
              if (event.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
                print("control is pressed");
              }
              if (event.isKeyPressed(LogicalKeyboardKey.f19)) {
                print("F9 is pressed");
              }
              if (event.isKeyPressed(LogicalKeyboardKey.f10)) {
                print("F9 is pressed");
              }
              if (event.isKeyPressed(LogicalKeyboardKey.f12)) {
                print("F12 is pressed");
              }
              setState(() {
                keys.add(key);
              });
            } else {
              setState(() {
                keys.remove(key);
              });
            }
          },
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Text(
                      'Flipper',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
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
          ),
        );
      },
    );
  }
}
