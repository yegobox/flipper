import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helperModels/paystack_customer.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
// Test..(1)

class PaymentPlanUI extends StatefulWidget {
  @override
  _PaymentPlanUIState createState() => _PaymentPlanUIState();
}

class _PaymentPlanUIState extends State<PaymentPlanUI> {
  String _selectedPlan = 'Mobile';
  int _additionalDevices = 0;
  bool _isYearlyPlan = false;
  double _totalPrice = 5000;

  void _calculatePrice() {
    setState(() {
      double basePrice;
      switch (_selectedPlan) {
        case 'Mobile':
          basePrice = 5000;
          break;
        case 'Mobile + Desktop':
          basePrice = 30000;
          break;
        case '3 Devices':
          basePrice = 120000;
          break;
        case 'More than 3 Devices':
          basePrice = 120000 + (_additionalDevices * 15000);
          break;
        default:
          basePrice = 5000;
      }

      if (_isYearlyPlan) {
        _totalPrice = basePrice * 12 * 0.8; // 20% discount for yearly plan
      } else {
        _totalPrice = basePrice;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment Plan'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select the plan that works for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildDurationToggle(),
              SizedBox(height: 16),
              _buildPlanCards(),
              SizedBox(height: 16),
              if (_selectedPlan == 'More than 3 Devices')
                _buildAdditionalDevicesInput(),
              SizedBox(height: 16),
              _buildPriceSummary(),
              SizedBox(height: 16),
              CouponToggle(
                
              ),
              SizedBox(height: 16),
              _buildProceedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isYearlyPlan = false;
                  _calculatePrice();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isYearlyPlan ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isYearlyPlan ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isYearlyPlan = true;
                  _calculatePrice();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isYearlyPlan ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Yearly (20% off)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isYearlyPlan ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCards() {
    return Column(
      children: [
        _buildPlanCard(
            'Mobile',
            'Mobile only',
            _isYearlyPlan ? '48,000 RWF/year' : '5,000 RWF/month',
            Icons.phone_iphone),
        SizedBox(height: 8),
        _buildPlanCard(
            'Mobile + Desktop',
            'Mobile + Desktop',
            _isYearlyPlan ? '288,000 RWF/year' : '30,000 RWF/month',
            Icons.devices),
        SizedBox(height: 8),
        _buildPlanCard(
            '3 Devices',
            '3 Devices',
            _isYearlyPlan ? '1,152,000 RWF/year' : '120,000 RWF/month',
            Icons.device_hub),
        SizedBox(height: 8),
        _buildPlanCard(
            'More than 3 Devices',
            'Custom',
            _isYearlyPlan ? '1,152,000+ RWF/year' : '120,000+ RWF/month',
            Icons.devices),
      ],
    );
  }

  Widget _buildPlanCard(
      String value, String title, String price, IconData icon) {
    bool isSelected = _selectedPlan == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = value;
          _additionalDevices = 0;
          _calculatePrice();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon,
                  size: 24, color: isSelected ? Colors.white : Colors.black),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black)),
                    SizedBox(height: 4),
                    Text(price,
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                isSelected ? Colors.white70 : Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalDevicesInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Additional devices',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Row(
            children: [
              _buildCircularButton(
                  Icons.remove,
                  _additionalDevices > 0
                      ? () {
                          setState(() {
                            _additionalDevices--;
                            _calculatePrice();
                          });
                        }
                      : null),
              SizedBox(width: 16),
              Text(_additionalDevices.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 16),
              _buildCircularButton(Icons.add, () {
                setState(() {
                  _additionalDevices++;
                  _calculatePrice();
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed != null ? Colors.black : Colors.grey.shade300,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(
            '${_totalPrice.toStringAsFixed(0)} RWF${_isYearlyPlan ? '/year' : '/month'}',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    return ElevatedButton(
      onPressed: () async {
        String selectedPlan = _selectedPlan;
        int additionalDevices =
            _selectedPlan == 'More than 3 Devices' ? _additionalDevices : 0;
        bool isYearlyPlan = _isYearlyPlan;
        double totalPrice = _totalPrice;

        try {
          String userIdentifier = ProxyService.box.getUserPhone()!;

          PayStackCustomer customer = await ProxyService.payStack
              .getPayStackCustomer(
                  business: ProxyService.local.getBusiness(),
                  userIdentifier.toFlipperEmail(),
                  ProxyService.http);

          ProxyService.realm.saveOrUpdatePaymentPlan(
              businessId: ProxyService.box.getBusinessId()!,
              selectedPlan: selectedPlan,
              paymentMethod:
                  "Card", // set card as preferred, can be changed on finalization stage
              flipperHttpClient: ProxyService.http,
              additionalDevices: additionalDevices,
              isYearlyPlan: isYearlyPlan,
              payStackUserId: customer.data.id,
              totalPrice: totalPrice);
          locator<RouterService>().navigateTo(PaymentFinalizeRoute());
        } catch (e, s) {
          talker.warning(e);
          talker.error(s);
          rethrow;
        }
        // Proceed to payment action
      },
      child: Text('Proceed to Payment',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }
}
