import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_models/app_action.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EditUnitView extends StatefulWidget {
  const EditUnitView({Key key, @required this.itemId}) : super(key: key);
  final String itemId;
  @override
  _EditUnitViewState createState() => _EditUnitViewState();
}

class _EditUnitViewState extends State<EditUnitView> {
  // FIXME:
  // List<Widget> _getUnitsWidgets(
  //     AsyncSnapshot<List<UnitTableData>> snapshot, CommonViewModel vm) {
  //   List<Widget> list = new List<Widget>();
  //   for (var i = 0; i < snapshot.data.length; i++) {
  //     if (snapshot.data[i].focused) {
  //       updateItemWithActiveUnit(vm, snapshot.data, i);
  //     }
  //     list.add(
  //       GestureDetector(
  //         onTap: () {
  //           for (var y = 0; y < snapshot.data.length; y++) {
  //             vm.database.unitDao
  //                 .updateUnit(snapshot.data[y].copyWith(focused: false));
  //           }
  //           vm.database.unitDao.updateUnit(
  //               snapshot.data[i].copyWith(focused: !snapshot.data[i].focused));
  //         },
  //         child: ListTile(
  //           title: Text(
  //             snapshot.data[i].name,
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           trailing: Radio(
  //             value: snapshot.data[i].id,
  //             groupValue: snapshot.data[i].focused ? snapshot.data[i].id : 0,
  //             onChanged: (int value) {},
  //           ),
  //         ),
  //       ),
  //     );
  //     list.add(Center(
  //       child: Container(
  //         width: 400,
  //         child: Divider(
  //           color: Colors.black,
  //         ),
  //       ),
  //     ));
  //   }
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                Routing.navigator.pop();
              },
              title: 'Edit Unit',
              showActionButton: true,
              disableButton: false,
              rightActionButtonName: 'Save',
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
            body: const Text('unit not done')
//           body: StreamBuilder(
//               stream: vm.database.unitDao.getUnitsStream(),
//               builder: (context, AsyncSnapshot<List<UnitTableData>> snapshot) {
//                 if (snapshot.data == null) {
//                   return Text('');
//                 }
//                 return ListView(
//                     children: ListTile.divideTiles(
//                   context: context,
//                   tiles: _getUnitsWidgets(snapshot, vm),
//                 ).toList());
// //                    return _getUnitsWidgets(snapshot, vm);
//               }),
            );
      },
    );
  }

  _handleFormSubmit() {
    StoreProvider.of<AppState>(context).dispatch(ResetAppAction());
    StoreProvider.of<AppState>(context).dispatch(CreateUnit());
  }

  Future<void> updateItemWithActiveUnit(
      CommonViewModel vm, List<Unit> unit, int i) async {
    final _dialogService = ProxyService.modal;
    _dialogService.showConfirmationDialog(
        description: 'Can not update active product feature deprecated');

    // final item = await vm.database.productDao.getItemById(productId: widget.itemId);
    // if (item != null) {
    //   vm.database.productDao.updateItem(item.copyWith(unitId: unit[i].id));
    // }
  }
}
