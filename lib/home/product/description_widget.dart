import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flutter/material.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget({Key key}) : super(key: key);

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.only(left:18,right:18),
      child: Container(
        width: double.infinity,
        child: TextFormField(
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
          onChanged: (String description) {
            setState(() {
              DataManager.description = description;
            });
          },
        ),
      ),
    );
  }
}
