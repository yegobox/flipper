library flipper_routing;

import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// leave stacked for logging purposes
// only stacked is used for their model and service but not for routing as we use go-router
@StackedApp(
  routes: [],
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}

// TODO: before adding a package see from the bellow list if we don't
// modal_bottom_sheet: ^3.0.0-pre
//  flutter packages pub run build_runner build --delete-conflicting-outputs
// While debugging if you lost communication, then you can not use the Hot-Reload or Hot-Restart feature. So, instead of re-building or installing new applications, you can attach existing installed applications.
//NOTE: we have custom toast service you can call it like this  showToast(
                                // context, 'Binded to ${tenants[index].name}');
// flutter attach -d <DEVICE_ID>