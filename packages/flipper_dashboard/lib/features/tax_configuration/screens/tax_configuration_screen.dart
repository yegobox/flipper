import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:flipper_dashboard/features/tax_configuration/widgets/support_section.dart';
import 'package:flipper_dashboard/features/tax_configuration/widgets/proforma_url_form.dart';
import 'package:flipper_dashboard/features/tax_configuration/widgets/switch_tile.dart';

class TaxConfiguration extends StatefulHookConsumerWidget {
  const TaxConfiguration({Key? key, required this.showheader})
      : super(key: key);
  final bool showheader;

  @override
  _TaxConfigurationState createState() => _TaxConfigurationState();
}

class _TaxConfigurationState extends ConsumerState<TaxConfiguration> {
  bool isTaxEnabled = false;
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async {
        try {
          final isTaxEnabledForBusiness = await ProxyService.strategy
              .isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
          if (isTaxEnabledForBusiness) {
            setState(() {
              isTaxEnabled = true;
            });
          }
          Business? business = await ProxyService.strategy
              .getBusiness(businessId: ProxyService.box.getBusinessId()!);
          model.isEbmActive = business!.tinNumber != null &&
              (await ProxyService.box.bhfId()) != null &&
              business.dvcSrlNo != null &&
              business.taxEnabled == true;
        } catch (e, s) {
          talker.warning(s);
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: widget.showheader
              ? CustomAppBar(
                  onPop: () async {
                    // ignore: unused_result
                    ref.refresh(transactionItemListProvider);
                    _routerService.pop();
                  },
                  closeButton: CLOSEBUTTON.WIDGET,
                  isDividerVisible: false,
                  customLeadingWidget: back.BackButton(),
                )
              : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tax Configuration',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (!isTaxEnabled) const SupportSection(),
                  if (isTaxEnabled) ...[
                    TaxConfigSwitchTile(
                      title: 'Training Mode',
                      value: model.isTrainingModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          model.isTrainingModeEnabled = value;
                        });
                      },
                    ),
                    TaxConfigSwitchTile(
                      title: 'Proforma Mode',
                      value: model.isProformaModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          model.isProformaModeEnabled = value;
                        });
                      },
                    ),
                    TaxConfigSwitchTile(
                      title: 'Print A4',
                      value: model.printA4,
                      onChanged: (value) {
                        setState(() {
                          model.printA4 = value;
                        });
                      },
                    ),
                    TaxConfigSwitchTile(
                      title: 'Export as PDF',
                      value: model.exportAsPdf,
                      onChanged: (value) {
                        setState(() {
                          model.exportAsPdf = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    const ProformaUrlForm(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
