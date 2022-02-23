import 'package:flipper_models/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'signup_form_view.form.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_ui/flipper_ui.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_ui/google_ui.dart';

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
  TextFieldBloc countryName = TextFieldBloc(
    initialValue: 'Kenya',
  );
  final SignupViewModel signupViewModel;

  AsyncFieldValidationFormBloc(
      {required this.signupViewModel, required String country}) {
    countryName.updateInitialValue(country);
    addFieldBlocs(fieldBlocs: [username, fullName, countryName]);

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
    int status = await ProxyService.api.userNameAvailable(name: username);

    if (status == 200) {
      return 'That username is already taken';
    }

    return null;
  }

  @override
  void onSubmitting() async {
    try {
      showSimpleNotification(
        const Text("Signup in progress"),
        background: Colors.green,
      );
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      signupViewModel.setName(name: username.value);
      signupViewModel.setFullName(name: fullName.value);
      signupViewModel.setCountry(country: countryName.value);
      signupViewModel.signup();
      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

@FormView(fields: [
  FormTextField(name: 'name'),
  FormTextField(name: 'type'),
])
class SignUpFormView extends StatelessWidget with $SignUpFormView {
  SignUpFormView({Key? key, required this.countryNm}) : super(key: key);
  final String countryNm;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
      onModelReady: (model) {
        model.context = context;
        listenToFormUpdated(model);
        model.registerLocation();
      },
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) {
        /// for debugging purpose add this here to refer to when debugging in prod
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          if (kDebugMode) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(minutes: 1),
              content: Text(ProxyService.box.getUserId() ?? ''),
            ));
          }
        });
        return BlocProvider(
          create: (context) => AsyncFieldValidationFormBloc(
              signupViewModel: model, country: countryNm),
          child: Builder(builder: (context) {
            final formBloc = context.read<AsyncFieldValidationFormBloc>();
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(0.0).copyWith(top: 80, bottom: 0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        const Text('Welcome to flipper, please signup.'),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 20.0),
                          child: TextFieldBlocBuilder(
                            // decoration: InputDecoration(hintText: 'Name'),
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
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 0.0),
                          child: TextFieldBlocBuilder(
                            // decoration: InputDecoration(hintText: 'Name'),
                            textFieldBloc: formBloc.fullName,
                            suffixButton: SuffixButton.asyncValidating,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'First name, Last name',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 0.0),
                          child: TextFieldBlocBuilder(
                            readOnly: true,
                            textFieldBloc: formBloc.countryName,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'country',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const Text('How do you want to use flipper?'),
                        DropdownButtonFormField<String>(
                          value: model.businessType,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String? style) {
                            model.setBuinessType(type: style!);
                          },
                          items: <String>['Social', 'Business']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                        !model.registerStart
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: GElevatedButton(
                                    'Register',
                                    onPressed: formBloc.submit,
                                  ),
                                ),
                              )
                            : const Padding(
                                key: Key('busyButon'),
                                padding: EdgeInsets.only(left: 0, right: 0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: BoxButton(
                                    title: 'SIGN IN',
                                    busy: true,
                                  ),
                                ),
                              )
                      ],
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
