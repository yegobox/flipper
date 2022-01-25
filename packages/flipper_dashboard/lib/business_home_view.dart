library flipper_dashboard;

import 'package:flipper_dashboard/body.dart';
import 'package:flipper_dashboard/member_field.dart';
import 'package:flipper_dashboard/bottom_sheet.dart';

import 'package:flipper_dashboard/flipper_drawer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_dashboard/sale_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'bottom_menu_bar.dart';
import 'home_app_bar.dart';
import 'package:stacked/stacked.dart';
// import 'package:flipper_models/flipper_models.dart';
import 'package:flipper_models/models/models.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_chat/omni_chat.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;

@FormView(fields: [FormTextField(name: 'note')])
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _sideOpenController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController controller = TextEditingController();
  final log = getLogger('KeyPadHead');
  late StateSetter _modalStateSetter;
  String combination = 'N';

  Future<void> startNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    log.i('NFC is available: $isAvailable');
    if (!isWindows && !isMacOs && !isWeb && isAvailable) {
      // Start Session
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          // Do something with an NfcTag instance.
        },
      );
    }
  }

  chatAuth() async {
    BusinessSync business = ProxyService.api.getBusiness();
    // User? user = await ProxyService.auth.getCurrentUserId();

    // await ProxyService.firestore.createUserInFirestore(user: {
    //   'firstName': business.name,
    //   'lastName': null,
    //   'email': '  ',
    //   'uid': user!.uid,
    //   'imageUrl': 'https://i.pravatar.cc/300'
    // });

    /// update related contact with upated user.uid
    // business.chatUid = user!.uid;
    ProxyService.firestore.addContact(business: business);
  }

  @override
  void initState() {
    // super.initState();
    // Check availability
    ///TODOuse the interface instead not this anymore!
    // if (!isWeb && !isWindows && !isMacOs) {
    //   startNFC();
    // }
    _sideOpenController = ValueNotifier<bool>(false);
    ProxyService.notification.initialize();
    ProxyService.dynamicLink.handleDynamicLink();
    ProxyService.notification.listen();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.fetch();
    //connect to anyy available printer
    // ProxyService.printer.blueTooths();
    ProxyService.analytics.recordUser();
    ProxyService.forceDateEntry.caller();
    // init the crashlytics
    // ProxyService.crash.initializeFlutterFire();
    // implement review system.
    ProxyService.review.review();
    // schedule the report
    ProxyService.cron.schedule();
    ProxyService.cron.connectBlueToothPrinter();
    ProxyService.cron.deleteReceivedMessageFromServer();
    if (!isWeb && !isWindows && !isMacOs) {
      chatAuth();
    }

    /// This is one solution to have data synced across devices. and connected clients
    /// once the objectbox sync is available the option will be evaluated and added. to package and maybe also
    /// the two solution will be sold differently with different price.
    if (ProxyService.remoteConfig.isSyncAvailable()) {
      ProxyService.syncApi.pull();
      ProxyService.syncApi.push();
    }

    /// to avoid receiving the message of the contact you don't have in your book
    /// we need to load contacts when the app starts.
    // ProxyService.api.contacts().asBroadcastStream();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _sideOpenController.dispose();
    // _fadeController.dispose();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      key: Key('businessHomeView'),
      viewModelBuilder: () => BusinessHomeViewModel(),
      onModelReady: (model) async {
        await model.currentOrder();
        model.registerLocation();
        model.getTickets();
        model.updatePayable();
        // on component init then we check if business have enabled backup
        // then if not it shows the bottom sheet to enable backup
        // once the user click enable backup we check again if a user is on any plan
        // if not pop the screen show the add card screen
        // on adding card and on first payment success then we pop the screen and who backup screen again
        //register remote config
      },
      builder: (context, model, child) {
        switch (ProxyService.box.read(key: 'page')) {
          case 'business':
            return BusinessWidget(model);
          case 'social':
            if (ProxyService.remoteConfig.isChatAvailable()) {
              return OmniChat();
            } else {
              return BusinessWidget(model);
            }
          case 'openBusiness':
            return Text('open business');
          case 'closedBusiness':
            return Text('closed business');
          default:
        }
        return BusinessWidget(model);
      },
    );
  }

  Widget BusinessWidget(BusinessHomeViewModel model) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        appBar: HomeAppBar(
          scaffoldKey: _scaffoldKey,
          sideOpenController: _sideOpenController,
          child: SaleIndicator(
            counts: model.countedOrderItems,
            onClick: () {
              if (model.countedOrderItems > 0) {
                ProxyService.nav.navigateTo(Routes.summary);
              }
            },
            onLogout: () async {
              await ProxyService.api.logOut();
              ProxyService.nav.navigateTo(Routes.initial);
            },
          ),
        ),
        body: !isMacOs && !isWindows && !kDebugMode
            ? UpgradeAlert(
                durationToAlertAgain: Duration(days: 1),
                dialogStyle: UpgradeDialogStyle.cupertino,
                child: BodyWidget(
                  model: model,
                  sideOpenController: _sideOpenController,
                  controller: controller,
                ),
              )
            : BodyWidget(
                model: model,
                sideOpenController: _sideOpenController,
                controller: controller,
              ),
        bottomNavigationBar: SafeArea(
          child: BottomMenuBar(
            switchTab: (index) {
              setState(() {
                model.setTab(tab: index);
              });
            },
          ),
        ),
        drawer: FlipperDrawer(
          businesses: model.businesses,
          addWorkSpace: () {
            addWorkSpace(context: context);
          },
          preferenceController: () {
            preferences(context: context, model: model);
          },
          inviteController: () {
            /// start by adding default field.
            List<Widget> widgets = [];

            /// add initial field.
            addMemberFieldA(widgets);
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    _modalStateSetter = setState;
                    return Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            title: Row(children: const [Text('Invite')]),
                            trailing: Text('Send Request'),
                          ),
                          Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ListView.builder(
                                itemCount: widgets.length,
                                itemBuilder: (context, index) {
                                  return widgets[index];
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
                });
          },
        ),
      ),
    );
  }

  /// Needed when user start typing on field to add new field.
  /// just refer to slack when adding members, but failed to achive now only using one field now
  ///TODOso it stays as work in progress to be improved in future.!
  void addMemberFieldA(List<Widget> widgets) {
    TextEditingController _controller = TextEditingController();
    setState(() {
      widgets.add(
        MemberField(
          controller: _controller,
          trailingTapped: () {
            _modalStateSetter(() {
              if (widgets.length > 1) {
                // widgets.removeLast();
              }
            });
          },
          inputChange: (key) {
            // combination = key;
            if (key.length == 2 && combination != 'R') {
              /// Avoiding dups we set combination to R which will indicate that we won't care for the second iteration
              // addMemberField(widgets, _controller);
            }

            /// reset combination when the key is a valid phone number
            /// and when is not set it back to R? which will not add extra field
            /// when they key is empty then remove last field added.
          },
        ),
      );
    });
  }
}
