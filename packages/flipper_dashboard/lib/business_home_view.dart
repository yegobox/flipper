library flipper_dashboard;

import 'package:flutter/cupertino.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flipper/localization.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/sale_indicator.dart';
import 'package:flipper_dashboard/slide_out_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'add_product_buttons.dart';
import 'bottom_menu_bar.dart';
import 'custom_rect_tween.dart';
import 'flipper_drawer.dart';
import 'hero_dialog_route.dart';
import 'home_app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:stacked/stacked_annotations.dart';
import 'keypad_head_view.dart';
import 'keypad_view.dart';
import 'package:flipper_chat/lite/pages/lite.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

@FormView(fields: [FormTextField(name: 'note')])
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _sideOpenController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Animation<double> _fadeAnimation;
  late AnimationController _fadeController;
  TextEditingController controller = TextEditingController();
  final log = getLogger('KeyPadHead');

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _sideOpenController = ValueNotifier<bool>(false);
    ProxyService.notification.initialize();
    ProxyService.notification.listen();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.fetch();
    //connect to anyy available printer
    // ProxyService.printer.blueTooths();
    ProxyService.analytics.recordUser();
    ProxyService.forceDateEntry.caller();
    // init the crashlytics
    // ProxyService.crash.initializeFlutterFire();
    // implement review system.
    ProxyService.review.review();
    // schedule the report
    ProxyService.cron.schedule();
    ProxyService.cron.loadNewContacts();
    ProxyService.cron.connectBlueToothPrinter();
    ProxyService.cron.deleteReceivedMessageFromServer();

    /// to avoid receiving the message of the contact you don't have in your book
    /// we need to load contacts when the app starts.
    ProxyService.api.contacts().asBroadcastStream();
    ProxyService.dynamicLink.handleDynamicLink();
  }

  void _setupAnimation() {
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward(from: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _sideOpenController.dispose();
    _fadeController.dispose();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      key: Key('businessHomeView'),
      viewModelBuilder: () => BusinessHomeViewModel(),
      onModelReady: (model) async {
        await model.currentOrder();
        model.registerLocation();
        model.getTickets();
        model.updatePayable();
        // on component init then we check if business have enabled backup
        // then if not it shows the bottom sheet to enable backup
        // once the user click enable backup we check again if a user is on any plan
        // if not pop the screen show the add card screen
        // on adding card and on first payment success then we pop the screen and who backup screen again
        // TODOwork in progress not uploading the backup need more debug.
        if (ProxyService.remoteConfig.isBackupAvailable()) {
          if (ProxyService.api.getBusiness().backUpEnabled == false) {
            // await model.backUpEnabled();
            //show the bottom sheet to add card
            FlipperBottomSheet.showAddPaymentMethod(
              model: model,
              context: context,
            );
          }
        }

        // if(ProxyService.api.getBusiness().backUpEnabled == true) {
        //   if(ProxyService.api.getBusiness().onAnyPlan == false) {
        //     await model.onAnyPlan();
        //   }
        // }
        // if(ProxyService.api.getBusiness().backUpEnabled == true) {
        //   if(ProxyService.api.getBusiness().onAnyPlan == true) {
        //     if(ProxyService.api.getBusiness().onAnyPlan.isCardAdded == false) {
        //       await model.onAnyPlanCardAdded();
        //     }
        //   }
        // }
        // if(ProxyService.api.getBusiness().backUpEnabled == true) {
        //   if(ProxyService.api.getBusiness().onAnyPlan == true) {
        //     if(ProxyService.api.getBusiness().onAnyPlan.isCardAdded == true) {
        //       if(ProxyService.api.getBusiness().onAnyPlan.isPaymentSuccess == false) {
        //         await model.onAnyPlanPaymentSuccess();
        //       }
        //     }
        //   }
        // }
        // if(ProxyService.api.getBusiness().backUpEnabled == true) {
        //   if(ProxyService.api.getBusiness().onAnyPlan == true) {
        //     if(ProxyService.api.getBusiness().onAnyPlan.isCardAdded == true) {
        //       if(ProxyService.api.getBusiness().onAnyPlan.isPaymentSuccess == true) {
        //         await model.onAnyPlanPaymentSuccess();
        //       }
        //     }
        //   }
        // }

        //register remote config
      },
      builder: (context, model, child) {
        switch (ProxyService.box.read(key: 'page')) {
          case 'business':
            return BusinessWidget(model);
          case 'social':
            if (ProxyService.remoteConfig.isChatAvailable()) {
              return Lite();
            } else {
              return BusinessWidget(model);
            }
          case 'openBusiness':
            return Text('open business');
          case 'closedBusiness':
            return Text('closed business');
          default:
        }
        return BusinessWidget(model);
      },
    );
  }

  Widget BodyWidget(BusinessHomeViewModel model) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideOutScreen(
        sideOpenController: _sideOpenController,
        side: const Text('Side'),
        main: Column(
          children: [
            KeyPadHead(
              tab: model.tab,
              payable: PayableView(
                onClick: () {
                  if (model.kOrder != null) {
                    ProxyService.nav.navigateTo(Routes.pay);
                  } else {
                    showSimpleNotification(
                      Text(Localization.of(context)!.noPayable),
                      background: Colors.green,
                      position: NotificationPosition.bottom,
                    );
                  }
                },
                tickets:
                    model.tickets.isEmpty ? 0 : model.tickets.length.toDouble(),
                orders:
                    model.kOrder != null ? model.kOrder!.orderItems.length : 0,
                duePay:
                    model.kOrder != null ? model.totalPayable.toDouble() : 0.00,
                ticketHandler: () async {
                  log.i(model.tickets.length);
                  await model.keypad.getTickets();
                  await model.keypad.getOrder(
                      branchId: ProxyService.box.read(key: 'branchId'));
                  if (model.kOrder == null && model.tickets.isNotEmpty) {
                    //then we know we need to resume.
                    FlipperBottomSheet.showTicketsToSaleBottomSheet(
                      model: model,
                      context: context,
                    );
                  }
                  model.saveTicket((handle) {
                    if (handle == 'error') {
                      //show the modal to add a not to a ticket here
                      FlipperBottomSheet.showAddNoteToSaleBottomSheet(
                        model: model,
                        context: context,
                      );
                    } else if (handle == 'saved') {
                      showSimpleNotification(
                        Text('Note added'),
                        background: Colors.green,
                        position: NotificationPosition.bottom,
                      );
                    }
                  });
                },
              ),
              onClick: () {
                FlipperBottomSheet.showAddNoteToSaleBottomSheet(
                  model: model,
                  context: context,
                );
              },
              controller: controller,
              amount: double.parse(model.key),
            ),
            model.tab == 0
                ? KeyPadView(model: model)
                // show a list of products and on click handle different scenarios
                : Flexible(child: ProductView(userId: '1', items: true)),
          ],
        ),
      ),
    );
  }

  Widget BusinessWidget(BusinessHomeViewModel model) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        appBar: HomeAppBar(
          scaffoldKey: _scaffoldKey,
          sideOpenController: _sideOpenController,
          child: SaleIndicator(
            counts: model.countedOrderItems,
            onClick: () {
              if (model.countedOrderItems > 0) {
                ProxyService.nav.navigateTo(Routes.summary);
              }
            },
            onLogout: () async {
              await ProxyService.api.logOut();
              ProxyService.nav.navigateTo(Routes.initial);
            },
          ),
        ),
        body: !isMacOs && !isWindows
            ? UpgradeAlert(
                durationToAlertAgain: Duration(days: 1),
                dialogStyle: UpgradeDialogStyle.cupertino,
                child: BodyWidget(model))
            : BodyWidget(model),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              HeroDialogRoute(
                builder: (context) {
                  return const OptionModal(
                    child: AddProductButtons(),
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: addProductHero,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 1,
                    child: Icon(
                      CupertinoIcons.add,
                      color: Colors.white,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      Localization.of(context)!.addProduct,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: BottomMenuBar(
            switchTab: (index) {
              setState(() {
                model.setTab(tab: index);
              });
            },
          ),
        ),
        drawer: FlipperDrawer(
          businesses: model.businesses,
        ),
      ),
    );
  }
}
