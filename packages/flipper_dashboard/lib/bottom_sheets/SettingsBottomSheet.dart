import 'package:flipper_dashboard/widgets/SettingLayout.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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
    final transactionItemsNotifier =
        ref.watch(transactionItemsProvider((isExpense: false)).notifier);

    transactionItemsNotifier.updatePendingTransaction();

    return ViewModelBuilder<SettingViewModel>.nonReactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return SettingLayout(model: model, context: context);
      },
    );
  }
}
