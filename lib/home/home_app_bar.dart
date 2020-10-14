import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/cart.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    @required this.scaffoldKey,
    @required this.sideOpenController,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueNotifier<bool> sideOpenController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return SafeArea(
          top: true,
          child: Center(
            child: Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  _hamburger(),
                  Align(
                    alignment: Alignment.center,
                    // ignore: always_specify_types
                    child: StreamBuilder(
                      // FIXME(richard): replace this with couchbaselite too
                      stream: vm.database.orderDetailDao
                      // there was this: vm.order==null?null:vm.order.id.toString()
                          .getCartsStream(null),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<OrderDetailTableData>>
                              orderDetail) {
                        // ignore: always_specify_types
                        final quantity = orderDetail.data == null
                            ? 0
                            : orderDetail.data
                                // ignore: always_specify_types
                                .fold(0, (a, OrderDetailTableData b) => a + b.quantity);
                        return FlatButton(
                          onPressed: () {
                            final FlipperNavigationService _navigationService =
                                locator<FlipperNavigationService>();

                            List<Cart> cart = [];
                            for (var i = 0; i < orderDetail.data.length; i++) {
                              cart.add(
                                Cart((c) => c
                                      ..id = orderDetail.data[i].id
                                      ..branchId = orderDetail.data[i].branchId
                                      ..quantity =
                                          orderDetail.data[i].quantity.toInt()
                                      ..variationName =
                                          orderDetail.data[i].variantName
                                      ..variationId =
                                          orderDetail.data[i].variationId
                                    // ..parentName = snapshot.data[i].parentName,
                                    ),
                              );
                            }

                            _navigationService.navigateTo(
                              Routing.cartDetailsScreen,
                              arguments: CartDetailsScreenArguments(
                                carts: cart,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                            child: Text(
                              orderDetail.data == null || quantity == 0
                                  ? 'No Sale'
                                  : 'Current Sale' +
                                      '[' +
                                      quantity.toInt().toString() +
                                      ']',
                              style: GoogleFonts.lato(
                                  fontStyle: FontStyle.normal,
                                  color: Theme.of(context).accentColor,
                                  fontSize:  Theme.of(context).textTheme
                                      .bodyText1.fontSize),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _hamburger() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          scaffoldKey.currentState.openDrawer();
        },
        child: Container(
          width: appBarSize,
          height: appBarSize,
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Image.asset(
                  'assets/graphics/menu_icon.png', //TODO(richard): change it to our icon later.
                  width: 25,
                  height: 25,
                ),
                Visibility(
                  visible: true,
                  child: Positioned(
                    top: -3,
                    right: -5,
                    height: 12,
                    width: 12,
                    child: Image.asset(
                      'assets/graphics/updates_indicator_white.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarSize);
}
