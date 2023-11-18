import 'package:flipper_dashboard/favorites.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'body.dart';
import 'keypad_view.dart';
import 'product_view.dart';

class CheckOut extends StatefulHookConsumerWidget {
  CheckOut({
    Key? key,
    required this.isBigScreen,
  }) : super(key: key);

  final bool isBigScreen;

  @override
  CheckOutState createState() => CheckOutState();
}

class CheckOutState extends ConsumerState<CheckOut>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TabController tabController;
  final FocusNode keyPadFocusNode = FocusNode();
  final TextEditingController textEditController = TextEditingController();

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
    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      tabController = TabController(length: 3, vsync: this);
      // run the code in here only once.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTransaction = ref.watch(pendingTransactionProvider);
    if (widget.isBigScreen) {
      return ViewModelBuilder<CoreViewModel>.reactive(
          viewModelBuilder: () =>
              CoreViewModel(transaction: currentTransaction.value!),
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
                        PaymentTicketManager(
                          context: context,
                          model: model,
                          controller: textEditController,
                          nodeDisabled: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      final currentTransaction = ref.watch(pendingTransactionProvider);
      return ViewModelBuilder<CoreViewModel>.reactive(
        viewModelBuilder: () =>
            CoreViewModel(transaction: currentTransaction.value!),
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              return onWillPop(
                  context: context,
                  navigationPurpose: NavigationPurpose.home,
                  message: 'Do you want to go home?');
            },
            child: Stack(
              children: [
                MobileView(
                    widget: widget,
                    tabController: tabController,
                    textEditController: textEditController,
                    model: model),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    child: PaymentTicketManager(
                      context: context,
                      model: model,
                      controller: textEditController,
                      nodeDisabled: true,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    required this.widget,
    required this.tabController,
    required this.textEditController,
    required this.model,
    Key? key,
  }) : super(key: key);
  final CoreViewModel model;
  final CheckOut widget;
  final TabController tabController;
  final TextEditingController textEditController;

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
          ),
        ),
        backgroundColor: ProxyService.status.statusColor.value,
        automaticallyImplyLeading: false,
        toolbarHeight:
            ProxyService.status.statusText.value?.isNotEmpty == true ? 25 : 0,
      ),
      body: Column(
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xffE5E5E5),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: TabBar(
                  onTap: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    color: const Color(0xffFFFFFF),
                  ),
                  labelColor: Colors.black,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Container(
                      width: 150,
                      child: Tab(
                        text: 'Keypad',
                      ),
                    ),

                    // second tab [you can add an icon using the icon property]
                    Container(
                      width: 150,
                      child: Tab(
                        text: 'Library',
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Tab(
                        text: 'Favorites',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    KeyPadView(model: model),
                    SizedBox(
                      height: 110,
                    )
                  ],
                ),
                ProductView.normalMode(),
                Favorites(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
