import 'package:flipper_models/view_models/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'signup_form_view.form.dart';
import 'package:flipper_dashboard/customappbar.dart';

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
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              // ProxyService.nav.back();
            },
            title: '',
            showActionButton: false,
            onPressedCallback: () async {},
            multi: 3,
            bottomSpacer: 50,
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('Welcome to flipper, please signup.'),
                Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Name'),
                    controller: nameController,
                    onChanged: (name) {
                      model.setName(name: name);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        Locale locale = Localizations.localeOf(context);
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Processing Data',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                        model.signup(locale: locale);
                      }
                    },
                    child: Text('Register'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
