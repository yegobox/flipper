import 'package:flipper/home/product/add/add_product_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

class RetailView extends StatefulWidget {
  const RetailView({Key key, this.model}) : super(key: key);
  final AddProductViewmodel model;

  @override
  _RetailViewState createState() => _RetailViewState();
}

class _RetailViewState extends State<RetailView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.only(left:18,right:18),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.model.retailPriceController,
          decoration: InputDecoration(
            hintText: 'Retail Price',
            fillColor: Theme.of(context)
                .copyWith(canvasColor: Colors.white)
                .canvasColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('#D0D7E3')),
              borderRadius: BorderRadius.circular(5),
            ),
            suffixIcon: const Icon(Icons.book),
          ),
        ),
      ),
    );
  }
}
