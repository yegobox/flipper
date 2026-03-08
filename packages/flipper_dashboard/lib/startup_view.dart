library flipper_dashboard;

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
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Flipper',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('A revolutionary business software...'),
                const SizedBox(height: 20),
                CircularProgressIndicator(value: model.progress),
                const SizedBox(height: 10),
                Text(
                  '${(model.progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
