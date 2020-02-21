import 'package:flipper/data/main_database.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      GestureDetector(
        onTap: () {
          Router.navigator.pushNamed(
            Router.editVariationScreen,
            arguments: EditVariationScreenArguments(
                variationId: widget.variation.id, unitId: 1),
          );
        },
        child: StreamBuilder(
            stream: widget.vm.database.stockDao.getStockByVariantIdStream(
                branchId: widget.vm.branch.id, variantId: widget.variation.id),
            builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Column(
                children: buildVariantRow(snapshot, context),
              );
            }),
      )
    ]);
  }

  List<Widget> buildVariantRow(
      AsyncSnapshot<List<StockTableData>> snapshot, BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < snapshot.data.length; i++) {
      list.add(ListTile(
        leading: Icon(
          Icons.dehaze,
        ),
        subtitle: Text("${snapshot.data[i].retailPrice} \nRWF"),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          FlatButton(
            child: Text(
              snapshot.data == null
                  ? S.of(context).receiveStock
                  : "${snapshot.data[i].currentStock}" + S.of(context).inStock,
            ),
            onPressed: () {},
          )
        ]),
        dense: true,
      ));
    }
    return list;
  }
}
