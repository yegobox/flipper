import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

import 'body.dart';
import 'keypad_view.dart';
import 'product_view.dart';

class CheckOut extends StatelessWidget {
  const CheckOut(
      {Key? key,
      required this.model,
      required this.controller,
      required this.tabController})
      : super(key: key);
  final BusinessHomeViewModel model;
  final TextEditingController controller;
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // give the tab bar a height [can change hheight to preferred height]
        Padding(
          padding: const EdgeInsets.fromLTRB(19.0, 15.5, 19.0, 0),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(
                7.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 2.5, 2.5, 2.5),
              child: TabBar(
                controller: tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    7.0,
                  ),
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
                    child: Tab(
                      text: 'Keypad',
                    ),
                  ),

                  // second tab [you can add an icon using the icon property]
                  SizedBox(
                    height: 41,
                    child: Tab(
                      text: 'Library',
                    ),
                  ),
                  SizedBox(
                    height: 41,
                    child: Tab(
                      text: 'Favourites',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // tab bar view here
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              Column(
                children: [
                  KeyPadView(model: model),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 24.5, 0, 0),
                    child: PaymentTicketManager(
                        context: context,
                        model: model,
                        controller: controller,
                        nodeDisabled: true),
                  )
                ],
              ),
              const ProductView(),
              const Center(
                child: Text(
                  'Comming soon',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
