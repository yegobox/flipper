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
import 'package:realm/realm.dart';
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
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _pin = TextEditingController();
  bool isProcessing = false;
  bool _isObscure = true;

  Future<void> completeLogin(Pin thePin) async {
    try {
      await ProxyService.local.savePin(pin: thePin);
      await loc.getIt<AppService>().appInit();

      // Attempt to sign in with the custom token

      final defaultApp = ProxyService.box.getDefaultApp();

      if (defaultApp == "2") {
        final _routerService = locator<RouterService>();
        _routerService.navigateTo(SocialHomeViewRoute());
      } else {
        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } catch (e) {
      print(e);
      rethrow;
    }
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
                    key: _form,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 100.0, 8.0, 0.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      labelStyle: primaryTextStyle,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
                                      enabled: true,
                                      border: const OutlineInputBorder(),
                                      labelText: "Enter your PIN"),
                                  controller: _pin,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "PIN is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                Container(
                                  color: Colors.white70,
                                  width: double.infinity,
                                  height: 40,
                                  child: !model.isProcessing
                                      ? BoxButton(
                                          key: const Key(
                                              "pinLoginButton_desktop"),
                                          borderRadius: 2,
                                          onTap: () async {
                                            if (_form.currentState!
                                                .validate()) {
                                              try {
                                                try {
                                                  setState(() {
                                                    isProcessing = true;
                                                  });
                                                  await ProxyService.box
                                                      .writeBool(
                                                          key: 'pinLogin',
                                                          value: true);

                                                  IPin? pin = await ProxyService
                                                      .local
                                                      .getPin(
                                                          pinString: _pin.text,
                                                          flipperHttpClient:
                                                              ProxyService
                                                                  .http);
                                                  if (pin == null) {
                                                    throw PinError(
                                                        term: "Not found");
                                                  }

                                                  ProxyService.box.writeBool(
                                                      key: 'isAnonymous',
                                                      value: true);

                                                  // Sign out from Firebase before attempting to log in
                                                  // await FirebaseAuth.instance.signOut();
                                                  final thePin = Pin(ObjectId(),
                                                      userId: int.tryParse(
                                                          pin.userId),
                                                      pin: int.tryParse(
                                                          pin.userId),
                                                      id: int.tryParse(
                                                          pin.userId),
                                                      branchId: pin.branchId,
                                                      businessId:
                                                          pin.businessId,
                                                      ownerName: pin.ownerName,
                                                      tokenUid: pin.tokenUid,
                                                      phoneNumber:
                                                          pin.phoneNumber);
                                                  // Perform user login with ProxyService
                                                  await ProxyService.local
                                                      .login(
                                                    pin: thePin,
                                                    flipperHttpClient:
                                                        ProxyService.http,
                                                    skipDefaultAppSetup: false,
                                                    userPhone: pin.phoneNumber,
                                                  );

                                                  ///save or update the pin, we might get the pin from remote then we need to update the local or create new one
                                                  await completeLogin(thePin);
                                                } on LoginChoicesException {
                                                  locator<RouterService>()
                                                      .navigateTo(
                                                          LoginChoicesRoute());
                                                } catch (error, s) {
                                                  setState(() {
                                                    isProcessing = false;
                                                  });
                                                  await Sentry.captureException(
                                                      error,
                                                      stackTrace: s);
                                                  rethrow;
                                                } finally {
                                                  setState(() {
                                                    isProcessing = false;
                                                  });
                                                }
                                              } catch (e) {
                                                if (e
                                                    is BusinessNotFoundException) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 250,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        e.errMsg(),
                                                        style: primaryTextStyle,
                                                      ),
                                                    ),
                                                  );
                                                } else if (e is PinError) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 250,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(e.errMsg()),
                                                    ),
                                                  );
                                                } else {
                                                  e as UnknownError;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 250,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(e.errMsg()),
                                                    ),
                                                  );
                                                }
                                                setState(() {
                                                  isProcessing = false;
                                                });
                                              }
                                            }
                                          },
                                          title: 'Log in',
                                          busy: isProcessing,
                                        )
                                      : const Padding(
                                          key: Key('busyButton'),
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: BoxButton(
                                              title: 'Log in',
                                              busy: true,
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
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
}
