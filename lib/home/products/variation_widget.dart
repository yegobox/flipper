import 'package:flipper/data/main_database.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper/locator.dart';

class VariationWidget extends StatefulWidget {
  const VariationWidget(
      {Key key,
      @required this.variation,
      @required this.context,
      @required this.vm})
      : super(key: key);

  final VariationTableData variation;
  final BuildContext context;
  final CommonViewModel vm;

  @override
  _VariationWidgetState createState() => _VariationWidgetState();
}

class _VariationWidgetState extends State<VariationWidget> {
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      GestureDetector(
        onTap: () {
          _navigationService.navigateTo(
            Routing.editVariationScreen,
            //TODO(richard): work on this.
            // arguments: EditVariationScreenArguments(
            //   variationId: widget.variation.id,
            //     itemId: widget.variation.productId
            // ),
          );
        },
        child: StreamBuilder(
            stream: widget.vm.database.stockDao.getStockByProductIdStream(
                branchId: widget.vm.branch.id, productId: '001'),
            builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
              if (snapshot.data == null) {
                return Text('');
              }
              return Column(
                children:
                    buildVariantRow(snapshot, context, widget.variation.name),
              );
            }),
      )
    ]);
  }

  List<Widget> buildVariantRow(AsyncSnapshot<List<StockTableData>> snapshot,
      BuildContext context, String name) {
    List<Widget> list = [];
    for (var i = 0; i < snapshot.data.length; i++) {
      list.add(ListTile(
        leading: Icon(
          Icons.dehaze,
        ),
        subtitle: Text('${name}\nRWF${snapshot.data[i].retailPrice}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          FlatButton(
            child: Text(
              snapshot.data == null
                  ? 'Receive Stock'
                  : '${snapshot.data[i].currentStock}' + 'in Stock',
            ),
            onPressed: () {
              _navigationService.navigateTo(Routing.receiveStock);
            },
          )
        ]),
        dense: true,
      ));
    }
    return list;
  }
}
