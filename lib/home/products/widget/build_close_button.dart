import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BuildCloseButton extends StatefulWidget {
  const BuildCloseButton({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;
  @override
  _BuildCloseButtonState createState() => _BuildCloseButtonState();
}

class _BuildCloseButtonState extends State<BuildCloseButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.topLeft,
      icon: const Icon(Icons.close),
      // icon: customIcon(icon:0xe65e,),
      color: Colors.white,
      onPressed: () async {
        final Store<AppState> store = StoreProvider.of<AppState>(context);

        // ignore: always_specify_types
        // final updatedProduct =
        //     await _databaseService.getById(id: vm.tmpItem.id);

        // DataManager.dispatchProduct(store, updatedProduct);
      },
    );
  }
}