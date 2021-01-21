import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFormat = MoneyMaskedTextController(leftSymbol: '\$');

    moneyFormat.updateValue(0);
    //use storeconnector here and get the value broadcasted from store append each at the end of queue

    return Column(children: <Widget>[
      Container(
        width: 350,
        child: TextField(
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.blueAccent,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search product',
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 0.0),
                borderRadius: BorderRadius.circular(0.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.circular(0.0)),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              dense: true,
              trailing: Text(moneyFormat.text),
              leading: Image.network(
                'https://picsum.photos/250?image=9',
              ),
              title: const Text(
                'Yogurt',
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    ]);
  }
}
