import 'package:flipper/localization.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/order.dart';
import 'package:overlay_support/overlay_support.dart';
import 'add_product_buttons.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';
import 'keypad_head_view.dart';
import 'keypad_view.dart';

class DesktopView extends StatefulWidget {
  DesktopView(
      {Key? key,
      required this.model,
      required this.controller,
      required this.userName,
      required this.userProfileImg})
      : super(key: key);
  final BusinessHomeViewModel model;
  final TextEditingController controller;
  final String userName;
  final String userProfileImg;

  @override
  _DesktopViewState createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final List<String> menuItems = [
    "Home",
    "Sale",
    "Analytics",
    "Keypad",
    "Library",
    "Settings"
  ];
  final List<IconData> menuIcons = [
    Icons.home,
    Icons.sell,
    Icons.analytics,
    Icons.keyboard,
    Icons.library_add,
    Icons.settings
  ];

  bool sidebarOpen = false;

  double yOffset = 0;
  double xOffset = 60;
  double pageScale = 1;

  int selectedMenuItem = 0;

  late Widget page;
  @override
  void initState() {
    setPageTitle();
    super.initState();
  }

  void setSidebarState() {
    setState(() {
      xOffset = sidebarOpen ? 265 : 60;
      yOffset = sidebarOpen ? 70 : 0;
      pageScale = sidebarOpen ? 0.8 : 1;
    });
  }

  void setPageTitle() {
    switch (selectedMenuItem) {
      case 0:
        setState(() {
          page = KeyPadView(model: widget.model);
        });
        break;
      case 1:
        setState(() {
          page =
              ProductView(userId: '1', items: true); //show analytics page here
        });
        break;
      case 2:
        setState(() {
          page = ProductView(userId: '1', items: true);
        });
        break;
      case 3:
        setState(() {
          page = ProductView(userId: '1', items: true);
        });
        break;
      case 4:
        setState(() {
          page = ProductView(userId: '1', items: true);
        });
        break;
      case 5:
        setState(() {
          page = KeyPadView(model: widget.model);
        });
        break;
      default:
        setState(() {
          page = KeyPadView(model: widget.model);
        });
    }
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topNavigationBar(
          context, scaffoldKey, widget.userName, widget.userProfileImg),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
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
      extendBody: true,
      body: Container(
        color: Color(0xFFB1F2B36),
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Expanded(
                          child: new ListView.builder(
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                sidebarOpen = false;
                                selectedMenuItem = index;
                                setSidebarState();
                                setPageTitle();
                              },
                              child: MenuItem(
                                onClick: (itemIcon) {
                                  if (itemIcon == Icons.keyboard) {
                                    selectedMenuItem =
                                        menuIcons.indexOf(Icons.keyboard);
                                  }
                                  if (itemIcon == Icons.library_add) {
                                    print(menuIcons.indexOf(Icons.keyboard));
                                    selectedMenuItem =
                                        menuIcons.indexOf(Icons.library_add);
                                  }
                                  setPageTitle();
                                },
                                itemIcon: menuIcons[index],
                                itemText: menuItems[index],
                                selected: selectedMenuItem,
                                position: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: MenuItem(
                          onClick: () async {
                            await ProxyService.api.logOut();
                            ProxyService.nav.navigateTo(Routes.startUpView);
                          },
                          itemIcon: Icons.logout,
                          itemText: "Logout",
                          selected: selectedMenuItem,
                          position: menuItems.length + 1,
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(xOffset, yOffset, 1.0)
                    ..scale(pageScale),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: sidebarOpen
                          ? BorderRadius.circular(0)
                          : BorderRadius.circular(0)),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        KeyPadHead(
                          tab: widget.model.tab,
                          payable: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: PayableView(
                              onClick: () {
                                ProxyService.nav.navigateTo(Routes.pay);
                              },
                              tickets: widget.model.tickets.isEmpty
                                  ? 0
                                  : widget.model.tickets.length.toDouble(),
                              orders: widget.model.orders.length,
                              duePay: widget.model.orders.isNotEmpty
                                  ? widget.model.orders[0].orderItems
                                      .fold(0, (a, b) => a + b.price)
                                  : 0.00,
                              ticketHandler: () async {
                                widget.model.keypad.getTickets();
                                widget.model.keypad.getOrders(
                                    branchId:
                                        ProxyService.box.read(key: 'branchId'));
                                if (widget.model.orders.isEmpty &&
                                    widget.model.tickets.isNotEmpty) {
                                  //then we know we need to resume.
                                  FlipperBottomSheet
                                      .showTicketsToSaleBottomSheet(
                                    model: widget.model,
                                    context: context,
                                  );
                                }
                                widget.model.saveTicket((handle) {
                                  if (handle == 'error') {
                                    showSimpleNotification(
                                        Text(Localization.of(context)!
                                            .saveTicket),
                                        background: Colors.red);
                                  } else if (handle == 'saved') {
                                    showSimpleNotification(Text('Note added'),
                                        background: Colors.green);
                                  }
                                });
                              },
                            ),
                          ),
                          onClick: () {
                            FlipperBottomSheet.showAddNoteToSaleBottomSheet(
                              model: widget.model,
                              context: context,
                            );
                          },
                          controller: widget.controller,
                          amount: double.parse(widget.model.key),
                        ),
                        page
                      ],
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
}

class MenuItem extends StatelessWidget {
  final String? itemText;
  final IconData? itemIcon;
  final int? selected;
  final int? position;
  final Function? onClick;
  MenuItem(
      {this.itemText,
      this.itemIcon,
      this.selected,
      this.position,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick!(itemIcon);
        }
      },
      child: Container(
        color: selected == position ? Color(0xFFB151E26) : Color(0xFFB1F2B36),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Icon(
                itemIcon,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: '',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                itemText!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
