library flipper_dashboard;

import 'package:flipper/routes.router.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/sale_indicator.dart';
import 'package:flipper_dashboard/slide_out_screen.dart';
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
import 'package:flipper/localize.dart';

@FormView(fields: [FormTextField(name: 'note')])
class BusinessHomeView extends StatefulWidget {
  const BusinessHomeView({Key? key}) : super(key: key);

  @override
  _BusinessHomeViewState createState() => _BusinessHomeViewState();
}

class _BusinessHomeViewState extends State<BusinessHomeView>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _sideOpenController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Animation<double> _fadeAnimation;
  late AnimationController _fadeController;
  TextEditingController controller = TextEditingController();
  int tab = 0;
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
      },
      builder: (context, model, child) {
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
                    tab == 0
                        ? KeyPadHead(
                            payable: PayableView(
                              onClick: () {},
                              tickets: 0,
                              orders: 0,
                              duePay: 0,
                            ),
                            onClick: () {},
                            controller: controller,
                            amount: double.parse(model.key),
                          )
                        : SizedBox.shrink(),
                    tab == 0
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
                          ' Add Product',
                          // localize(context)?.addProduct ?? '',
                          // FlipperLocalizations.of(context).rallyTitleBills,
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
              child: BottomMenubar(
                switchTab: (index) {
                  setState(() {
                    tab = index;
                  });
                },
              ),
            ),
            drawer: FlipperDrawer(
              businesses: model.businesses,
            ),
          ),
        );
      },
    );
  }
}
