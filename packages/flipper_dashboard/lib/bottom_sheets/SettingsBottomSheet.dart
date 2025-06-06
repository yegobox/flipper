import 'package:flipper_dashboard/widgets/SettingLayout.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SetingsBottomSheet extends StatefulHookConsumerWidget {
  const SetingsBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  SetingsBottomSheetState createState() => SetingsBottomSheetState();
}

class SetingsBottomSheetState extends ConsumerState<SetingsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.nonReactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return SettingLayout(model: model, context: context);
      },
    );
  }
}
