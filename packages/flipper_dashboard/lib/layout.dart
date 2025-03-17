import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/EnhancedSideMenu.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/TransactionWidget.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/bottom_sheets/preview_sale_bottom_sheet.dart';
import 'package:flipper_dashboard/mobile_view.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/navigation_providers.dart';

class AppLayoutDrawer extends StatefulHookConsumerWidget {
  const AppLayoutDrawer({
    Key? key,
    required this.controller,
    required this.tabSelected,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final int tabSelected;
  final FocusNode focusNode;

  @override
  AppLayoutDrawerState createState() => AppLayoutDrawerState();
}

class AppLayoutDrawerState extends ConsumerState<AppLayoutDrawer> {
  final TextEditingController searchController = TextEditingController();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultApp();
  }

  Future<void> _loadDefaultApp() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultApp = prefs.getString('defaultApp');
    if (defaultApp != null && !ref.read(isDefaultAppLoadedProvider)) {
      ref.read(defaultAppProvider.notifier).state = defaultApp;
      _navigateToDefaultApp(defaultApp);
      ref.read(isDefaultAppLoadedProvider.notifier).state = true;
    }
  }

  void _navigateToDefaultApp(String appId) {
    switch (appId) {
      case 'inventory':
        // Navigate to inventory app
        ref.read(selectedMenuItemProvider.notifier).state = 0; // Overview section
        break;
      case 'chat':
        // Navigate to Chat AI app
        // TODO: Implement chat navigation
        break;
      case 'marketplace':
        // Navigate to Marketplace app
        // TODO: Implement marketplace navigation
        break;
      case 'settings':
        // Navigate to Settings app
        // TODO: Implement settings navigation
        break;
    }
  }

  Future<void> setDefaultApp(String appId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultApp', appId);
    ref.read(defaultAppProvider.notifier).state = appId;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Default app set successfully')),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isScanningMode = ref.watch(scanningModeProvider);

    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) {
        ref.read(previewingCart.notifier).state = false;
      },
      builder: (context, model, child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              return buildMobileLayout(model);
            } else {
              return buildDesktopLayout(isScanningMode);
            }
          },
        );
      },
    );
  }

  Widget buildMobileLayout(CoreViewModel model) {
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);
    
    if (selectedMenuItem == -1) {
      return MobileView(
        isBigScreen: false,
        controller: widget.controller,
        model: model,
        onAppLongPress: setDefaultApp,
      );
    }

    return buildMainContent(false);
  }

  Widget buildDesktopLayout(bool isScanningMode) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSideMenu(),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: MobileView(
                            isBigScreen: true,
                            controller: widget.controller,
                            model: CoreViewModel(),
                            onAppLongPress: setDefaultApp,
                          ),
                        ),
                        if (ref.watch(selectedMenuItemProvider) != -1) ...[
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 3,
                            child: buildMainContent(isScanningMode),
                          ),
                          if (ref.read(selectedMenuItemProvider.notifier).state != 1)
                            buildProductSection(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMainContent(bool isScanningMode) {
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);

    switch (selectedMenuItem) {
      case 0: // Sales
        return isScanningMode
            ? buildReceiptUI().shouldSeeTheApp(ref, AppFeature.Sales)
            : CheckOut(isBigScreen: true)
                .shouldSeeTheApp(ref, AppFeature.Sales);
      case 1: // Inventory
        return Center(
          child: Ai(),
        );
      case 2: // Tickets
        return const TransactionWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildReceiptUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        child: PreviewSaleBottomSheet(
          reverse: false,
        ),
      ),
    );
  }

  Widget buildSideMenu() {
    if (!ProxyService.remoteConfig.isMultiUserEnabled()) {
      return const SizedBox.shrink();
    }

    return Container(
      child: EnhancedSideMenu(),
    );
  }

  Widget buildProductSection() {
    return Flexible(
      child: Column(
        children: [
          // Search field stays fixed at the top
          SearchFieldWidget(controller: searchController),
          // ProductView takes remaining space and scrolls independently
          Expanded(
            child: ProductView.normalMode(),
          ),
        ],
      ),
    ).shouldSeeTheApp(ref, AppFeature.Sales);
  }
}
