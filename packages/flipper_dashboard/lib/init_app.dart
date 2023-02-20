import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class InitApp {
  static void init() {
    ProxyService.event.connect();

    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
    //connect to anyy available printer
    // ProxyService.printer.blueTooths();
    ProxyService.forceDateEntry.caller();
    // init the crashlytics
    // ProxyService.crash.initializeFlutterFire();
    // implement review system.
    ProxyService.review.review();
    // schedule the report
    ProxyService.cron.connectBlueToothPrinter();
    ProxyService.cron.deleteReceivedMessageFromServer();

    /// This is one solution to have data synced across devices. and connected clients
    /// once the objectbox sync is available the option will be evaluated and added. to package and maybe also
    /// the two solution will be sold differently with different price.
    if (ProxyService.remoteConfig.isSyncAvailable()) {
      // ProxyService.syncApi.pull();
      // ProxyService.syncApi.push();
    }

    // scrollController =
    // ScrollController(keepScrollOffset: true, initialScrollOffset: 0);
    ProxyService.cron.schedule();

    ProxyService.appService.updateStatusColor();

    ProxyService.appService.appBarColor(Colors.black);

    /// to avoid receiving the message of the contact you don't have in your book
    /// we need to load contacts when the app starts.
    // ProxyService.isarApi.contacts().asBroadcastStream();
    // ProxyService.isarApi.createPin();

    // if (!kDebugMode) {
    //   if (SchedulerBinding.instance.schedulerPhase ==
    //       SchedulerPhase.persistentCallbacks) {
    //     SchedulerBinding.instance.addPostFrameCallback((_) async {
    //       int today = DateTime.now().day;
    //       // if today is tuesday for example and other even days
    //       // if to day is monday or wednesday and other odd days
    //       if (today % 2 == 1 &&
    //           !await ProxyService.billing.activeSubscription() &&
    //           !isWindows) {
    //         showMaterialModalBottomSheet(
    //           expand: false,
    //           context: context,
    //           backgroundColor: Colors.white,
    //           builder: (context) => LayoutBuilder(
    //             builder: (context, constraints) => SizedBox(
    //               height: constraints.maxHeight * 0.2,
    //               child: SubscriptionWidget(),
    //             ),
    //           ),
    //         );
    //       }
    //     });
    //   }
    // }
  }
}
