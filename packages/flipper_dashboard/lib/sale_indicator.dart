import 'package:localize/localize.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'add_product_buttons.dart';
import 'package:go_router/go_router.dart';

final isAndroid = UniversalPlatform.isAndroid;
final isIos = UniversalPlatform.isIOS;

class SaleIndicator extends StatelessWidget {
  const SaleIndicator(
      {Key? key,
      this.counts = 0,
      required this.onClick,
      required this.onLogout})
      : super(key: key);

  final int counts;
  final Function onClick;
  final Function onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      counts == 0
          ? Text(
              'No Sale',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontSize: 16,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                  ),
            )
          : InkWell(
              onTap: () {
                onClick();
              },
              child: Row(
                children: [
                  Text(
                    FLocalization.of(context).currentSale,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 16,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '(' + counts.toString() + ')',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 16,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
      const Spacer(),
      if (ProxyService.remoteConfig.isChatAvailable())
        GestureDetector(
          onTap: () {
            goToFlipperChat(context);
          },
          child: const Icon(
            Ionicons.chatbox_sharp,
            color: Color(0xffffffff),
          ),
        ),
      Container(
        width: 30,
      ),
      InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const OptionModal(
              child: AddProductButtons(),
            ),
          );
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Color(0xffffffff),
        ),
      )
    ]);
  }

  ///  navigate to flipper chat, make sure
  /// no await method is run inside as it can cause delay in the app while navigating
  void goToFlipperChat(BuildContext context) async {
    ProxyService.box.write(key: pageKey, value: 'social');
    //first register the user in firestore db
    //get the current firebase user
    // int businessId = ProxyService.box.read(key: 'businessId');
    // Business business = await ProxyService.api.getBusinessById(id: businessId);
    //patch a business to add a chat uid
    // ProxyService.firestore.addContact(business: business);
    // ProxyService.nav.navigateTo(Routes.chat);
    GoRouter.of(context).push(Routes.chat);
  }
}
