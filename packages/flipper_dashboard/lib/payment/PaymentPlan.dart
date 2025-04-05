import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentPlanUI extends StatefulWidget {
  const PaymentPlanUI({Key? key}) : super(key: key);

  @override
  _PaymentPlanUIState createState() => _PaymentPlanUIState();
}

class _PaymentPlanUIState extends State<PaymentPlanUI> {
  String _selectedPlan = 'Mobile';
  int _additionalDevices = 0;
  bool _isYearlyPlan = false;
  double _totalPrice = 5000;
  List<String> _additionalServices = [];
  bool _isCheckingPayment = false;

  // Add toggles for additional services
  bool _extraSupport = false;
  bool _taxReporting = false;
  bool _unlimitedBranches = false;
  final paymentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Always check for active payment when this screen is opened
    // This ensures we return to the app if payment is already active
    _checkForActivePayment();
  }

  /// Checks if there's an active payment plan and navigates back to the app if found
  Future<void> _checkForActivePayment() async {
    if (_isCheckingPayment) return;

    setState(() {
      _isCheckingPayment = true;
    });

    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId != null) {
        // Check if there's an active payment plan
        await ProxyService.strategy.hasActiveSubscription(
          businessId: businessId,
          flipperHttpClient: ProxyService.http,
          fetchRemote: true,
        );

        // If we get here without an exception, there's an active plan
        talker.info('Active payment plan found, returning to app');
        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } catch (e) {
      // If there's an exception, we need to stay on this screen
      talker.warning('No active payment plan found: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingPayment = false;
        });
      }
    }
  }

  void _calculatePrice() {
    setState(() {
      double basePrice;
      switch (_selectedPlan) {
        case 'Mobile':
          basePrice = 5000;
          if (_taxReporting) basePrice += 30000;
          break;
        case 'Mobile + Desktop':
          basePrice = 120000;
          if (_taxReporting) basePrice += 30000;
          break;

        case 'Entreprise':
          basePrice = 1500000;
          // Add costs for premium additional services
          if (_extraSupport) basePrice += 800000;
          if (_taxReporting)
            basePrice += 400000; // Premium tax consulting for enterprise
          if (_unlimitedBranches) basePrice += 600000;
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
                  color: !_isYearlyPlan ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isYearlyPlan ? Colors.white : Colors.blue,
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
                  color: _isYearlyPlan ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Yearly (20% off)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isYearlyPlan ? Colors.white : Colors.blue,
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
            _isYearlyPlan ? '1,152000 RWF/year' : '120,000 RWF/month',
            Icons.devices),
        SizedBox(height: 8),
        _buildPlanCard(
            'Entreprise',
            'Entreprise',
            _isYearlyPlan ? '14,400,000+ RWF/year' : '1,500,000+ RWF/month',
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
          // Reset additional services when changing plans
          _extraSupport = false;
          _taxReporting = false;
          _unlimitedBranches = false;
          _calculatePrice();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon,
                  size: 24, color: isSelected ? Colors.white : Colors.blue),
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
                            color: isSelected ? Colors.white70 : Colors.black)),
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
          color: onPressed != null ? Colors.blue : Colors.grey.shade300,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildAdditionalServices() {
    if (_selectedPlan == 'Entreprise') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enterprise Services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildServiceToggle(
            'Extra Support',
            '800,000 RWF${_isYearlyPlan ? '/year' : '/month'}',
            _extraSupport,
            (value) {
              if (value && !_additionalServices.contains("Extra Support")) {
                _additionalServices.add("Extra Support");
              }

              setState(() {
                _extraSupport = value;
                _calculatePrice();
              });
            },
          ),
          SizedBox(height: 8),
          _buildServiceToggle(
            'Premium Tax Reporting Consulting',
            '400,000 RWF${_isYearlyPlan ? '/year' : '/month'}',
            _taxReporting,
            (value) {
              if (value &&
                  !_additionalServices
                      .contains("Premium Tax Reporting Consulting")) {
                _additionalServices.add("Premium Tax Reporting Consulting");
              }
              setState(() {
                _taxReporting = value;
                _calculatePrice();
              });
            },
          ),
          SizedBox(height: 8),
          _buildServiceToggle(
            'Unlimited Branches & Agents',
            '600,000 RWF${_isYearlyPlan ? '/year' : '/month'}',
            _unlimitedBranches,
            (value) {
              if (value &&
                  !_additionalServices
                      .contains("Unlimited Branches & Agents")) {
                _additionalServices.add("Unlimited Branches & Agents");
              }
              setState(() {
                _unlimitedBranches = value;
                _calculatePrice();
              });
            },
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildServiceToggle(
            'Tax Reporting Consulting',
            '30,000 RWF${_isYearlyPlan ? '/year' : '/month'}',
            _taxReporting,
            (value) {
              setState(() {
                _taxReporting = value;
                _calculatePrice();
              });
            },
          ),
        ],
      );
    }
  }

  Widget _buildServiceToggle(
      String title, String price, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blue;
              }
              return Colors.grey;
            }),
          ),
        ],
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
            '${_totalPrice.toRwf()} ${_isYearlyPlan ? '/year' : '/month'}',
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
          // String userIdentifier = ProxyService.box.getUserPhone()!;

          // PayStackCustomer customer = await ProxyService.payStack
          //     .getPayStackCustomer(
          //         business: (await ProxyService.strategy.getBusiness(
          //             businessId: ProxyService.box.getBusinessId()!))!,
          //         userIdentifier.toFlipperEmail(),
          //         ProxyService.http);

          ProxyService.strategy.saveOrUpdatePaymentPlan(
              businessId: ProxyService.box.getBusinessId()!,
              selectedPlan: selectedPlan,
              addons: _additionalServices,
              paymentMethod: "Card",
              numberOfPayments: int.tryParse(paymentController.text) ?? 1,
              flipperHttpClient: ProxyService.http,
              additionalDevices: additionalDevices,
              isYearlyPlan: isYearlyPlan,
              // payStackUserId: customer.data.id,
              // payStackUserId: "1",
              totalPrice:
                  totalPrice * (int.tryParse(paymentController.text) ?? 1));
          locator<RouterService>().navigateTo(PaymentFinalizeRoute());
        } catch (e, s) {
          talker.warning(e);
          talker.error(s);
          rethrow;
        }
      },
      child: Text('Proceed to Payment',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        splashFactory: InkSparkle.splashFactory,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment Plan'),
        backgroundColor: Colors.blue,
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
              _buildAdditionalServices(),
              SizedBox(height: 16),
              _buildPriceSummary(),
              SizedBox(height: 16),
              CouponToggle(),
              NumberOfPaymentsToggle(
                paymentController: paymentController,
              ),
              SizedBox(height: 16),
              _buildProceedButton(),
            ],
          ),
        ),
      ),
    );
  }
}
