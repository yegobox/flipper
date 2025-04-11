import 'package:flutter/material.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flipper_ui/style_widget/text.dart';
import 'package:stacked/stacked.dart';

class InternetConnectionRequiredViewModel extends BaseViewModel {
  final _internetConnectionService = InternetConnectionService();

  Future<void> checkConnection() async {
    setBusy(true);
    await _internetConnectionService.forceInternetConnectionCheck();
    setBusy(false);
  }
}

class InternetConnectionRequired extends StatelessWidget {
  const InternetConnectionRequired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InternetConnectionRequiredViewModel>.reactive(
      viewModelBuilder: () => InternetConnectionRequiredViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Flippertext.semibold(
                  'Internet Connection Required',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Flippertext.regular(
                  'You need to connect to the internet to continue using Flipper. '
                  'Our system requires an internet connection every 5 days to verify your account.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FlipperButton(
                  text: 'Check Connection',
                  onPressed: model.checkConnection,
                  isLoading: model.isBusy,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                Flippertext.small(
                  'If you continue to see this screen, please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
