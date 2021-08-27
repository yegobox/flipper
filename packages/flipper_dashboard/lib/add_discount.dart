import 'package:flipper_dashboard/create/build_image_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/discount_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_services/proxy.dart';

class AddDiscount extends StatefulWidget {
  AddDiscount({Key? key}) : super(key: key);

  @override
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<AddDiscount> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ViewModelBuilder<DiscountViewModel>.reactive(
          builder: (context, model, child) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                previousPageTitle: 'Back',
                trailing: SizedBox(
                  width: 80,
                  height: 40,
                  child: BoxButton(
                    borderRadius: 2,
                    title: 'Save',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved discount')),
                        );
                        await model.save(
                          name: nameController.text,
                          amount: double.parse(amountController.text),
                        );
                        ProxyService.nav.back();
                      }
                    },
                  ),
                ),
                middle: Text('Create Discount'),
              ),
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ColorAndImagePlaceHolder(
                          currentColor: '#ee5253',
                          product: null,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BoxInputField(
                            validatorFunc: (text) {
                              if (text.length > 0) {
                                return null;
                              }
                              return 'Name can not be null';
                            },
                            enabled: true,
                            controller: nameController,
                            placeholder: 'Name',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BoxInputField(
                            enabled: true,
                            validatorFunc: (text) {
                              if (text.length > 0) {
                                return null;
                              }
                              return 'Amount can not be null';
                            },
                            controller: amountController,
                            placeholder: 'RWF',
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          viewModelBuilder: () => DiscountViewModel()),
    );
  }
}
