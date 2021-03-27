import 'package:flipper_models/view_models/discount_list_view_model.dart';
import 'package:flipper/widget/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ListDiscountView extends StatelessWidget {
  const ListDiscountView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, ListDiscountViewModel model, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'List of Discounts', // title
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.grey[800]),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [],
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        // Add navabr
                        const SearchView(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600])),
                          child: RaisedButton(
                            child: const Text(' Create Discount '),
                            onPressed: () {},
                            color: Colors.grey[200],
                            textColor: Colors.blue[600],
                            splashColor: Colors.grey,
                            padding: const EdgeInsets.all(15.0),
                          ),
                        ),
                        //
                        discountWidget(
                            name: 'Discount', amount: '100%', context: context),
                        const SizedBox(
                          height: 10.0,
                        ),
                        discountWidget(
                            name: 'Discount', amount: '100%', context: context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => ListDiscountViewModel());
  }
  //discount list widget

  // List of category
  Widget discountWidget(
      {@required String name, @required String amount, BuildContext context}) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.grey[300]),
        )),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(name,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).hintColor))),
            ),
            Expanded(
              flex: 3,
              child: Text(amount,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).hintColor))),
            ),
            Divider(
              color: Colors.grey[400],
            )
          ],
        ),
      ),
    );
  }
}
