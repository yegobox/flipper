import 'package:flipper_dashboard/favorites.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'body.dart';
import 'keypad_view.dart';
import 'product_view.dart';

class CheckOut extends StatefulWidget {
  CheckOut({
    Key? key,
    required this.controller,
    required this.tabController,
    required this.isBigScreen,
  }) : super(key: key);

  final bool isBigScreen;
  final TextEditingController controller;
  final TabController tabController;

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final FocusNode keyPadFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBigScreen) {
      return ViewModelBuilder<BusinessHomeViewModel>.reactive(
          viewModelBuilder: () => BusinessHomeViewModel(),
          builder: (context, model, child) {
            return FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        KeyPadView(
                          model: model,
                          isBigScreen: widget.isBigScreen,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
                          child: PaymentTicketManager(
                            context: context,
                            model: model,
                            controller: widget.controller,
                            nodeDisabled: true,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      return MobileView(widget: widget);
    }
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    super.key,
    required this.widget,
  });

  final CheckOut widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          ProxyService.status.statusText.value ?? "",
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        )),
        backgroundColor: ProxyService.status.statusColor.value,
        automaticallyImplyLeading: false,
        toolbarHeight:
            ProxyService.status.statusText.value?.isNotEmpty == true ? 25 : 0,
      ),
      body: ViewModelBuilder<BusinessHomeViewModel>.reactive(
          viewModelBuilder: () => BusinessHomeViewModel(),
          builder: (context, model, child) {
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
                                text: 'Favorites',
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
                          KeyPadView(model: model),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
                            child: PaymentTicketManager(
                                context: context,
                                model: model,
                                controller: widget.controller,
                                nodeDisabled: true),
                          )
                        ],
                      ),
                      ProductView.normalMode(),
                      Favorites()
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
