import 'package:flipper_dashboard/features/tenant/mixins/tenant_management_mixin.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'customappbar.dart';

class TenantManagement extends StatefulHookConsumerWidget {
  const TenantManagement({Key? key}) : super(key: key);

  @override
  UserManagement createState() => UserManagement();
}

class UserManagement extends ConsumerState<TenantManagement>
    with WidgetsBindingObserver, TenantManagementMixin {
  @override
  void initState() {
    super.initState();
    for (var feature in features) {
      activeFeatures[feature] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlipperBaseModel>.reactive(
      onViewModelReady: (model) async => await model.loadTenants(),
      viewModelBuilder: () => FlipperBaseModel(),
      builder: (context, model, widget) {
        return Scaffold(
          appBar: CustomAppBar(
            bottomSpacer: 80,
            title: 'Add a user',
            multi: 3,
            onPop: () async => routerService.pop(),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  padding: const EdgeInsets.all(20.0),
                  child: constraints.maxWidth > 600
                      ? buildWideLayout(model, context)
                      : buildNarrowLayout(model, context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
