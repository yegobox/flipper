import 'dart:ui';
import 'package:flipper/bottom_sheets/bottom_sheet_builder.dart';
import 'package:flipper_chat/omni/omni_conversations.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_chat/omni/helpers.dart';
import 'package:flipper_dashboard/bottom_sheet.dart';
import 'package:flipper_chat/omni/widgets/chat_app_bar.dart';
import 'package:flipper_chat/omni/widgets/button_circle.dart';
import 'package:flipper_chat/omni/widgets/tabsw.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'omni/calls_page.dart';
import 'omni/orders_page.dart';
import 'omni/update_profile.dart';

class OmniChat extends StatefulWidget {
  const OmniChat({Key? key}) : super(key: key);

  @override
  _OmniChatState createState() => _OmniChatState();
}

class _OmniChatState extends State<OmniChat> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    ProxyService.cron.schedule();

    if (SchedulerBinding.instance?.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        int businessId = ProxyService.box.read(key: 'businessId');
        Profile? profile = ProxyService.api.profile(businessId: businessId);
        if (profile == null) {
          bottomSheetBuilderProfile(
            context: context,
            body: <Widget>[UpdateProfile()],
            header: header(title: 'Update Profile'),
          );
        }
      });
    }
  }

  void changePage(int index) {
    if ((index + 1) == pageController.page ||
        (index - 1) == pageController.page) {
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // SystemChrome.setEnabledSystemUIOverlays([);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ));
    });

    return ViewModelBuilder<MessageViewModel>.reactive(
      viewModelBuilder: () => MessageViewModel(),
      onModelReady: (model) {
        //
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: ChatAppBar('Flipper', btnBack: false),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (indexPage) {
                      pageIndex.value = indexPage;
                    },
                    itemCount: 4,
                    itemBuilder: (_, int index) {
                      switch (index) {
                        case 0:
                          return OmnConversations(model: model);
                        case 1:
                          return OrderPage(model: model);
                        case 3:
                          return CallsPage(model: model);
                        default:
                          return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: pageIndex,
                  builder: (_, value, __) {
                    return Tabs(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      listBtnTabs: [
                        BtnTab(
                          text: 'Chats',
                          notications: 0,
                          status: (value == 0),
                          ontap: () => changePage(0),
                        ),
                        BtnTab(
                          text: 'Orders',
                          notications: 0,
                          status: (value == 1),
                          ontap: () => changePage(1),
                        ),
                        // BtnTab(
                        //   text: 'Calls',
                        //   status: (value == 3),
                        //   ontap: () => changePage(3),
                        // ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: Align(
            heightFactor: 2.70,
            widthFactor: 0.5,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
              ),
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.5),
                    builder: (BuildContext context) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.9, sigmaY: 0.9),
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                // color: Colors.white.withOpacity(0.8),
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text(
                                        'Flipper apps',
                                        style: Helpers.txtDefault.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ButtonCircle(
                                          onPressed: () {},
                                          icon: CupertinoIcons.person_2,
                                          size: 70,
                                          iconSize: 32,
                                        ),
                                        ButtonCircle(
                                          onPressed: () {
                                            ProxyService.box.write(
                                              key: pageKey,
                                              value: 'business',
                                            );
                                            ProxyService.nav.navigateTo(
                                              Routes.home,
                                            );
                                          },
                                          icon: Icons.update_outlined,
                                          size: 70,
                                          iconSize: 32,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                color: Helpers.principalColor,
                splashRadius: 19,
                splashColor: Colors.grey,
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Ionicons.swap_horizontal,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
