import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'customappbar.dart';
import 'package:stacked/stacked.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'widgets/quantity_widget.dart';
import 'widgets/title_widget.dart';
import 'widgets/variant_widget.dart';

class Sell extends StatefulHookConsumerWidget {
  Sell({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  SellState createState() => SellState();
}

class SellState extends ConsumerState<Sell> {
  final _routerService = locator<RouterService>();

  final TextEditingController quantityController =
      TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    final currentTransaction = ref.watch(pendingTransactionProvider);
    return ViewModelBuilder<CoreViewModel>.reactive(
      onViewModelReady: (model) async {
        ///start by clearning the previous amountTotal and Quantity as it is confusing some time!
        model.clearPreviousSaleCounts();
        model.toggleCheckbox(variantId: '-1');
        await model.getVariants(productId: widget.product.id);
      },
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        final pendingTransaction = ref.watch(pendingTransactionProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            onPop: () {
              _routerService.pop();
            },
            title: titleWidget(
              model: model,
              name: widget.product.name,
            ),
            rightActionButtonName: 'Save',
            disableButton: false,
            showActionButton: true,
            onActionButtonClicked: () async {
              Stock? stock = await ProxyService.isar
                  .stockByVariantId(variantId: model.checked);
              Variant? variant =
                  await ProxyService.isar.getVariantById(id: model.checked);
              bool saved = await model.saveTransaction(
                  variation: variant!,
                  amountTotal: model.amountTotal,
                  customItem: false,
                  currentStock: stock.currentStock,
                  pendingTransaction: pendingTransaction.value!.value!);
              if (!saved) {
                showSimpleNotification(const Text('No item selected'),
                    background: Colors.red);
              }
              // ignore: unused_result
              ref.refresh(transactionItemsProvider);
              _routerService.pop();
            },
            icon: Icons.close,
            multi: 1,
            bottomSpacer: 49,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 30.0, 18.0, 2.0),
            child: CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.product.name,
                            style: primaryTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.grey[800]),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '  CHOOSE ONE',
                            style: primaryTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.grey.shade700),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 410,
                        child: ListView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          shrinkWrap: true,
                          children: variantsWidget(model: model),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: quantityWidget(
                      context: context,
                      model: model,
                      quantityController: quantityController,
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
