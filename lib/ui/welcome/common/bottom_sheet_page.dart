
import 'package:flutter/material.dart';

import 'package:rubber/rubber.dart';

import 'app_detail_sheet.dart';

abstract class BottomSheetPage extends StatefulWidget {
  final GlobalKey<AppDetailSheetState> bottomSheetKey = GlobalKey();
}

abstract class BottomSheetPageState<T extends BottomSheetPage> extends State<T> with TickerProviderStateMixin<T> {
  bool initialized = false;
  RubberAnimationController rubberAnimationController;
  ScrollController sheetScrollController;
  AppDetailSheet busStopDetailSheet;

  @override
  void dispose() {
    if (sheetScrollController != null)
      sheetScrollController.dispose();
    super.dispose();
  }

  void buildSheet({@required bool hasAppBar}) {
    /* Initialize rubber sheet */
    if (widget.bottomSheetKey.currentState == null) {
      busStopDetailSheet =
          AppDetailSheet(
              key: widget.bottomSheetKey, vsync: this, hasAppBar: hasAppBar);
      rubberAnimationController = busStopDetailSheet.rubberAnimationController;
      sheetScrollController = busStopDetailSheet.scrollController;
      initialized = true;
    }
  }

  Widget bottomSheet({@required Widget child}) {
    return RubberBottomSheet(
      scrollController: sheetScrollController,
      animationController: rubberAnimationController,
      lowerLayer: child,
      upperLayer: busStopDetailSheet,
    );
  }

  bool isBusDetailSheetVisible() {
    return rubberAnimationController.value > 0;
  }

  // @mustCallSuper
  // void showBusDetailSheet(BusStop busStop, UserRoute route) {
  //   widget.bottomSheetKey.currentState.updateWith(busStop, route);
  // }

  @mustCallSuper
  void hideBusDetailSheet() {
    rubberAnimationController.animateTo(to: rubberAnimationController.lowerBound);
    // widget.bottomSheetKey.currentState.updateWith(null, null);
  }
}