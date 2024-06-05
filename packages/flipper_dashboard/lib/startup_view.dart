library flipper_dashboard;

import 'package:flipper_dashboard/CustomProviderContainer.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatefulWidget {
  const StartUpView({Key? key, this.invokeLogin}) : super(key: key);
  final bool? invokeLogin;

  @override
  State<StartUpView> createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      viewModelBuilder: () => StartupViewModel(),
      onViewModelReady: (viewModel) {
        final container = ProviderContainer();

        // Invalidate all providers before starting the app
        invalidateAllProviders(container, allProviders);
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
          await viewModel.runStartupLogic(
              refreshCredentials: widget.invokeLogin ?? false);
        });
      },
      builder: (context, model, child) {
        return Scaffold(
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
        );
      },
    );
  }
}
