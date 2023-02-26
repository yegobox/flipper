import 'package:flipper_dashboard/favorites.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

import 'body.dart';
import 'keypad_view.dart';
import 'product_view.dart';

class CheckOut extends StatefulWidget {
  CheckOut(
      {Key? key,
      required this.model,
      required this.controller,
      required this.tabController,
      required this.isBigScreen})
      : super(key: key);
  final BusinessHomeViewModel model;
  final bool isBigScreen;
  final TextEditingController controller;
  final TabController tabController;

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut>
    with SingleTickerProviderStateMixin {
  final FocusNode keyPadFocusNode = FocusNode();
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    // Calculate the top padding based on the screen height
    final topPadding = screenHeight * 0.06;
    // Get the width of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate the left padding based on the screen width
    final leftPadding = screenWidth * 0.005;
    // Calculate the top and bottom padding based on the left padding
    final topBottomPadding = leftPadding * 2.8;

    // Get the screen size

    if (widget.isBigScreen) {
      return Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(leftPadding, topBottomPadding,
                  topBottomPadding, topBottomPadding),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffE5E5E5),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: TabBar(
                  onTap: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: const Color(0xffFFFFFF),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.only(
                    left: 120,
                    right: 120,
                    top: 6,
                    bottom: 6,
                  ),
                  labelColor: Colors.black,
                  // labelStyle: tabLabelStyle,
                  // unselectedLabelColor: Colors.black,
                  // indicatorColor: Colors.black,
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Keypad',
                    ),
                  ],
                ),
              ),
            ),
            KeyPadView(
              model: widget.model,
              isBigScreen: widget.isBigScreen,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, topPadding, 0, 0),
              child: PaymentTicketManager(
                context: context,
                model: widget.model,
                controller: widget.controller,
                nodeDisabled: true,
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );
    } else {
      return NewWidget(
          leftPadding: leftPadding,
          topBottomPadding: topBottomPadding,
          widget: widget,
          topPadding: topPadding);
    }
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.leftPadding,
    required this.topBottomPadding,
    required this.widget,
    required this.topPadding,
  });

  final double leftPadding;
  final double topBottomPadding;
  final CheckOut widget;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // give the tab bar a height [can change height to preferred height]
        Padding(
          padding:
              EdgeInsets.fromLTRB(10, topBottomPadding, 10, topBottomPadding),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(leftPadding, topBottomPadding,
                  topBottomPadding, topBottomPadding),
              child: LayoutBuilder(builder: (context, constraints) {
                return TabBar(
                  onTap: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: widget.tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: const Color(0xffFFFFFF),
                  ),
                  labelColor: Colors.black,
                  // labelStyle: tabLabelStyle,
                  // unselectedLabelColor: Colors.black,
                  // indicatorColor: Colors.black,
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    SizedBox(
                      height: 41,
                      width: double.infinity,
                      child: Tab(
                        text: 'Keypad',
                      ),
                    ),

                    // second tab [you can add an icon using the icon property]
                    SizedBox(
                      height: 41,
                      width: double.infinity,
                      child: Tab(
                        text: 'Library',
                      ),
                    ),
                    SizedBox(
                      height: 41,
                      width: double.infinity,
                      child: Tab(
                        text: 'Favourites',
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        // tab bar view here
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              Column(
                children: [
                  KeyPadView(model: widget.model),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, topPadding, 0, 0),
                    child: PaymentTicketManager(
                        context: context,
                        model: widget.model,
                        controller: widget.controller,
                        nodeDisabled: true),
                  )
                ],
              ),
              const ProductView(),
              const Favorites()
            ],
          ),
        ),
      ],
    );
  }
}
