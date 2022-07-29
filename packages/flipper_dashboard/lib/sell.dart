import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'customappbar.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';

import 'widgets/quantity_widget.dart';
import 'widgets/title_widget.dart';
import 'widgets/variant_widget.dart';

class Sell extends StatelessWidget {
  Sell({Key? key, required this.product}) : super(key: key);
  final Product product;

  final log = getLogger('Sell');

  final TextEditingController quantityController =
      TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      onModelReady: (model) async {
        ///start by clearning the previous amountTotal and Quantity as it is confusing some time!
        model.clearPreviousSaleCounts();
        model.toggleCheckbox(variantId: -1);
        await model.getVariants(productId: product.id);
      },
      viewModelBuilder: () => BusinessHomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            onPop: () {
              GoRouter.of(context).pop();
            },
            title: titleWidget(
              model: model,
              name: product.name,
            ),
            rightActionButtonName: 'Save',
            disableButton: false,
            showActionButton: true,
            onPressedCallback: () async {
              log.w(model.checked);
              bool saved = await model.saveOrder(
                variationId: model.checked,
                amountTotal: model.amountTotal,
                customItem: false,
              );
              if (!saved) {
                showSimpleNotification(const Text('No item selected'),
                    background: Colors.red);
              }
              GoRouter.of(context).pop();
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
                            product.name,
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[800]),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '  CHOOSE ONE',
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  fontSize: 11.0, color: Colors.grey[700]),
                            ),
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
