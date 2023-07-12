import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Transaction 1'),
          
        ),
        ListTile(
          title: Text('Transaction 2'),
        ),
        ListTile(
          title: Text('Transaction 3'),
        ),
        ListTile(
          title: Text('Transaction 4'),
        ),
        ListTile(
          title: Text('Transaction 5'),
        ),
        ListTile(
          title: Text('Transaction 6'),
        ),
        ListTile(
          title: Text('Transaction 7'),
        ),
      ],
    );
  }
}