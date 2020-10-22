import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddUnitTypeScreen extends StatefulWidget {
  AddUnitTypeScreen({Key key, this.productId}) : super(key: key);
  final String productId;
  @override
  _AddUnitTypeScreenState createState() => _AddUnitTypeScreenState();
}

class _AddUnitTypeScreenState extends State<AddUnitTypeScreen> {
  List<Widget> _getUnitsWidgets(
      AsyncSnapshot<List<Unit>> snapshot, CommonViewModel vm) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].focused && widget.productId != null) {
        updatedItemWithCurrentUnit(vm, snapshot.data[i]);
      }
      list.add(
        GestureDetector(
          onTap: () {
            // FIXME:
            // for (var y = 0; y < snapshot.data.length; y++) {
            //   vm.database.unitDao
            //       .updateUnit(snapshot.data[y].copyWith(focused: false));
            // }
            // vm.database.unitDao.updateUnit(
            //     snapshot.data[i].copyWith(focused: !snapshot.data[i].focused));
          },
          child: ListTile(
            title: Text(
              snapshot.data[i].name,
              style: TextStyle(color: Colors.black),
            ),
            // FIXME:
            // trailing: Radio(
            //   value: snapshot.data[i].id,
            //   groupValue: snapshot.data[i].focused ? snapshot.data[i].id : 0,
            //   onChanged: (int value) {},
            // ),
          ),
        ),
      );
    }
    return list;
  }

  Future updatedItemWithCurrentUnit(
      CommonViewModel vm, Unit unit) async {
    //get all variant related to this product and updated it unit.
    //all variant submitted to this product has same unit, can be changed later on.
    // FIXME:
    // List<Unir> variants = await vm.database.variationDao
    //     .getVariantByProductId(productId: widget.productId);
    // for (var i = 0; i < variants.length; i++) {
    //   vm.database.variationDao
    //       .updateVariation(variants[i].copyWith(unit: unit.value));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            title: 'Edit Unit',
            showActionButton: true,
            disableButton: false,
            actionButtonName: 'Save',
            onPressedCallback: () {
              StoreProvider.of<AppState>(context)
                  .dispatch(PersistFocusedUnitAction());

              StoreProvider.of<AppState>(context).dispatch(AppAction(
                  actions: AppActions((a) => a..name = 'showLoader')));
            },
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body:const Text('unit need implemetation')
          // FIXME:
          // body: StreamBuilder(
          //     stream: vm.database.unitDao.getUnitsStream(),
          //     builder: (context, AsyncSnapshot<List<UnitTableData>> snapshot) {
          //       if (snapshot.data == null) {
          //         return Text('');
          //       }

          //       return ListView(
          //           children: ListTile.divideTiles(
          //         context: context,
          //         tiles: _getUnitsWidgets(snapshot, vm),
          //       ).toList());
          //     }),
        );
      },
    );
  }

  _handleFormSubmit() {
    StoreProvider.of<AppState>(context).dispatch(ResetAppAction());
    StoreProvider.of<AppState>(context).dispatch(CreateUnit());
  }
}
