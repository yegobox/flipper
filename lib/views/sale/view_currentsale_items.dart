import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:customappbar/customappbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';

class ViewCurrentSaleItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, CompleteSaleViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Edits',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView.builder(
              itemCount: model.keypad.currentSalesItem.length,
              itemBuilder: (context, index) {
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => false,
                    )
                  ],
                  child: const ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0, right: 40.0),
                    trailing: Text(
                      'Frw300',
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: Text('Custom Amount',
                        style: TextStyle(color: Colors.black)),
                  ),
                );
              },
            ),
          );
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
