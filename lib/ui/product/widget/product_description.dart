import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper/utils/HexColor.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({Key key}) : super(key: key);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  double _checked;
  TextEditingController quantityController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();
  double _slider = 0;
  int quantity = 1;
  double paramsDefault = 230.8;
  double titleAmount = 0;
  @override
  void initState() {
    super.initState();
  }

  void _increaseQty() {
    setState(() {
      quantity++;
      titleAmount = paramsDefault + (_checked*quantity);
    });
  }

  void _decreaseQty() {
    setState(() {
      quantity--;
      titleAmount = paramsDefault + (_checked*quantity);
      // print(quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Benz  FRw ${titleAmount}', // title
            style: Theme.of(context)

                .textTheme
                .bodyText2
                .copyWith(color: Colors.grey[800]),
          ),
          iconTheme: IconThemeData(color: Colors.black),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.0, 30.0, 18.0, 2.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Benz ",
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[700]))),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text("CHOOSE ONE",
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  fontSize: 12.0, color: Colors.grey[700])))
                    ],
                  ),
                  //{telesphore}product category to be looped if necessary!
                  _productCategory('Benz', 4000),
                  _productCategory('Toyota Ntoya', 5000),

                  // endloop  == start/and discounts
                  _quantityWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Product category
  Widget _productCategory(String title, double values) {
    return SingleChildScrollView(
        child: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(children: [
                  Divider(
                    color: Colors.grey[300],
                  ),
                  SizedBox(
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
                              groupValue: _checked,
                              onChanged: (double value) {
                                setState(() {
                                  _checked = value;
                                  titleAmount = paramsDefault + _checked;
                                });
                              },
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ]))));
  }

  //{telesphore} //quantity motes and discount
  Widget _quantityWidget() {
    return SingleChildScrollView(
        child: Container(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(children: [
                  Divider(
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 8.0,
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
                      Expanded(flex: 2, child: Text('')),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(FontAwesome.minus),
                            onPressed: () {
                              _decreaseQty();
                            },
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: TextFormField(
                              style: TextStyle(
                                color: Theme.of(context)
                                    .copyWith(canvasColor: Colors.grey[700])
                                    .canvasColor,
                              ),
                              key: Key(quantity.toString()),
                              initialValue: quantity.toString(),
                              textAlign: TextAlign.center,
                              cursorColor: Theme.of(context)
                                  .copyWith(canvasColor: Colors.grey[700])
                                  .canvasColor,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: IconButton(
                              icon: Icon(FontAwesome.plus),
                              onPressed: () {
                                _increaseQty();
                              },
                            ),
                          )),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
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
                      Expanded(flex: 2, child: Text('')),
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
                  SizedBox(
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
                      Expanded(flex: 2, child: Text('')),
                    ],
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
                          value: _slider,
                          min: 0,
                          max: 100,
                          divisions: 1,
                          onChanged: (double value) {
                            setState(() {
                              _slider = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ]))));
  }
  // end of widget
}
