import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_services/proxy.dart';
import 'add_product_buttons.dart';

final isAndroid = UniversalPlatform.isAndroid;
final isIos = UniversalPlatform.isIOS;

class SaleIndicator extends StatelessWidget {
  SaleIndicator({Key? key, required this.onClick, required this.onLogout})
      : super(key: key);

  final Function onClick;
  final Function onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      StreamBuilder<List<OrderItem>>(
        stream: ProxyService.isar.orderItemsStream(),
        builder: (context, snapshot) {
          final List<OrderItem> orderItems = snapshot.data ?? [];
          final int counts = orderItems.length;

          return counts == 0
              ? Text(
                  'No Sale',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 16,
                        color: Colors.black,
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
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '(' + counts.toString() + ')',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                );
        },
      ),
      const Spacer(),
      if (ProxyService.remoteConfig.isChatAvailable())
        GestureDetector(
          onTap: () {},
          child: const Icon(
            Ionicons.chatbox_sharp,
            color: Colors.black,
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
          color: Colors.black,
        ),
      )
    ]);
  }
}
