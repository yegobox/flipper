import 'package:flipper/localization.dart';
import 'package:flipper_dashboard/loader.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/drawer_viewmodel.dart';
import 'package:flipper_services/abstractions/dynamic_link.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'atoms_widgets.dart';
import 'business_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_widgets.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_services/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ant_icons/ant_icons.dart';

class FlipperDrawerV2 extends StatefulWidget {
  FlipperDrawerV2({Key? key, required this.businesses}) : super(key: key);
  final List<Business> businesses;

  @override
  State<FlipperDrawerV2> createState() => _FlipperDrawerV2State();
}

class _FlipperDrawerV2State extends State<FlipperDrawerV2> {
  final DynamicLink _link = locator<DynamicLink>();
  bool isSwitched = false;

  Widget _footer(
      {required DrawerViewModel drawerViewmodel,
      required BuildContext context}) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          if (ProxyService.remoteConfig.isChatAvailable())
            menuListRowButton(
              'Flipper Social',
              context: context,
              icon: Ionicons.chatbox,
              onPressed: () async {
                ProxyService.box.write(key: pageKey, value: 'social');
                //first register the user in firestore db
                //get the current firebase user
                User? user = await ProxyService.auth.getCurrentUserId();
                int businessId = ProxyService.box.read(key: 'businessId');
                Business business =
                    await ProxyService.api.getBusinessById(id: businessId);
                //patch a business to add a chat uid

                ProxyService.firestore.createUserInFirestore(user: {
                  'firstName': business.name,
                  'lastName': '',
                  'email': '  ',
                  'uid': user!.uid,
                  'imageUrl': 'https://dummyimage.com/300/09f.png/fff'
                  // 'imageUrl':
                  // "https://avatars.dicebear.com/api/micah/$name.svg",
                });
                ProxyService.nav.navigateTo(Routes.chat);
              },
            ),
          const Divider(height: 0),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
                height: 45,
              ),
              GestureDetector(
                onTap: () async {
                  String uri = await _link.createDynamicLink();
                  ProxyService.share.share(uri.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                    child: Container(
                      height: 10,
                      child: Icon(
                        IconData(0xf066, fontFamily: 'TwitterIcon'),
                        size: 25,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // drawerViewmodel.loginWithQr(context: context);
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.center_focus_weak,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      viewModelBuilder: () => DrawerViewModel(),
      builder: (context, model, child) => Container(
        child: SafeArea(
          child: Drawer(
            elevation: 0,
            child: Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: HexColor('#130f1f'),
                    width: 60,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        BusinessButton(
                          business: widget.businesses[0],
                          onPressedCircle: (Business business) {
                            // model.switchBusiness(from: model.business, to: business);
                          },
                          isActive: true,
                          hasUpdates: true,
                        ),
                        Positioned(
                          bottom: 10,
                          left: 8,
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: Image.asset('assets/fliper-logo.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 45),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: <Widget>[
                              const Divider(),
                              menuListRowButton(
                                Localization.of(context)!.flipperSetting,
                                context: context,
                                icon: AntIcons.setting,
                                onPressed: () {
                                  ProxyService.nav.navigateTo(Routes.settings);
                                },
                              ),
                              const Divider(),
                              if (ProxyService.remoteConfig
                                  .isAnalyticFeatureAvailable())
                                menuListRowButton(
                                  'Analytics',
                                  context: context,
                                  icon: Ionicons.analytics,
                                  onPressed: () {
                                    ProxyService.nav
                                        .navigateTo(Routes.analytics);
                                  },
                                ),
                              const Divider(),
                            ],
                          ),
                        ),
                        _footer(
                          drawerViewmodel: model,
                          context: context,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
