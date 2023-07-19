// import 'package:flipper_routing/ui/common/app_strings.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.dialogs.dart';
// import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  
  // final _bottomSheetService = locator<BottomSheetService>();

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked  stars on Github',
    );
  }

  Future<void> sendUsIntrestRequest() async {
    final String initialMessage =
        'Hello! Would like to add flipper connecta, this is my phone number I use on flipper${ProxyService.box.getUserPhone()!}';
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/250788360058?text=${Uri.encodeComponent(initialMessage)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }

  void returnToApps() {
    final _routerService = locator<RouterService>();
    _routerService.navigateTo(const FlipperAppRoute());
  }
}
