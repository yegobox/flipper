import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class Tabs extends StatelessWidget {
  const Tabs({
    Key key,
    @required this.tabLenght,
  }) : super(key: key);

  final double tabLenght;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.black,
      isScrollable: true,
      tabs: [
        Container(
          width: tabLenght,
          child: Tab(
            text: '1D',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1W',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1M',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '3M',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1Y',
          ),
        ),
      ],
    );
  }
}
