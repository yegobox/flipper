import 'package:flutter/material.dart';

class SkuView extends StatelessWidget {
  const SkuView({Key? key, required this.onModelUpdate}) : super(key: key);
  final Function onModelUpdate;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          style: const TextStyle(color: Colors.black),
          // controller:model.skuController,
          onChanged: (value) {
            onModelUpdate(value);
          },
          decoration:
              const InputDecoration(hintText: 'SKU', focusColor: Colors.blue),
        ),
      ),
    );
  }
}
