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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBigScreen) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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

                /// this code is no longer of use, it is here as documentation
                // indicatorPadding: EdgeInsets.only(
                //   left: 120,
                //   right: 120,
                //   top: 6,
                //   bottom: 6,
                // ),
                labelColor: Colors.black,
                // labelStyle: tabLabelStyle,
                // unselectedLabelColor: Colors.black,
                // indicatorColor: Colors.black,
                tabs: const [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Keypad',
                  ),
                  Tab(
                    text: 'Orders',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    KeyPadView(
                      model: widget.model,
                      isBigScreen: widget.isBigScreen,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
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
                Text("Tab 2")
              ],
            ),
          ),
        ],
      );
    } else {
      return NewWidget(widget: widget);
    }
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.widget,
  });

  final CheckOut widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // give the tab bar a height [can change height to preferred height]
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                    padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
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
