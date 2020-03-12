import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SectionZero extends StatefulWidget {
  SectionZero({Key key}) : super(key: key);

  @override
  _SectionZeroState createState() => _SectionZeroState();
}

class _SectionZeroState extends State<SectionZero> {
  Text unitSelector(List<UnitTableData> units) {
    Text text;
    for (var i = 0; i < units.length; i++) {
      if (units[i].focused) {
        text = Text(units[i].name);
      } else {
        text = Text(S.of(context).selectUnit);
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
                Router.navigator.pushNamed(Router.addUnitType);
              },
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.3),
                leading: Text(S.of(context).unityType),
                trailing: Wrap(
                  children: <Widget>[
                    StreamBuilder(
                        stream: vm.database.unitDao.getUnitsStream(),
                        builder: (context,
                            AsyncSnapshot<List<UnitTableData>> snapshot) {
                          if (snapshot.data == null) {
                            return Text(S.of(context).selectCategory);
                          }
                          return snapshot.data == null
                              ? Text(S.of(context).selectCategory)
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
