
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/widgets/mini_app_icon.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxConfiguration extends StatefulWidget {
  const TaxConfiguration({
    Key? key,
  }) : super(key: key);

  @override
  State<TaxConfiguration> createState() => _TaxConfigurationState();
}

class _TaxConfigurationState extends State<TaxConfiguration> {
  String _supportLine = "";
  bool isTaxEnabled = false;
  final _routerService = locator<RouterService>();
  @override
  void initState() {
    setState(() {
      _supportLine = ProxyService.remoteConfig.supportLine();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async {
        if (await ProxyService.isar.isTaxEnabled()) {
          setState(() {
            isTaxEnabled = true;
          });
        }
        Business? business = await ProxyService.isar.getBusiness();
        model.isEbmActive = business?.tinNumber != null &&
            business?.bhfId != null &&
            business?.dvcSrlNo != null &&
            business?.taxEnabled == true;
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () async {
              _routerService.pop();
            },
            title: 'Tax Configuration',
            disableButton: false,
            showActionButton: false,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Visibility(
                    visible: !isTaxEnabled,
                    child: InkWell(
                      onTap: () async {
                        int businessId = ProxyService.box.getBusinessId()!;
                        final initialMessage =
                            "I am writing to request support to add EBM to flipper, my businessID is: ${businessId}";
                        final Uri whatsappUri = Uri.parse(
                            'https://wa.me/250788360058?text=${Uri.encodeComponent(initialMessage)}');
                        if (await canLaunchUrl(whatsappUri)) {
                          await launchUrl(whatsappUri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch $whatsappUri';
                        }
                      },
                      child: MiniAppIcon(
                        icon: Icons.call,
                        color: Colors.lightBlue,
                        page: "Support",
                        showPageName: true,
                      ),
                    )),
              ),
              Visibility(
                visible: isTaxEnabled,
                child: SwitchListTile.adaptive(
                    title: const Text('Training mode'),
                    value: model.isTrainingModeEnabled,
                    onChanged: (value) {
                      model.isTrainingModeEnabled =
                          !model.isTrainingModeEnabled;
                    }),
              ),
              Visibility(
                visible: isTaxEnabled,
                child: SwitchListTile.adaptive(
                    title: const Text('Proforma mode'),
                    value: model.isProformaModeEnabled,
                    onChanged: (value) {
                      model.isProformaModeEnabled =
                          !model.isProformaModeEnabled;
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
