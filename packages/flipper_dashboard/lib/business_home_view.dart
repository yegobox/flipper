library flipper_dashboard;

import 'package:flipper/localization.dart';
import 'package:flipper/routes.logger.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_ui/flipper_ui.dart';
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
// import 'package:chat/screens/homepage.dart';
import 'package:chat/screens/about_chat.dart';
import 'package:overlay_support/overlay_support.dart';

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
        ProxyService.crash.initializeFlutterFire();
      },
      builder: (context, model, child) {
        switch (ProxyService.box.read(key: 'page')) {
          case 'business':
            return BusinessWidget(model);
          case 'social':
            if (ProxyService.remoteConfig.isChatAvailable()) {
              return AboutChatMiniApp();
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
                    tickets: 0,
                    orders: model.orders.length,
                    duePay: model.orders.isNotEmpty
                        ? model.orders[0].orderItems
                            .fold(0, (a, b) => a + b.price)
                        : 0.00,
                    ticketHandler: () {
                      model.saveTicket(() {
                        showSimpleNotification(
                            Text(Localization.of(context)!.saveTicket),
                            background: Colors.red);
                      });
                    },
                  ),
                  onClick: () {
                    _showAddNoteToSaleBottomSheet(model: model);
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
                    child: const Icon(
                      Icons.add,
                      size: 20,
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

  void _showAddNoteToSaleBottomSheet({required BusinessHomeViewModel model}) {
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    TextEditingController _controller = new TextEditingController();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Wrap(
              children: [
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      autofocus: true,
                      controller: _controller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Note is required';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Add note',
                        fillColor: Theme.of(context)
                            .copyWith(canvasColor: Colors.cyan[50])
                            .canvasColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#D0D7E3')),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      minLines:
                          6, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: BoxButton(
                    title: Localization.of(context)!.save,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        model.addNoteToSale(note: _controller.text);
                        ProxyService.nav.back();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
