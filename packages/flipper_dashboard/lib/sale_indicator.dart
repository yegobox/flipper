import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/features/kitchen_display/providers/transaction_items_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_services/proxy.dart';
import 'add_product_buttons.dart';

final isAndroid = UniversalPlatform.isAndroid;
final isIos = UniversalPlatform.isIOS;

class SaleIndicator extends StatefulHookConsumerWidget {
  SaleIndicator({Key? key, required this.onClick, required this.onLogout})
    : super(key: key);

  final Function onClick;
  final Function onLogout;

  @override
  SaleIndicatorState createState() => SaleIndicatorState();
}

class SaleIndicatorState extends ConsumerState<SaleIndicator> {
  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );

    // Use provider to fetch transaction items instead of direct stream call
    // This prevents duplicate Ditto subscriptions
    final transactionItemsAsync = transaction.value != null
        ? ref.watch(transactionItemsProvider(transaction.value!.id))
        : null;

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (a, model, b) {
        return Row(
          children: [
            transactionItemsAsync == null
                ? const SizedBox.shrink()
                : transactionItemsAsync.when(
                    data: (transactionItems) {
                      final int counts = transactionItems.length;

                      return counts == 0
                          ? Text(
                              'No Sale',
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )
                          : InkWell(
                              onTap: () {
                                widget.onClick();
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
                    loading: () => Text(
                      'No Sale',
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    error: (_, __) => Text(
                      'No Sale',
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
            const Spacer(),
            if (ProxyService.remoteConfig.isChatAvailable())
              GestureDetector(
                onTap: () {},
                child: const Icon(Ionicons.chatbox_sharp, color: Colors.black),
              ),
            Container(width: 30),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const OptionModal(child: AddProductButtons()),
                );
              },
              child: const Icon(CupertinoIcons.add, color: Colors.black),
            ),
          ],
        );
      },
    );
  }
}
