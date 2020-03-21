import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ControlSaleWidget extends StatelessWidget {
  const ControlSaleWidget({Key key, @required this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Center(
        child: Container(
          width: 80,
          child: TextField(
            textDirection: TextDirection.rtl,
            onChanged: (count) {
              //todo: work on entering count from keyboard right now it is messing around with other inputs
            },
            controller: TextEditingController(
              text: vm.currentIncrement == null
                  ? "1"
                  : vm.currentIncrement.toString(),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      leading: IconButton(
        enableFeedback: false,
        icon: Icon(Icons.remove),
        onPressed: () {
          if (vm.itemVariations.length > 0) {
            for (var i = 0; i < vm.itemVariations.length; i++) {
              if (vm.currentActiveSaleProduct.id ==
                  vm.itemVariations[i].productId) {
                if (vm.currentIncrement == null) {
                  return;
                }
                if (vm.currentIncrement - 1 == -1) {
                  return;
                }
                var increment = vm.currentIncrement - 1;
                StoreProvider.of<AppState>(context).dispatch(
                  IncrementAction(
                    increment: vm.currentIncrement == null ? 0 : increment,
                  ),
                );
              }
            }
          }
        },
      ),
      trailing: IconButton(
        enableFeedback: false,
        icon: Icon(Icons.add),
        onPressed: () {
          for (var i = 0; i < vm.itemVariations.length; i++) {
            if (vm.currentActiveSaleProduct.id ==
                vm.itemVariations[i].productId) {
              var increment =
                  vm.currentIncrement == null ? 1 : vm.currentIncrement + 1;

              StoreProvider.of<AppState>(context).dispatch(
                IncrementAction(
                  increment: vm.currentIncrement == null ? 1 : increment,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
