import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionSelectUnit extends StatefulWidget {
  SectionSelectUnit({Key key}) : super(key: key);

  @override
  _SectionSelectUnitState createState() => _SectionSelectUnitState();
}

class _SectionSelectUnitState extends State<SectionSelectUnit> {
  Text unitSelector(List<UnitTableData> units) {
    Text text;
    for (var i = 0; i < units.length; i++) {
      if (units[i].focused) {
        text = Text(units[i].name);
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Center(
          child: Container(
            width: 300,
            child: GestureDetector(
              onTap: () {
                Routing.navigator.pushNamed(Routing.addUnitType,
                    arguments: AddUnitTypeScreenArguments(
                        productId: vm.tmpItem.productId));
              },
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.3),
                leading: Text(
                  'Unit Type',
                  style: GoogleFonts.lato(
                    fontStyle: FontStyle.normal,
                    color: AppTheme.addProduct.accentColor,
                    fontSize: AppTheme.addProduct.textTheme.bodyText1
                        .copyWith(fontSize: 12)
                        .fontSize,
                  ),
                ),
                trailing: Wrap(
                  children: <Widget>[
                    StreamBuilder(
                        stream: vm.database.unitDao.getUnitsStream(),
                        builder: (context,
                            AsyncSnapshot<List<UnitTableData>> snapshot) {
                          if (snapshot.data == null) {
                            return Text(
                              'Select Unit',
                              style: GoogleFonts.lato(
                                fontStyle: FontStyle.normal,
                                color: AppTheme.addProduct.accentColor,
                                fontSize: AppTheme
                                    .addProduct.textTheme.bodyText1
                                    .copyWith(fontSize: 12)
                                    .fontSize,
                              ),
                            );
                          }
                          return snapshot.data == null
                              ? Text('Select Unit')
                              : unitSelector(snapshot.data);
                        }),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
