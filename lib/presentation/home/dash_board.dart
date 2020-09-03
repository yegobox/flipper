import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/homescreen.dart';
import 'package:flipper/home/in_app_notification/in_app_notification_viewmodel.dart';
import 'package:flipper/home/in_app_notification/in_app_notification_widget.dart';
import 'package:flipper/home/slide_out_screen.dart';
import 'package:flipper/presentation/branch/event/event_details.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  ValueNotifier<bool> _sideOpenController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _sideOpenController = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    super.dispose();
    _sideOpenController.dispose();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: <Widget>[
          StoreConnector<AppState, CommonViewModel>(
            distinct: true,
            converter: CommonViewModel.fromStore,
            // ignore: missing_return
            builder: (BuildContext context, CommonViewModel vm) {
              if (vm.hasUser) {
                final Scaffold we = Scaffold(
                  backgroundColor: Colors.black,
                  key: _scaffoldKey,
                  body: SlideOutScreen(
                    main: HomeScreen(
                      vm: vm,
                      sideOpenController: _sideOpenController,
                    ),
                    side: EventDetails(),
                    sideOpenController: _sideOpenController,
                  ),
                );
                if (vm.hasSheet) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Routing.navigator.pushNamed(Routing.addNoteScreen));
                }
                return we;
              }
            },
          ),
          StoreConnector<AppState, InAppNotificationViewModel>(
            builder: (BuildContext context, InAppNotificationViewModel vm) {
              return vm.inAppNotification != null
                  ? InAppNotificationWidget(vm)
                  : Container();
            },
            converter: InAppNotificationViewModel.fromStore,
            distinct: true,
          ),
        ],
      ),
    );
  }
}
