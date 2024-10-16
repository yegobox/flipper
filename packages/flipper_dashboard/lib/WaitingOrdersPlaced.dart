import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/foundation.dart' as foundation;

class WaitingOrdersPlaced extends HookConsumerWidget {
  const WaitingOrdersPlaced(this.orderId, {super.key});
  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: TimeSegmentUI(
          targetDateTime: DateTime.now()
              .add(Duration(minutes: foundation.kDebugMode ? 2 : 10)),
          onCycleComplete: () {
            talker.warning("We have completed the order");

            /// pop to navigate back
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
