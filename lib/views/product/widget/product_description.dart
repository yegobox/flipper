import 'package:flipper/views/product/widget/product_description_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class ProductDescription extends StatelessWidget {
   ProductDescription({Key key}) : super(key: key);

final _quantityController = TextEditingController();
final _notesController = TextEditingController();

//Product category
  Widget _productCategory(
      {@required String title,
      @required double values,
      @required ProductDescriptionViewmodel model}) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(title,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(children: [
                      Expanded(
                        child: Text('Frw${values.toString()}',
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.grey[800]))),
                      ),
                      Expanded(
                        child: Radio(
                          value: values,
                          groupValue: model.checked,
                          onChanged: (double value) {
                            model.updateTitleAmountDefault(value: value);
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantityWidget(
      {ProductDescriptionViewmodel model, BuildContext context}) {
    // NOTE: [telesphore] in case of func parameter let's use the name parameter as it is much readable
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('QUANTITY',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0,
                                color: Colors.grey[800]))),
                  ),
                  const Expanded(flex: 2, child: Text('')),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: const Icon(FontAwesome.minus),
                          onPressed: model.decreaseQty)),
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context)
                                .copyWith(canvasColor: Colors.grey[700])
                                .canvasColor,
                          ),
                          key: Key(model.quantity.toString()),
                          initialValue: model.quantity.toString(),
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context)
                              .copyWith(canvasColor: Colors.grey[700])
                              .canvasColor,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: IconButton(
                            icon:const  Icon(FontAwesome.plus),
                            onPressed: model.increaseQty),
                      )),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('NOTES',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0,
                                color: Colors.grey[800]))),
                  ),
                  const Expanded(flex: 2, child: Text('')),
                ],
              ),
              TextField(
                style: TextStyle(color: Colors.grey[900]),
                textAlign: TextAlign.left,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    hintText: 'Add a note',
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .copyWith(canvasColor: Colors.grey[600])
                          .canvasColor,
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('DISCOUNTS',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Theme.of(context)
                              .copyWith(canvasColor: Colors.grey[700])
                              .canvasColor,
                        ))),
                  ),
                  const Expanded(flex: 2, child: Text('')),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.grey[300],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Abajama 0.005%',
                        softWrap: true,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context)
                              .copyWith(canvasColor: Colors.grey[600])
                              .canvasColor,
                        ))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      value: model.slider,
                      min: 0,
                      max: 100,
                      divisions: 1,
                      onChanged: (double value) {
                        model.slide(value: value);
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDescriptionViewmodel>.reactive(
        builder: (BuildContext context, ProductDescriptionViewmodel model,
            Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'Benz  FRw ${model.titleAmount}', // title
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
                    child: Text('Add',
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
                        Row(
                          children: [
                            Text('Benz ',
                                style: GoogleFonts.rubik(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.grey[700]))),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'CHOOSE ONE',
                              style: GoogleFonts.rubik(
                                textStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.grey[700]),
                              ),
                            )
                          ],
                        ),
                        //TODO:{telesphore}product category to be looped if necessary!
                        // _productCategory('Benz', 4000),
                        _productCategory(
                            title: 'Benz', model: model, values: 4000),

                        _productCategory(
                            title: 'Toyota Ntoya', model: model, values: 5000),

                        // endloop  == start/and discounts
                        _quantityWidget(context: context, model: model),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        onModelReady: (ProductDescriptionViewmodel model) {
          
        },
        viewModelBuilder: () => ProductDescriptionViewmodel());
  }
}
