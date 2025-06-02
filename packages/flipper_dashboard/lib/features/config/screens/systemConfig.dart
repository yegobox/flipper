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
import 'package:flipper_dashboard/features/config/widgets/support_section.dart';
import 'package:flipper_dashboard/features/config/widgets/tax_config_form.dart';
import 'package:flipper_dashboard/features/config/widgets/switch_tile.dart';
import 'package:flipper_dashboard/features/config/widgets/currency_options.dart';

class SystemConfig extends StatefulHookConsumerWidget {
  const SystemConfig({Key? key, required this.showheader}) : super(key: key);
  final bool showheader;

  @override
  _SystemConfigState createState() => _SystemConfigState();
}

class _SystemConfigState extends ConsumerState<SystemConfig> {
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
                  customLeadingWidget: back.CustomBackButton(),
                )
              : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Configuration',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'System Currency',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButton<String>(
                              value: model.systemCurrency,
                              underline: const SizedBox(),
                              items: CurrencyOptions.getCurrencyOptions(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    model.systemCurrency = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const TaxConfigForm(),
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
