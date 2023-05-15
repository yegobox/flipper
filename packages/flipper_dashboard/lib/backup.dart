import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/view_models/setting_view_model.dart';
import 'package:flipper_ui/bottom_sheets/general_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

class BackUp extends StatefulWidget {
  const BackUp({Key? key}) : super(key: key);

  @override
  State<BackUp> createState() => _BackUpState();
}

class _BackUpState extends State<BackUp> {
  bool isAutoBackup = false;
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async {
        if (model.isAutoBackupEnabled) {
          setState(() {
            isAutoBackup = true;
          });
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () async {
              _routerService.pop();
              ;
            },
            title: 'BackUp Configuration',
            disableButton: false,
            showActionButton: false,
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.backup,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                  title: const Text('Enable Auto Backup'),
                  value: model.isAutoBackupEnabled,
                  onChanged: (value) {
                    FlipperBottomSheet.showABackUpBottomSheet(
                        model: model, context: context);
                  }),
            ],
          ),
        );
      },
    );
  }
}
