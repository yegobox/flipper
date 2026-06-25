import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/config/system_config_tokens.dart';
import 'package:flipper_dashboard/features/config/widgets/system_config_modal.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

class SystemConfig extends StatefulHookConsumerWidget {
  const SystemConfig({Key? key, required this.showheader}) : super(key: key);
  final bool showheader;

  @override
  ConsumerState<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends ConsumerState<SystemConfig> {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.showheader
          ? SystemConfigTokens.inputFill
          : Colors.transparent,
      appBar: widget.showheader
          ? CustomAppBar(
              onPop: () async {
                // ignore: unused_result
                ref.refresh(transactionItemListProvider);
                _routerService.pop();
              },
              closeButton: CLOSEBUTTON.WIDGET,
              isDividerVisible: false,
              customLeadingWidget: back.CustomBackButton(),
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SystemConfigModalCard(
            onClose: widget.showheader
                ? () {
                    // ignore: unused_result
                    ref.refresh(transactionItemListProvider);
                    _routerService.pop();
                  }
                : () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}
