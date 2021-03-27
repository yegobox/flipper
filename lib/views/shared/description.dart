import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

import 'package:flipper_models/view_models/add_product_viewmodel.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({Key key, this.model}) : super(key: key);
  final AddProductViewmodel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          // controller: model.description,
          onChanged: (value) {
            model.setDescription(description: value);
          },
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Description',
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
