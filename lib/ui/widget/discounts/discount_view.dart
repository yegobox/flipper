import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import './discount_view_model.dart';

class DiscountView extends StatelessWidget {
  const DiscountView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, DiscountViewModel model, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'Create Discount', // title
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.grey[800]),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [
                  RaisedButton(
                    onPressed: null,
                    elevation: 0.0,
                    color: Theme.of(context)
                        .copyWith(canvasColor: Colors.blue[400])
                        .canvasColor,
                    child: Text('Save',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white)),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ],
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 30.0, 18.0, 2.0),
                    child: Column(
                      children: [
                        // Container with new/ and discount
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 90.0),
                                width: double.infinity,
                                height: 80,
                                color: Colors.grey[700],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 90.0),
                                width: double.infinity,
                                height: 20,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[600])),
                                child: Text(model.content),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Discount Name'),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: TextFormField(
                                            initialValue: '%',
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => DiscountViewModel());
  }
}
