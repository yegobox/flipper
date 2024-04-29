import 'package:flipper_dashboard/widgets/SettingLayout.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
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
    final transaction =
        ref.watch(pendingTransactionProvider(TransactionType.custom));
    final transactionItemsNotifier = ref
        .watch(transactionItemsProvider(transaction.value?.value?.id).notifier);

    transactionItemsNotifier.updatePendingTransaction();

    return ViewModelBuilder<SettingViewModel>.nonReactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return SettingLayout(model: model, context: context);
      },
    );
  }
}
