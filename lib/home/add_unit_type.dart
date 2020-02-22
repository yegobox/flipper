import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/presentation/common/common_app_bar.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddUnitTypeScreen extends StatefulWidget {
  AddUnitTypeScreen({Key key, this.itemId}) : super(key: key);
  final int itemId;
  @override
  _AddUnitTypeScreenState createState() => _AddUnitTypeScreenState();
}

class _AddUnitTypeScreenState extends State<AddUnitTypeScreen> {
  Widget _getUnitsWidgets(
      AsyncSnapshot<List<UnitTableData>> snapshot, CommonViewModel vm) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].focused && widget.itemId != null) {
        updatedItemWithCurrentUnit(vm, snapshot.data[i]);
      }
      list.add(
        GestureDetector(
          onTap: () {
            for (var y = 0; y < snapshot.data.length; y++) {
              vm.database.unitDao
                  .updateUnit(snapshot.data[y].copyWith(focused: false));
            }
            vm.database.unitDao.updateUnit(
                snapshot.data[i].copyWith(focused: !snapshot.data[i].focused));
          },
          child: ListTile(
            title: Text(
              'Per ' + snapshot.data[i].name,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Radio(
              value: snapshot.data[i].id,
              groupValue: snapshot.data[i].focused ? snapshot.data[i].id : 0,
              onChanged: (int value) {},
            ),
          ),
        ),
      );
      list.add(Center(
        child: Container(
          width: 400,
          child: Divider(
            color: Colors.black,
          ),
        ),
      ));
    }
    return Wrap(children: list);
  }

  Future updatedItemWithCurrentUnit(
      CommonViewModel vm, UnitTableData unit) async {
    ItemTableData item =
        await vm.database.itemDao.getItemById(itemId: widget.itemId);
    vm.database.itemDao.updateItem(item.copyWith(unitId: unit.id));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            title: S.of(context).editUnitType,
            showActionButton: true,
            disableButton: false,
            actionButtonName: S.of(context).save,
            onPressedCallback: () {
              StoreProvider.of<AppState>(context)
                  .dispatch(PersistFocusedUnitAction());

              StoreProvider.of<AppState>(context).dispatch(AppAction(
                  actions: AppActions((a) => a..name = "showLoader")));
            },
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Column(
            children: <Widget>[
              Center(
                child: Container(
                  height: 40,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
              StreamBuilder(
                  stream: vm.database.unitDao.getUnitsStream(),
                  builder:
                      (context, AsyncSnapshot<List<UnitTableData>> snapshot) {
                    if (snapshot.data == null) {
                      return Text("");
                    }
                    return _getUnitsWidgets(snapshot, vm);
                  }),
              Text("Edit units and precision in items> Units"),
              Visibility(
                visible: false,
                child: FlatButton(
                  child: Text("invisible button"),
                  onPressed: vm.hasAction && vm.appAction.name == 'showLoader'
                      ? _handleFormSubmit()
                      : null,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _handleFormSubmit() {
    StoreProvider.of<AppState>(context).dispatch(ResetAppAction());
    StoreProvider.of<AppState>(context).dispatch(CreateUnit());
  }
}
