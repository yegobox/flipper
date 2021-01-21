import 'package:flutter/material.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';

//NOTE: as seen it is hard to share data amoung views using stacked services
// for this case we are using redux for now. so we can share data on application global level
// redux will be rejected so we don't use it as more often.
class ReactiveColor extends StatelessWidget {
  const ReactiveColor({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return ;
      },
    );
  }
}
