import 'dart:async';

import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentFinalize extends StatefulWidget {
  @override
  _PaymentFinalizeState createState() => _PaymentFinalizeState();
}

class _PaymentFinalizeState extends State<PaymentFinalize> {
  String selectedCountry = 'Other';
  String selectedPaymentMethod = 'Card';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finalize Payment'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(200.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Country',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Rwanda', label: Text('Rwanda')),
                    ButtonSegment(value: 'Other', label: Text('Other')),
                  ],
                  selected: {selectedCountry},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      selectedCountry = newSelection.first;
                      if (selectedCountry == 'Other') {
                        selectedPaymentMethod = 'Card';
                      }
                    });
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: selectedCountry == 'Rwanda'
                      ? const [
                          ButtonSegment(
                              value: 'Mobile Money',
                              label: Text('Mobile Money')),
                          ButtonSegment(value: 'Card', label: Text('Card')),
                        ]
                      : const [
                          ButtonSegment(value: 'Card', label: Text('Card')),
                        ],
                  selected: {selectedPaymentMethod},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      selectedPaymentMethod = newSelection.first;
                    });
                  },
                ),
                Spacer(),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black.withOpacity(0.7)),
                        strokeWidth: 3,
                        backgroundColor: Colors.grey.shade300,
                      ))
                    : ElevatedButton(
                        child: Text('Complete Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _handlePayment,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePayment() async {
    setState(() {
      isLoading = true;
    });

    /// TODO: implement agent model later.
    print(selectedCountry);
    print(selectedPaymentMethod);
    PaymentPlan paymentPlan = ProxyService.realm
        .getPaymentPlan(businessId: ProxyService.box.getBusinessId()!)!;

    int finalPrice = 0;
    //findout if there is ongoing compaign to apply discount
    FlipperSaleCompaign? compaign = ProxyService.realm.getLatestCompaign();
    if (compaign != null) {
      finalPrice = (paymentPlan.totalPrice! -
              ((paymentPlan.totalPrice! * compaign.discountRate!) / 100))
          .toInt();
    } else {
      finalPrice = paymentPlan.totalPrice!.toInt();
    }

    if (selectedPaymentMethod == "Card") {
      final (:url, :userId) = await ProxyService.realm.subscribe(
        businessId: ProxyService.box.getBusinessId()!,
        agentCode: 1,
        flipperHttpClient: ProxyService.http,
        amount: finalPrice,
      );

      await ProxyService.realm.saveOrUpdatePaymentPlan(
          businessId: paymentPlan.businessId!,
          selectedPlan: paymentPlan.selectedPlan!,
          paymentMethod: selectedPaymentMethod,
          additionalDevices: paymentPlan.additionalDevices!,
          isYearlyPlan: paymentPlan.isYearlyPlan!,
          totalPrice: paymentPlan.totalPrice!,
          flipperHttpClient: ProxyService.http,
          payStackUserId: userId);
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
      bool keepLoop = true;
      do {
        /// force instant update from remote db
        await ProxyService.realm.realm?.subscriptions.waitForSynchronization();
        PaymentPlan? plan = ProxyService.realm
            .getPaymentPlan(businessId: paymentPlan.businessId!);
        if (plan != null && plan.paymentCompletedByUser!) {
          talker.warning("A user has Completed payment");
          keepLoop = false;
          setState(() {
            isLoading = false;
          });
          locator<RouterService>().navigateTo(FlipperAppRoute());
        }
      } while (keepLoop);

      /// listen on stream to check if payment has been completed by a user
    } else {
      setState(() {
        isLoading = false;
      });
      toast("Mobile Money payment coming soon, choose card payment");
    }
  }
}
