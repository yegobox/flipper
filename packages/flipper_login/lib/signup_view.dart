import 'dart:developer';
import 'dart:convert';
import 'package:flipper_models/isar/business_type.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';

class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final fullName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final tinNumber = TextFieldBloc();

  final SignupViewModel signupViewModel;
  final countryName = SelectFieldBloc<String, String>(
    items: ['Zambia', 'Mozambique', 'Rwanda'],
    initialValue: 'Rwanda',
  );
  //// {"id": "2", "typeName": "Flipper Connecta"},
  final businessTypes = SelectFieldBloc<BusinessType, Object>(
      name: 'businessType',
      items: BusinessType.fromJsonList(jsonEncode([
        {"id": "1", "typeName": "Flipper Retailer"},
      ])),
      validators: [
        FieldBlocValidators.required,
      ]);
  AsyncFieldValidationFormBloc(
      {required this.signupViewModel, required String country}) {
    countryName.updateInitialValue(country);
    ProxyService.realm.businessTypes().then((data) {
      // Update the items of the SelectFieldBloc
      log(data.toString(), name: 'AsyncFieldValidationFormBloc');
      // remove Flipper Connecta from data
      businessTypes.updateItems(data);
    }).catchError((error) {
      // Handle the error
      log(error, name: 'AsyncFieldValidationFormBloc');
    });

    addFieldBlocs(fieldBlocs: [
      username,
      fullName,
      countryName,
      tinNumber,
      businessTypes
    ]);

    username.addAsyncValidators(
      [_checkUsername],
    );
  }

  static String? _min4Char(String? username) {
    if (username!.length > 11) {
      return 'Name is too long';
    }
    return null;
  }

  Future<String?> _checkUsername(String? username) async {
    if (username == null) {
      return "Username/business name is required";
    }
    int status = await ProxyService.realm.userNameAvailable(name: username);

    if (status == 200) {
      return 'That username is already taken';
    }

    return null;
  }

  @override
  void onSubmitting() async {
    try {
      showSimpleNotification(const Text("Signup in progress"),
          background: Colors.green, position: NotificationPosition.bottom);
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      signupViewModel.setName(name: username.value);
      signupViewModel.setFullName(name: fullName.value);
      signupViewModel.setCountry(country: countryName.value);
      signupViewModel.tin = tinNumber.value.isEmpty ? "11111" : tinNumber.value;
      signupViewModel.businessType = businessTypes.value!;
      signupViewModel.signup();
      emitSuccess();
    } catch (e) {
      showSimpleNotification(
          const Text("Error while signing up try again later"),
          background: Colors.red,
          duration: Duration(seconds: 10),
          position: NotificationPosition.bottom);
      emitFailure();
    }
  }
}

class SignUpView extends StatefulWidget {
  SignUpView({Key? key, this.countryNm = "Rwanda"}) : super(key: key);
  final String? countryNm;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _showTinField = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.nonReactive(
      onViewModelReady: (model) {
        model.context = context;
        model.registerLocation();
      },
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) {
        return BlocProvider(
          create: (context) => AsyncFieldValidationFormBloc(
              signupViewModel: model, country: widget.countryNm ?? "Rwanda"),
          child: Builder(builder: (context) {
            final formBloc = context.read<AsyncFieldValidationFormBloc>();
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(0.0).copyWith(top: 80, bottom: 0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          Text('Welcome to flipper, please signup.',
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 20.0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.username,
                              suffixButton: SuffixButton.asyncValidating,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.fullName,
                              suffixButton: SuffixButton.asyncValidating,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'First name, Last name',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.zero,
                            child: DropdownFieldBlocBuilder<BusinessType>(
                              showEmptyItem: false,
                              padding: EdgeInsets.zero,
                              isExpanded: false,
                              selectFieldBloc: formBloc.businessTypes,
                              itemBuilder: (context, value) => FieldItem(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  value.typeName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Apps',
                                prefixIcon: Icon(Icons.business),
                              ),
                              onChanged: (value) {
                                if (value != null && value.id != "2") {
                                  log('setting choosen business type',
                                      name: 'onChanged');
                                  setState(() {
                                    _showTinField = true;
                                  });
                                } else {
                                  setState(() {
                                    _showTinField = false;
                                  });
                                }
                              },
                            ),
                          ),
                          _showTinField
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 0.0),
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: formBloc.tinNumber,
                                    suffixButton: SuffixButton.asyncValidating,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Tin number',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: DropdownFieldBlocBuilder<String>(
                              showEmptyItem: false,
                              padding: EdgeInsets.zero,
                              selectFieldBloc: formBloc.countryName,
                              decoration: InputDecoration(
                                labelText: 'Country',
                                // border: OutlineInputBorder(),
                              ),
                              itemBuilder: (context, value) => FieldItem(
                                child: Text(value,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ),
                          !model.registerStart
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 20),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton(
                                      child: Text('Register',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          )),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                          (states) => RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xff006AFE)),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered)) {
                                              return Colors.blue
                                                  .withOpacity(0.04);
                                            }
                                            if (states.contains(
                                                    MaterialState.focused) ||
                                                states.contains(
                                                    MaterialState.pressed)) {
                                              return Colors.blue
                                                  .withOpacity(0.12);
                                            }
                                            return null; // Defer to the widget's default.
                                          },
                                        ),
                                      ),
                                      onPressed: formBloc.submit,
                                    ),
                                  ),
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
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
