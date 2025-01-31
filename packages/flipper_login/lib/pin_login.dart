import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';

class PinLogin extends StatefulWidget {
  PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> with CoreMiscellaneous {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  bool _isProcessing = false;
  bool _isObscure = true;

  // Method to handle PIN login and its associated flow
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
      });

      try {
        await ProxyService.box.writeBool(key: 'pinLogin', value: true);

        final pin = await _getPin();
        if (pin == null) throw PinError(term: "Not found");

        // Update local authentication
        await ProxyService.box.writeBool(key: 'isAnonymous', value: true);

        final thePin = Pin(
          userId: int.tryParse(pin.userId),
          pin: int.tryParse(pin.userId),
          branchId: pin.branchId,
          businessId: pin.businessId,
          ownerName: pin.ownerName,
          tokenUid: pin.tokenUid,
          phoneNumber: pin.phoneNumber,
        );

        await ProxyService.strategy.login(
          pin: thePin,
          flipperHttpClient: ProxyService.http,
          skipDefaultAppSetup: false,
          userPhone: pin.phoneNumber,
        );

        await _completeLogin(thePin);
      } catch (e, s) {
        await _handleLoginError(e, s);
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Get PIN from local service
  Future<IPin?> _getPin() async {
    return await ProxyService.strategy.getPin(
      pinString: _pinController.text,
      flipperHttpClient: ProxyService.http,
    );
  }

  // Handle the login completion flow (redirect after login)
  Future<void> _completeLogin(Pin thePin) async {
    try {
      await ProxyService.strategy.savePin(pin: thePin);
      await loc.getIt<AppService>().appInit();
      final defaultApp = ProxyService.box.getDefaultApp();

      if (defaultApp == "2") {
        final routerService = locator<RouterService>();
        routerService.navigateTo(SocialHomeViewRoute());
      } else {
        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } catch (e) {
      print(e); // Log or handle error during login completion
      rethrow;
    }
  }

  // Error handling for login
  Future<void> _handleLoginError(dynamic e, StackTrace s) async {
    String errorMessage = '';
    if (e is BusinessNotFoundException) {
      errorMessage = e.errMsg();
    } else if (e is PinError) {
      errorMessage = e.errMsg();
    } else if (e is LoginChoicesException) {
      locator<RouterService>().navigateTo(LoginChoicesRoute());
      return;
    } else {
      errorMessage = e.toString();
      await Sentry.captureException(e, stackTrace: s);
    }
    print(s);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 250,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 30),
        content: Text(errorMessage, style: primaryTextStyle),
      ),
    );
  }

  // Toggles the PIN visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            key: Key('PinLogin'),
            body: Stack(
              children: [
                SizedBox(width: 85, child: back.BackButton()),
                Center(
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 100.0, 8.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPinField(),
                            const SizedBox(height: 16.0),
                            _buildLoginButton(model),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builds the PIN input field
  Widget _buildPinField() {
    return TextFormField(
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelStyle: primaryTextStyle,
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: _togglePasswordVisibility,
        ),
        enabled: true,
        border: const OutlineInputBorder(),
        labelText: "Enter your PIN",
      ),
      controller: _pinController,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return "PIN is required";
        }
        return null;
      },
    );
  }

  // Builds the login button
  Widget _buildLoginButton(LoginViewModel model) {
    return Container(
      color: Colors.white70,
      width: double.infinity,
      height: 40,
      child: !_isProcessing
          ? BoxButton(
              key: Key("pinLoginButton_desktop"),
              borderRadius: 2,
              onTap: _handleLogin,
              title: 'Log in',
              busy: _isProcessing,
            )
          : const Padding(
              key: Key('busyButton'),
              padding: EdgeInsets.only(left: 0, right: 0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: BoxButton(
                  title: 'Log in',
                  busy: true,
                ),
              ),
            ),
    );
  }
}
