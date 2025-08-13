import 'dart:async';

import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:stacked/stacked.dart';

class FlipperApp extends HookConsumerWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coreViewModel = useMemoized(() => CoreViewModel());

    // Handles initialization and lifecycle events.
    useEffect(() {
      _initServices(context, coreViewModel);
      final observer = _AppLifecycleObserver(_handleResumedState);
      WidgetsBinding.instance.addObserver(observer);
      return () => WidgetsBinding.instance.removeObserver(observer);
    }, [coreViewModel]);

    return ViewModelBuilder<CoreViewModel>.nonReactive(
      key: const Key('mainApp'),
      viewModelBuilder: () => coreViewModel,
      builder: (context, model, child) => FlipperScaffold(model: model),
    );
  }

  void _initServices(BuildContext context, CoreViewModel model) {
    _disableScreenshots();
    _requestPermissions();
    ProxyService.status.updateStatusColor();
    // ProxyService.dynamicLink.handleDynamicLink(context);
    if (isAndroid || isIos) {
      _startNFCForModel(model);
    }
  }

  void _handleResumedState() => ProxyService.status.updateStatusColor();

  Future<void> _startNFCForModel(CoreViewModel model) async {
    // TODO: NFC logic is commented out, preserving original state.
  }

  void _disableScreenshots() {
    if (!kDebugMode &&
        !isDesktopOrWeb &&
        ProxyService.remoteConfig.enableTakingScreenShoot()) {
      // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  void _requestPermissions() {
    if (!isWindows && !isMacOs && !isIos) {
      [permission.Permission.storage, permission.Permission.notification]
          .request();
    }
  }
}

class FlipperScaffold extends HookConsumerWidget {
  const FlipperScaffold({Key? key, required this.model}) : super(key: key);
  final CoreViewModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = useState<List<LogicalKeyboardKey>>([]);
    final focusNode = useFocusNode();
    final statusText = ref.watch(statusTextProvider).value ?? "";

    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) => _handleKeyEvent(event, keys, model),
      child: Scaffold(
        extendBody: true,
        appBar: statusText.isNotEmpty ? const StatusAppBar() : null,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            try {
              final startupViewModel = getIt<StartupViewModel>();
              startupViewModel.updateUserActivity();
            } catch (e) {
              // Ignore if StartupViewModel is not available
            }
          },
          child: const FlipperAppBody(),
        ),
      ),
    );
  }

  void _handleKeyEvent(
    KeyEvent event,
    ValueNotifier<List<LogicalKeyboardKey>> keys,
    CoreViewModel model,
  ) {
    final key = event.logicalKey;
    if (event is KeyDownEvent) {
      if (keys.value.contains(key)) return;
      keys.value = [...keys.value, key];
      model.handleKeyBoardEvents(event: event);
    } else {
      keys.value = keys.value.where((k) => k != key).toList();
    }
  }
}

class StatusAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const StatusAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusText = ref.watch(statusTextProvider).value ?? "";
    final statusColor = ref.watch(statusColorProvider).value ?? Colors.black;

    return AppBar(
      title: Center(child: Text(statusText, style: _appBarTextStyle())),
      backgroundColor: statusColor,
      automaticallyImplyLeading: false,
    );
  }

  TextStyle _appBarTextStyle() => GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      );

  @override
  Size get preferredSize =>
      const Size.fromHeight(25); // Simplified height logic
}

class FlipperAppBody extends StatelessWidget {
  const FlipperAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Tenant?>(
      stream: ProxyService.strategy
          .authState(branchId: ProxyService.box.getBranchId() ?? 0),
      builder: (context, snapshot) => const DashboardLayout(),
    );
  }
}

/// A custom WidgetsBindingObserver to handle app lifecycle events functionally.
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResumed;

  _AppLifecycleObserver(this.onResumed);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    } else if (state == AppLifecycleState.detached) {
      // Clean up global event bus on app shutdown
      EventBus().dispose();
    }
  }
}
