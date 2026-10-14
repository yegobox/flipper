import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/admin/mobile/mobile_settings_hub.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/widgets/SettingLayout.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async => await model.createPin(),
      builder: (context, model, child) {
        // Phones get the grouped settings hub (full Admin Control for
        // admins); wider screens keep the existing layout.
        final phone =
            MediaQuery.sizeOf(context).width <
            PosLayoutBreakpoints.mobileLayoutMaxWidth;
        // CustomAppBar pads for the status bar itself; an outer SafeArea
        // left that strip unpainted.
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () async {
              _routerService.pop();
            },
            title: context.flipperL10n.settings,
            disableButton: false,
            showActionButton: false,
          ),
          backgroundColor: phone
              ? MposTokens.bg
              : Theme.of(context).canvasColor,
          body: SafeArea(
            top: false,
            child: phone
                ? MobileSettingsHub(
                    branchName: model.branch?.name,
                    branchId: model.branch?.id,
                  )
                : SettingLayout(model: model, context: context),
          ),
        );
      },
    );
  }
}
