import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    ? Center(child: CircularProgressIndicator(
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

    print(selectedCountry);
    print(selectedPaymentMethod);
    if (selectedPaymentMethod == "Card") {
      String _url = await ProxyService.realm.subscribe(
          businessId: ProxyService.box.getBusinessId()!,

          /// TODO: implement agent model later.
          agentCode: 1,
          flipperHttpClient: ProxyService.http);
      setState(() {
        isLoading = false;
      });
      if (!await launchUrl(Uri.parse(_url))) {
        throw Exception('Could not launch $_url');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      toast("Mobile Money payment coming soon, choose card payment");
    }
  }
}
