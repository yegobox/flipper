import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/views/selling/text_editing_workaround.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ControlSaleWidget extends StatefulWidget {
  const ControlSaleWidget({Key key, @required this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  _ControlSaleWidgetState createState() => _ControlSaleWidgetState();
}

class _ControlSaleWidgetState extends State<ControlSaleWidget> {
  @override
  Widget build(BuildContext context) {
    // FIXME: the code is broken due to change in code flow to make code more understandable
    // final TextEditingController _controller =  TextEditingControllerWorkaroud(
    //     text: widget.vm.currentIncrement == null
    //         ? '1'
    //         : widget.vm.currentIncrement.toString());
    return ListTile(
      dense: true,
      title: Center(
        child: Container(
          width: 80,
          child: TextField(
            textDirection: TextDirection.rtl,
            onChanged: (String count) {
              // TODO(richard): work on entering count from keyboard right now it is messing around with other inputs
              //set the increment to this value entered
              if (count == null || count.isEmpty) {
                StoreProvider.of<AppState>(context).dispatch(
                  IncrementAction(
                    increment: 0,
                  ),
                );
              } else {
                StoreProvider.of<AppState>(context).dispatch(
                  IncrementAction(
                    increment: int.parse(count),
                  ),
                );
              }
              //place cursor at end of length of any input
            },
            // controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      leading: IconButton(
        enableFeedback: false,
        icon: const Icon(Icons.remove),
        onPressed: () {
          // if (widget.vm.itemVariations.isNotEmpty) {
          //   for (int i = 0; i < widget.vm.itemVariations.length; i++) {
          //     if (widget.vm.currentActiveSaleProduct.id ==
          //         widget.vm.itemVariations[i].productId) {
          //       if (widget.vm.currentIncrement == null) {
          //         return;
          //       }
          //       if (widget.vm.currentIncrement - 1 == -1) {
          //         return;
          //       }
          //       final int increment = widget.vm.currentIncrement - 1;
          //       StoreProvider.of<AppState>(context).dispatch(
          //         IncrementAction(
          //           increment:
          //               widget.vm.currentIncrement == null ? 0 : increment,
          //         ),
          //       );
          //     }
          //   }
          // }
        },
      ),
      trailing: IconButton(
        enableFeedback: false,
        icon: const Icon(Icons.add),
        onPressed: () {
          // for (int i = 0; i < widget.vm.itemVariations.length; i++) {
          //   if (widget.vm.currentActiveSaleProduct.id ==
          //       widget.vm.itemVariations[i].productId) {
          //     final increment = widget.vm.currentIncrement == null
          //         ? 1
          //         : widget.vm.currentIncrement + 1;

          //     StoreProvider.of<AppState>(context).dispatch(
          //       IncrementAction(
          //         increment: widget.vm.currentIncrement == null ? 1 : increment,
          //       ),
          //     );
          //   }
          // }
        },
      ),
    );
  }
}
