import 'package:flipper_dashboard/bottom_sheet.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_ui/bottom_sheets/tax_configuration.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

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
        if (!model.isEbmActive) {
          taxConfiguration(
            context: context,
            body: <Widget>[
              Center(child: Text("Call $_supportLine for EBM configuration"))
            ],
            header: header(title: 'Activate EBM', context: context),
          );
        }
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
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.calculate,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                  title: const Text('Enable EBM'),
                  value: model.isEbmActive,
                  onChanged: (value) {
                    // model.isEbmActive = true;
                    if (!model.isEbmActive) {
                      taxConfiguration(
                        context: context,
                        body: <Widget>[
                          Center(
                              child: Text(
                                  "Call $_supportLine for EBM configuration"))
                        ],
                        header: header(title: 'Activate EBM', context: context),
                      );
                    }
                  }),
              if (isTaxEnabled)
                SwitchListTile.adaptive(
                    title: const Text('Training mode'),
                    value: model.isTrainingModeEnabled,
                    onChanged: (value) {
                      model.isTrainingModeEnabled =
                          !model.isTrainingModeEnabled;
                    }),
              if (isTaxEnabled)
                SwitchListTile.adaptive(
                    title: const Text('Proforma mode'),
                    value: model.isProformaModeEnabled,
                    onChanged: (value) {
                      model.isProformaModeEnabled =
                          !model.isProformaModeEnabled;
                    })
            ],
          ),
        );
      },
    );
  }
}
