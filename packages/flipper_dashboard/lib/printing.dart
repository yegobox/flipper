import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class Printing extends StatefulWidget {
  const Printing({Key? key}) : super(key: key);

  @override
  State<Printing> createState() => _PrintingState();
}

class _PrintingState extends State<Printing> {
  bool isAutoPrint = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async {
        if (SchedulerBinding.instance.schedulerPhase ==
            SchedulerPhase.persistentCallbacks) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            if (model.isAutoPrintEnabled) {
              setState(() {
                isAutoPrint = true;
              });
            }
          });
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () async {
              GoRouter.of(context).pop();
            },
            title: 'Printing Configuration',
            disableButton: false,
            showActionButton: false,
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.print,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                  title: const Text('Enable Auto Print'),
                  value: model.isAutoPrintEnabled,
                  onChanged: (value) {
                    model.isAutoPrintEnabled = !model.isAutoPrintEnabled;
                  }),
            ],
          ),
        );
      },
    );
  }
}
