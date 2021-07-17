library flipper_dashboard;

import 'package:flipper/localization.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'desktop_view.dart';
import 'flipper_drawer.dart';
import 'hero_dialog_route.dart';
import 'home_app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:stacked/stacked_annotations.dart';
import 'keypad_head_view.dart';
import 'keypad_view.dart';
import 'package:flipper_chat/flipper_chat_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    if (!isWindows) {
      ///gives you the message on which user taps
      ///and it opened the app from terminated state

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          // final routeFromMessage = message.data["route"];
          // Navigator.of(context).pushNamed(routeFromMessage);
        }
      });

      ///forground work
      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          log.i(message.notification!.body);
          log.i(message.notification!.title);
        }
        ProxyService.notification.display(message);
      });

      ///When the app is in background but opened and user taps
      ///on the notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // TODO decide on creating notification that open page,this is for chat mainly etc...
        // final routeFromMessage = message.data["route"];
        // Navigator.of(context).pushNamed(routeFromMessage);
      });
      // FirebaseMessaging.subscribe()
    }
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
      onModelReady: (model) {
        model.getOrders();
        model.registerLocation();
        //register remote config
        ProxyService.remoteConfig.setDefault();
        ProxyService.remoteConfig.config();
        ProxyService.remoteConfig.fetch();
        //connect to anyy available printer
        ProxyService.printer.getBluetooths();
        ProxyService.analytics.recordUser();
        ProxyService.forceDateEntry.caller();
        // init the crashlytics
        // ProxyService.crash.initializeFlutterFire();
        model.getTickets();
        // implement review system.
        ProxyService.review.review();
      },
      builder: (context, model, child) {
        if (isWindows || isMacOs) {
          return DesktopView(
            model: model,
            controller: controller,
            userName: ProxyService.box.read(key: 'userName') ?? 'N/A',
            userProfileImg: ProxyService.box.read(key: 'businessUrl'),
          );
        } else {
          switch (ProxyService.box.read(key: 'page')) {
            case 'business':
              return BusinessWidget(model);
            case 'social':
              if (ProxyService.remoteConfig.isChatAvailable()) {
                return FlipperChatApp();
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
        }
      },
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
            totalAmount: 300,
            counts: model.countedOrderItems,
            onClick: () {
              if (model.countedOrderItems > 0) {
                ProxyService.nav.navigateTo(Routes.summary);
              }
            },
            onLogout: () async {
              await ProxyService.api.logOut();
              ProxyService.nav.navigateTo(Routes.startUpView);
            },
          ),
        ),
        body: FadeTransition(
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
                      ProxyService.nav.navigateTo(Routes.pay);
                    },
                    tickets: model.tickets.isEmpty
                        ? 0
                        : model.tickets.length.toDouble(),
                    orders: model.orders.length,
                    duePay: model.orders.isNotEmpty
                        ? model.orders[0].orderItems
                            .fold(0, (a, b) => a + b.price)
                        : 0.00,
                    ticketHandler: () {
                      if (model.orders.isEmpty && model.tickets.isNotEmpty) {
                        //then we know we need to resume.
                        FlipperBottomSheet.showTicketsToSaleBottomSheet(
                          model: model,
                          context: context,
                        );
                      }
                      model.saveTicket((handle) {
                        if (handle == 'error') {
                          showSimpleNotification(
                              Text(Localization.of(context)!.saveTicket),
                              background: Colors.red);
                        } else if (handle == 'saved') {
                          showSimpleNotification(Text('Note added'),
                              background: Colors.green);
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
                    : ProductView(userId: '1', items: true),
              ],
            ),
          ),
        ),
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
                      Icons.add,
                      size: 20.sp,
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
