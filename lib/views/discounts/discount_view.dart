import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flipper_models/view_models/discount_view_model.dart';
import 'package:flipper/routes/router.gr.dart';

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
                leading: IconButton(
                  icon: const Icon(
                    FontAwesome.close,
                    size: 18.0,
                  ),
                  onPressed: () {
                    model.navigateTo(path: Routing.listDiscountView);
                  },
                ),
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
                                color: Colors.grey[500],
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 0.0, 0.0, 0.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              model.discountAmount.toString(),
                                              style: GoogleFonts.nunito(
                                                textStyle: TextStyle(
                                                    color: Colors.grey[200]),
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(model.toggle,
                                              style: GoogleFonts.nunito(
                                                textStyle: TextStyle(
                                                    color: Colors.grey[200]),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 90.0),
                                width: double.infinity,
                                height: 20,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[600])),
                                child: Column(children: [
                                  Expanded(child: Text(model.content)),
                                  // ValueListenableBuilder(valueListenable: null, builder: null)
                                ]),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(color: Colors.grey[600]),
                                  onChanged: (text) {
                                    model.discountMethod(value: text);
                                    // print('text  $text');
                                  },
                                  controller: model.discountname,
                                  decoration: const InputDecoration(
                                      hintText: 'Discount Name'),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                            controller: model.discount,
                                            onChanged: (text) {
                                              model.discountName(
                                                  discount: text);
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                fillColor: Colors.grey[700],
                                                hintText: model.toggle),
                                          ),
                                        )),
                                    Expanded(
                                      child: SlidingSwitch(
                                        value: false,
                                        width: 100,
                                        onChanged: (bool value) {
                                          if (value) {
                                            model.checkToggle(value: 'Frw');
                                          } else {
                                            model.checkToggle(value: '%');
                                          }
                                          print(value);
                                        },
                                        height: 40,
                                        animationDuration:
                                            const Duration(milliseconds: 400),
                                        onTap: () {},
                                        onDoubleTap: () {},
                                        onSwipe: () {},
                                        textOff: '%',
                                        textOn: 'FRw',
                                        colorOn: Colors.grey[300],
                                        colorOff: Colors.grey[700],
                                        background: const Color(0xffe4e5eb),
                                        buttonColor: Colors.blue[400],
                                        inactiveColor: Colors.grey[300],
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  child: Text(
                                      'Leave the discount amount blank to enter at the time of sale. \n Discounts are applied to the ticket before tax is calculated',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14.0),
                                      )),
                                )
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
