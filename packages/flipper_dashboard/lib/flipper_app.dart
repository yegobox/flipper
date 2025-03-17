import 'dart:async';
import 'dart:io';

import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/NotificationStream.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:nfc_manager/nfc_manager.dart';
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
    WidgetsBinding.instance.addObserver(this);
    _initLogic();
    // Initialize status monitoring
    ProxyService.status.updateStatusColor();
  }

  void _initLogic() {
    _disableScreenshots();
    _startNFC();
    _requestPermissions();
  }

  bool isMobile = Platform.isIOS || Platform.isAndroid;

  Future<void> _startNFC() async {
    // if (isMobile && await NfcManager.instance.isAvailable()) {
    //   try {
    //     AppService().nfc.stopNfc();
    //     AppService().nfc.startNFC(
    //           callback: (nfcData) => AppService.cleanedDataController.add(
    //             nfcData.split(RegExp(r"NFC_DATA:|en|\\x02")).last,
    //           ),
    //           textData: "",
    //           write: false,
    //         );
    //   } catch (e) {
    //     print("Error starting NFC: $e");
    //   }
    // }
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
    WidgetsBinding.instance.removeObserver(this);
    AppService.cleanedDataController.close();
    notificationStream.dispose();
    super.dispose();
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

  void _handleResumedState() {
    // Refresh status when app resumes
    ProxyService.status.updateStatusColor();
  }

  void _handlePausedState() {}

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.nonReactive(
      key: Key('mainApp'),
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
   // ProxyService.dynamicLink.handleDynamicLink(context);

    if ((isAndroid || isIos)) {
      _startNFCForModel(model);
    }
  }

  Future<void> _startNFCForModel(CoreViewModel model) async {
    // TODO: nfc_manager was causing iPhone to freeze so disable it now.
    // if (await NfcManager.instance.isAvailable()) {
    //   AppService().nfc.startNFC(
    //         callback: (nfcData) {
    //           AppService.cleanedDataController
    //               .add(nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last);
    //         },
    //         textData: "",
    //         write: false,
    //       );

    //   AppService.cleanedData.listen((data) async {
    //     final branchId = ProxyService.box.getBranchId()!;
    //     log("listened to data");
    //     final pendingTransaction = ref.watch(pendingTransactionStreamProvider((
    //       mode: TransactionType.sale,
    //       isExpense: false,
    //       branchId: branchId
    //     )));
    //     log(data);
    //     List<String> parts = data.split(':');
    //     String firstPart = parts[0];

    //     await model.sellWithCard(
    //       tenantId: firstPart,
    //       pendingTransaction: pendingTransaction.value!,
    //     );

    //     showToast(context, 'Sale recorded successfully.');
    //   });
    // }
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
        appBar: _buildAppBar(context, ref),
        body: Consumer(
          builder: (context, ref, child) {
            return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: _buildAppLayoutDrawer(context, model, ref));
          },
        ),
      ),
    );
  }

  double preferredHeight = 0;
  PreferredSizeWidget _buildAppBar(BuildContext context, ref) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
          ref.watch(statusTextProvider).value?.isEmpty ?? true ? 0 : 25),
      child: Consumer(
        builder: (context, ref, child) {
          final statusTextValue = ref.watch(statusTextProvider);
          final statusColorValue = ref.watch(statusColorProvider);
          preferredHeight = statusTextValue.value?.isNotEmpty == true ? 25 : 0;

          return AppBar(
            title: Center(
              child: Text(
                statusTextValue.value ??
                    "", // Add .value since it's an AsyncValue
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: statusColorValue.value ??
                Colors.black, // Add .value since it's an AsyncValue
            automaticallyImplyLeading: false,
          );
        },
      ),
    );
  }

  Widget _buildAppLayoutDrawer(
      BuildContext context, CoreViewModel model, WidgetRef ref) {
    return StreamBuilder<Tenant?>(
      stream: ProxyService.strategy
          .authState(branchId: ProxyService.box.getBranchId() ?? 0),
      builder: (context, snapshot) {
        return _buildAppLayoutDrawerInner(context, model, snapshot, ref);
      },
    );
  }

  Widget _buildAppLayoutDrawerInner(BuildContext context, CoreViewModel model,
      AsyncSnapshot<Tenant?> snapshot, WidgetRef ref) {
    return AppLayoutDrawer(
      controller: controller,
      tabSelected: tabSelected,
      focusNode: focusNode,
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
