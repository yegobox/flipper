import 'package:flutter/material.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gerror_message.dart';

class NoNetViewModel extends BaseViewModel {
  final _internetConnectionService = InternetConnectionService();
  final _routerService = locator<RouterService>();

  Future<void> checkInternetConnection() async {
    setBusy(true);
    final isConnected =
        await _internetConnectionService.checkInternetConnectionRequirement();
    setBusy(false);

    // If connection is successful, the service will automatically navigate back to the app
    // If not, we stay on this screen
    if (!isConnected) {
      // Optional: Show a snackbar or message that connection is still unavailable
    }
  }

  void goToLogin() {
    _routerService.clearStackAndShow(LoginRoute());
  }
}

class NoNet extends StatelessWidget {
  NoNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NoNetViewModel>.reactive(
      viewModelBuilder: () => NoNetViewModel(),
      builder: (context, model, child) => Scaffold(
        body: GErrorMessage(
          icon: const Icon(Icons.wifi_off_outlined),
          title: "No internet",
          subtitle:
              "Can't connect to the internet.\nPlease check your internet connection",
          buttonText: "Check Connection",
          isLoading: model.isBusy,
          onPressed: () => model.checkInternetConnection(),
          secondaryButtonText: "Go to Login",
          onSecondaryPressed: () => model.goToLogin(),
        ),
      ),
    );
  }
}
