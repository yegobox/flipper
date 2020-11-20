import 'dart:async';

import 'package:flipper/views/welcome/common/route_model.dart';
import 'package:flutter/material.dart';

import 'package:rubber/rubber.dart';


class AppDetailSheet extends StatefulWidget {
  AppDetailSheet({Key key, TickerProvider vsync, @required this.hasAppBar})
      : rubberAnimationController = RubberAnimationController(
          vsync: vsync,
          lowerBoundValue: AnimationControllerValue(percentage: 0),
          halfBoundValue: AnimationControllerValue(percentage: 0.5),
          upperBoundValue: AnimationControllerValue(percentage: 1),
          duration: const Duration(milliseconds: 200),
          springDescription: SpringDescription.withDampingRatio(
              mass: 1, ratio: DampingRatio.NO_BOUNCY, stiffness: Stiffness.LOW),
        ),
        scrollController = ScrollController(),
        super(key: key) {
    rubberAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        rubberAnimationController.halfBoundValue = null;
      }
    });
  }

  final ScrollController scrollController;
  final RubberAnimationController rubberAnimationController;
  final bool hasAppBar;
  static const Duration updateAnimationDuration = Duration(milliseconds: 1000);
  static const Duration editAnimationDuration = Duration(milliseconds: 250);
  static const double rowAnimationDuration = 0.4;
  static const double rowAnimationOffset = 0.075;
  static const double _launchVelocity = 5.0;
  final double titleFadeInDurationFactor = 0.5;
  final double _sheetHalfBoundValue = 0.5;

  static AppDetailSheetState of(BuildContext context) =>
      context.findAncestorStateOfType<AppDetailSheetState>();

  @override
  State<StatefulWidget> createState() => AppDetailSheetState();
}

class AppDetailSheetState extends State<AppDetailSheet>
    with TickerProviderStateMixin {
 
  bool _isStarEnabled = false;
  bool _isEditing = false;
  bool _isAnimating = false;

  
  TextEditingController textController;

  /*
   * Updates the bottom sheet with details of another bus stop
   *
   * Called externally from the parent containing this widget
   */
 

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    // if (_busStop == null)
    //   return Container();

    final Widget scrollView = ListView(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.scrollController,
      children: <Widget>[
        _buildHeader(),
        _buildServiceList(),
       Container(child: Text('footer')),
      ],
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        type: MaterialType.card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        elevation: 16.0,
        child: RouteModel(child: scrollView),
      ),
    );
  }

  @override
  void dispose() {
   
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_isEditing) {
      setState(() {
        _isEditing = false;
      });
      return false;
    }

    if (widget.rubberAnimationController.value != 0) {
      widget.rubberAnimationController.animateTo(to: 0);
      return false;
    }

    return true;
  }

  Widget _buildHeader() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double extraPadding = widget.hasAppBar ? 0 : statusBarHeight;

    return AnimatedBuilder(
      animation: widget.rubberAnimationController,
      builder: (BuildContext context, Widget child) {
        final double completed = widget.rubberAnimationController.upperBound;
        final double dismissed = widget.rubberAnimationController.lowerBound;
        const double animationStart = 0.75;
        final double animationRange = completed - animationStart;
        final double animationStartBound = dismissed + (completed - dismissed) * animationStart;
        final double paddingHeightScale = ((widget.rubberAnimationController.value - animationStartBound) / animationRange).clamp(0.0, 1.0);
        return Container(
          padding: EdgeInsets.only(
            top: 48.0 + extraPadding * paddingHeightScale,
            left: 16.0,
            right: 16.0,
            bottom: 32.0,
          ),
          child: child,
        );
      },
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 56.0, right: 56.0),
              child: AnimatedSize(
                alignment: Alignment.topCenter,
                vsync: this,
                duration: AppDetailSheet.updateAnimationDuration * 0.1,
                child: AnimatedSwitcher(
                  duration: AppDetailSheet.updateAnimationDuration * widget.titleFadeInDurationFactor,
                  switchInCurve: const Interval(0.25, 1),
                  switchOutCurve: const Interval(0.75, 1),
                  layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
                    return Stack(
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                      alignment: Alignment.topCenter,
                    );
                  },
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final bool entering = child.key == ValueKey<String>('code');
                    final Animatable<double> curve = CurveTween(curve: entering ? Curves.easeOutCubic : Curves.linear);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation
                            .drive(curve)
                            .drive(Tween<Offset>(begin: Offset(0, 0.5 * (entering ? 1 : -1)), end: Offset.zero)),
                        child: entering ? child : Align(alignment: Alignment.topCenter, heightFactor: 1 - animation.value, child: child),
                      ),
                    );
                  },
                 
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: _buildHeaderOverflow(),
          ),
        ],
      ),
    );
  }

  // ignore: missing_return
  Widget _buildHeaderOverflow() {
    // if (_isEditing)
    //   return IconButton(
    //     tooltip: 'Done',
    //     icon: const Icon(Icons.done),
    //     color: Theme.of(context).accentColor,
    //     onPressed: () {
    //       setState(() {
    //         _isEditing = false;
    //       });
    //     },
    //   );
    // return PopupMenuButton<_MenuOption>(
    //   icon: Icon(Icons.more_vert, color: Theme.of(context).hintColor),
    //   onSelected: (_MenuOption option) {
    //     switch(option) {
    //       case _MenuOption.edit:
    //         setState(() {
    //           _isEditing = !_isEditing;
    //           if (widget.rubberAnimationController.value != widget.rubberAnimationController.upperBound)
    //             widget.rubberAnimationController.launchTo(
    //                 widget.rubberAnimationController.value,
    //                 widget.rubberAnimationController.upperBound,
    //                 velocity: BusStopDetailSheet._launchVelocity / 2);
    //         });
    //         break;
    //       case _MenuOption.rename:
           
    //         break;
    //       case _MenuOption.favorite:
    //         setState(() {
    //           _isStarEnabled = !_isStarEnabled;
    //         });
            
    //         break;
    //       case _MenuOption.googleMaps:
    //         // launch('geo:${_busStop.latitude},${_busStop.longitude}?q=${_busStop.defaultName} ${_busStop.code}');
    //         break;
    //     }
    //   },
    //   itemBuilder: (BuildContext context) => <PopupMenuEntry<_MenuOption>>[
    //     const PopupMenuItem<_MenuOption>(
    //       value: _MenuOption.rename,
    //       child: Text('Rename'),
    //     ),
    //     if (_isStarEnabled)
    //       const PopupMenuDivider(),
    //     if (_isStarEnabled)
    //       const PopupMenuItem<_MenuOption>(
    //         value: _MenuOption.edit,
    //         child: Text('Manage pinned services'),
    //       ),
    //     PopupMenuItem<_MenuOption>(
    //       value: _MenuOption.favorite,
    //       child: Text(_isStarEnabled ? _route == UserRoute.home ? 'Unpin from home' : 'Remove from route' : 'Pin to home'),
    //     ),
    //     const PopupMenuDivider(),
    //     const PopupMenuItem<_MenuOption>(
    //       value: _MenuOption.googleMaps,
    //       child: Text('Open in Google Maps'),
    //     ),
    //   ],
    // );
  }

  Widget _buildServiceList() {
    return Column(
      children: <Widget>[
        AnimatedSize(
          vsync: this,
          duration: AppDetailSheet.editAnimationDuration * 2,
          curve: Curves.easeInOutCirc,
          child: _isEditing ? Container(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pinned bus services',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  'Arrival times of pinned buses are displayed on the',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).hintColor),
                )
              ],
            )
          ) : Container(),
        ),
       
      ],
    );
  }

}

