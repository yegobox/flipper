import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/NotificationStream.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:stacked/stacked.dart';

class FlipperApp extends StatefulHookConsumerWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  FlipperAppState createState() => FlipperAppState();
}

class FlipperAppState extends ConsumerState<FlipperApp>
    with WidgetsBindingObserver, Refresh {
  PageController page = PageController();
  final TextEditingController controller = TextEditingController();
  int tabSelected = 0;
  final formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  List<LogicalKeyboardKey> keys = [];

  final notificationStream = NotificationStream();

  @override
  void initState() {
    super.initState();
    _initLogic();
  }

  void _initLogic() {
    _disableScreenshots();
    _startNFC();
    _requestPermissions();
  }

  bool isMobile = Platform.isIOS || Platform.isAndroid;

  Future<void> _startNFC() async {
    if (isMobile && await NfcManager.instance.isAvailable()) {
      try {
        AppService().nfc.stopNfc();
        AppService().nfc.startNFC(
              callback: (nfcData) => AppService.cleanedDataController.add(
                nfcData.split(RegExp(r"NFC_DATA:|en|\\x02")).last,
              ),
              textData: "",
              write: false,
            );
      } catch (e) {
        // Handle NFC related exceptions here (optional)
        print("Error starting NFC: $e");
      }
    }
  }

  void _disableScreenshots() async {
    if (!kDebugMode &&
        !isDesktopOrWeb &&
        ProxyService.remoteConfig.enableTakingScreenShoot()) {
      // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  void _requestPermissions() async {
    if (!isWindows && !isMacOs && !isIos) {
      await [
        permission.Permission.storage,
        permission.Permission.manageExternalStorage,
        permission.Permission.notification,
      ].request();
    }
  }

  @override
  void dispose() {
    super.dispose();
    AppService.cleanedDataController.close();
    notificationStream.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _handleResumedState();
        break;
      case AppLifecycleState.paused:
        _handlePausedState();
        break;
      default:
        break;
    }
  }

  void _handleResumedState() {}

  void _handlePausedState() {}

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) {
        _viewModelReadyLogic(model);
      },
      builder: (context, model, child) {
        return _buildScaffold(context, model);
      },
    );
  }

  void _viewModelReadyLogic(CoreViewModel model) {
    ProxyService.dynamicLink.handleDynamicLink(context);

    if ((isAndroid || isIos)) {
      _startNFCForModel(model);
    }
  }

  Future<void> _startNFCForModel(CoreViewModel model) async {
    if (await NfcManager.instance.isAvailable()) {
      AppService().nfc.startNFC(
            callback: (nfcData) {
              AppService.cleanedDataController
                  .add(nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last);
            },
            textData: "",
            write: false,
          );

      AppService.cleanedData.listen((data) async {
        log("listened to data");
        final pendingTransaction = ref.watch(pendingTransactionProvider(
            (mode: TransactionType.sale, isExpense: false)));
        log(data);
        List<String> parts = data.split(':');
        String firstPart = parts[0];

        await model.sellWithCard(
          tenantId: int.parse(firstPart),
          pendingTransaction: pendingTransaction.value!,
        );

        showToast(context, 'Sale recorded successfully.');
      });
    }
  }

  Widget _buildScaffold(BuildContext context, CoreViewModel model) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        _handleKeyEvent(model, event);
      },
      child: Scaffold(
        extendBody: true,
        appBar: _buildAppBar(),
        body: Consumer(
          builder: (context, ref, child) {
            return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // TODO: enable this once enabled generally on atlas side
                  // ProxyService.local.recordUserActivity(
                  //     userId: ProxyService.box.getUserId()!,
                  //     activity: 'TapOnSreen');
                },
                child: _buildAppLayoutDrawer(context, model, ref));
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Center(
        child: Text(
          ProxyService.status.statusText.value ?? "",
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: ProxyService.status.statusColor.value,
      automaticallyImplyLeading: false,
      toolbarHeight:
          ProxyService.status.statusText.value?.isNotEmpty == true ? 25 : 0,
    );
  }

  Widget _buildAppLayoutDrawer(
      BuildContext context, CoreViewModel model, WidgetRef ref) {
    return StreamBuilder<Tenant?>(
      stream: ProxyService.local
          .authState(branchId: ProxyService.box.getBranchId() ?? 0),
      builder: (context, snapshot) {
        return _buildAppLayoutDrawerInner(context, model, snapshot, ref);
      },
    );
  }

  Widget _buildAppLayoutDrawerInner(BuildContext context, CoreViewModel model,
      AsyncSnapshot<Tenant?> snapshot, WidgetRef ref) {
    /// TODO: re-work on this.
    // if (snapshot.hasData &&
    //     !(snapshot.data!.sessionActive == null
    //         ? false
    //         : snapshot.data!.sessionActive!)) {
    //   _handleSessionInactive(context, model, snapshot.data!);
    // } else if (snapshot.hasData && snapshot.data!.sessionActive!) {
    //   model.passCode = snapshot.data!.pin.toString();
    // }

    return AppLayoutDrawer(
      controller: controller,
      tabSelected: tabSelected,
      focusNode: focusNode,
    );
  }

  void _handleSessionInactive(
      BuildContext context, CoreViewModel model, Tenant tenant) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (ProxyService.remoteConfig.isLocalAuthAvailable() &&
          (tenant.pin != null && tenant.pin != 0)) {
        _showLocalAuthOverlay(context, model);
      }
    });
  }

  Future<void> _showLocalAuthOverlay(
      BuildContext context, CoreViewModel model) async {
    List<Tenant> tenants = await ProxyService.local
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    screenLock(
      context: context,
      correctString: model.passCode,
      canCancel: false,
      onUnlocked: () async {
        Tenant? tenant = await ProxyService.local
            .getTenantBYPin(pin: int.tryParse(model.passCode) ?? 0);
        model.weakUp(userId: tenant!.userId!, pin: model.passCode);
        Navigator.of(context).maybePop();
      },
      onValidate: (input) async {
        for (Tenant tenant in tenants) {
          log(tenant.pin.toString(), name: 'given pins');
          if (input.allMatches(tenant.pin.toString()).isNotEmpty) {
            model.passCode = input;
            return true;
          }
          return false;
        }
        return true;
      },
    );
  }

  void _handleKeyEvent(CoreViewModel model, KeyEvent event) {
    final key = event.logicalKey;
    if (event is KeyDownEvent) {
      if (keys.contains(key)) return;
      setState(() {
        keys.add(key);
      });
      model.handleKeyBoardEvents(event: event);
    } else {
      setState(() {
        keys.remove(key);
      });
    }
  }
}
