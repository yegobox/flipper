library flipper_dashboard;

import 'package:flipper_dashboard/widgets/startup_progress_screen.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
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
    debugPrint('🎬 [StartUpView] Building widget tree...');
    return ViewModelBuilder<StartupViewModel>.reactive(
      viewModelBuilder: () => StartupViewModel(),
      onViewModelReady: (viewModel) {
        debugPrint('🎬 [StartUpView] onViewModelReady called');
        // Use a delayed call to ensure the widget is fully built
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          debugPrint(
            '🎬 [StartUpView] postFrameCallback - starting runStartupLogic',
          );
          await viewModel.runStartupLogic();
          debugPrint(
            '🎬 [StartUpView] postFrameCallback - runStartupLogic completed',
          );
        });
      },
      builder: (context, model, child) {
        debugPrint('🎬 [StartUpView] builder started');
        // The view model publishes progress in 20% steps; the screen smooths
        // them into a counter that ticks one percent at a time.
        return StartupProgressScreen(progress: model.progress);
      },
    );
  }
}
