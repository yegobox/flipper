import 'package:flipper_models/view_models/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'signup_form_view.form.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';

class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );
  final SignupViewModel signupViewModel;

  AsyncFieldValidationFormBloc({required this.signupViewModel}) {
    addFieldBlocs(fieldBlocs: [username]);

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
        Text("Signup in progress"),
        background: Colors.green,
      );
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      signupViewModel.setName(name: username.value!);
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
  SignUpFormView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
      onModelReady: (model) {
        listenToFormUpdated(model);
        model.registerLocation();
      },
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) {
        return BlocProvider(
          create: (context) =>
              AsyncFieldValidationFormBloc(signupViewModel: model),
          child: Builder(builder: (context) {
            final formBloc = context.read<AsyncFieldValidationFormBloc>();
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10.0)
                    .copyWith(top: ScreenUtil().setHeight(80), bottom: 0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                    ),
                    child: Column(
                      children: [
                        Text('Welcome to flipper, please signup.'),
                        Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: TextFieldBlocBuilder(
                            // decoration: InputDecoration(hintText: 'Name'),
                            textFieldBloc: formBloc.username,
                            suffixButton: SuffixButton.asyncValidating,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        Text('How do you want to use flipper?'),
                        DropdownButton<String>(
                          value: model.businessType,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? style) {
                            model.setBuinessType(type: style!);
                          },
                          items: <String>['business', 'social']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        !model.registerStart
                            ? Padding(
                                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                child: BoxButton(
                                  onTap: formBloc.submit,
                                  title: 'Register',
                                ),
                              )
                            : Padding(
                                key: Key('busyButon'),
                                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 60,
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
