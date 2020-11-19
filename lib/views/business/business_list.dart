import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';

import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/business.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BusinessList extends StatefulWidget {
//  final Function(DrawerState) stateChangeCallback;
  final CommonViewModel vm;
  // ignore: sort_constructors_first
  const BusinessList({Key key, this.vm}) : super(key: key);


  @override
  _BusinessListState createState() => _BusinessListState();
}

class _BusinessListState extends State<BusinessList> {
  bool _businessSelected = false;
  final FlipperNavigationService _navigationService =
     ProxyService.nav;

  Container _buildFirstSectionFlipperLogo(BuildContext context) {
    return Container(
      height: _Style.firstSectionHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(children: <Widget>[
              // ..._buildSelectionHighlight(_businessSelected, Colors.white),
              _selectableListItem(
                  userIcon: Text(widget.vm.user.name.length > 2
                      ? widget.vm.user.name.substring(0, 1).toUpperCase()
                      : widget.vm.user.name.toUpperCase()),
                  isSquareShape: _businessSelected,
                  action: () {
                    setState(() {
                      _businessSelected = true;
                    });
                  }),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: _Style.padding,
            ),
          ),
          Container(
            color: const Color.fromRGBO(
                33, 127, 125, 1.0), // TODO(lonald): should app theme instead
            height: _Style.separatorHeight,
            width: _Style.separatorWidth,
          ),
        ],
      ),
    );
  }

  Container _buildThirdSection(BuildContext context) {
    return Container(
        height: _Style.thirdSectionHeight,
        child: Column(
          children: <Widget>[
            _Style.defaultPadding,
            _GroupSettingsButton(
                Image.asset('assets/graphics/drawer/create_topic.png'), () {
              // TODO(richard): fix overflow when loading more than 7 businesses for now we are not alloing user to create more than2 business
              if (widget.vm.businesses.length >= 3) {
                // TODO(richard): show a toast here that we can not create additional business...
                return;
              }
              // TODO(richard): will suport creation of business within app in 2 years
              // _navigationService.navigateTo(Routing.createBusiness);
            }),
          ],
        ));
  }

  Container _buildFourthSection(BuildContext context) {
    return Container(
      height: _Style.fourthSectionHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _Style.defaultPadding,
          _GroupSettingsButton(
            Image.asset('assets/graphics/drawer/account.png'),
            () async {
              // _openUserAccount(context);
              // TODO(richard): change the icon should be icon of logout.
              final Store<AppState> store = StoreProvider.of<AppState>(context);
              final bool loggedOut = await ProxyService.sharedPref.logout();
              if (loggedOut) {
                store.dispatch(
                  VerifyAuthenticationState(),
                );
              }
            },
          ),
          _Style.defaultPadding,
        ],
      ),
    );
  }

  Container _buildSecondSectionBusinessList(BuildContext context,
      // ignore: always_specify_types
      {onClick = true,
      hasNotification = true,
      data}) {
    return Container(
      height: _Style.itemHeight,
      child: Padding(
        padding:
            const EdgeInsets.only(top: _Style.padding, right: _Style.padding),
        child: _GroupButton(
          data,
          (Business business) {
            StoreProvider.of<AppState>(context)
                .dispatch(NextActiveBussiness(business));
            StoreProvider.of<AppState>(context)
                .dispatch(SetActiveBusiness(business));
          },
          onClick,
          hasNotification,
        ),
      ),
    );
  }

  Widget getRenderableBusinessList(List<Business> businesses) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < businesses.length; i++) {
      list.add(_buildSecondSectionBusinessList(context,
          onClick: false, data: businesses[i]));
    }
    return Expanded(
      child: Column(children: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#130f1f'),
      child: Column(
        children: <Widget>[
          _buildFirstSectionFlipperLogo(context),
          getRenderableBusinessList(widget.vm.businesses),
          //setting on click set highlight on side.
          _buildThirdSection(context),
          _buildFourthSection(context)
        ],
      ),
    );
  }
}

class _GroupSettingsButton extends StatelessWidget {
  final Image image;
  final Function onPressed;

  // ignore: sort_constructors_first
  const _GroupSettingsButton(
    this.image,
    this.onPressed, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _Style.flipperButtonWidth,
        height: _Style.flipperButtonWidth,
        child: FittedBox(
            fit: BoxFit.cover,
            child: FlatButton(
              shape: const CircleBorder(),
              child: image,
              onPressed: onPressed,
            )));
  }
}

class _GroupButton extends StatelessWidget {
  final Business business;
  final Function(Business) onPressedCircle;
  final bool isActive;
  final bool hasUpdates;

  // ignore: sort_constructors_first
  const _GroupButton(
    this.business,
    this.onPressedCircle,
    this.isActive,
    this.hasUpdates, {
    Key key,
  })  : assert(business != null),
        assert(onPressedCircle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final HexColor _circleColor = HexColor(
        '#f5a623'); // TODO(richard): make this color comes from setting in v.2
    final String _groupText = business.name.substring(0, 1).toUpperCase();

    if (business.active) {
      StoreProvider.of<AppState>(context)
          .dispatch(ActiveBusinessAction(business));
    }
    return Container(
      child: Row(
        children: <Widget>[
          ..._buildSelectionHighlight(business.active, _circleColor),
          _selectableListItem(
            color: _circleColor,
            text: _groupText,
            action: () {
              onPressedCircle(business);
            },
            updateIndicatorVisible: hasUpdates,
            isSquareShape: true, //set to true by default
          ),
        ],
      ),
    );
  }
}

AnimatedContainer _selectableListItem({
  Color color = Colors.white,
  String text = '',
  Widget userIcon,
  Function action,
  bool updateIndicatorVisible = false,
  bool isSquareShape = false,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 100),
    width: _Style.flipperButtonWidth,
    height: _Style.flipperButtonWidth,
    decoration: BoxDecoration(
      color: color,
      borderRadius:
          BorderRadius.all(Radius.circular(isSquareShape ? 8.0 : 22.0)),
    ),
    child: Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        InkWell(
          child: Container(
            alignment: const Alignment(0, 0),
            width: _Style.flipperButtonWidth,
            height: _Style.flipperButtonWidth,
            child: userIcon == null ? Text(text) : userIcon,
          ),
          onTap: action,
        ),
        Visibility(
          visible: updateIndicatorVisible,
          child: Positioned(
            top: -2,
            right: -2,
            height: _Style.circleUnreadIndicatorWidth,
            width: _Style.circleUnreadIndicatorWidth,
            child: ClipOval(
              child: Container(
                color: HexColor('#44bd32'),
                height: 20.0, // height of the button
                width: 20.0, // width of the button
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ignore: always_specify_types
List<Widget> _buildSelectionHighlight(isSelected, circleColor) {
  final List<Widget> widgets = [];
  if (isSelected) {
    final ClipRRect highlight = ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(_Style.circleHighlightBorderRadius),
            bottomRight: Radius.circular(_Style.circleHighlightBorderRadius)),
        child: Container(
          width: _Style.circleHighlightWidth,
          height: _Style.flipperButtonWidth,
          color: circleColor,
        ));
    widgets.add(highlight);
  }

  final SizedBox sizedBoxSpace = SizedBox(
    // ignore: unnecessary_parenthesis
    width: (isSelected ? 11 : 15),
  );

  widgets.add(sizedBoxSpace);
  return widgets;
}

class _Style {
  static const double flipperButtonWidth = 44.0;

  static const double circleHighlightWidth = 4.0;
  static const double circleHighlightBorderRadius = 10.0;
  static const double circleUnreadIndicatorWidth = 14.0;

  static const double separatorHeight = 2.0;
  static const double separatorWidth = 48.0;
  static const double padding = 8.0;
  static const Padding defaultPadding =
      Padding(padding: EdgeInsets.only(top: padding));

  static const double itemHeight = 52.0;
  static const double firstSectionHeight = 100.0;
  static const double thirdSectionHeight = 60.0;
  static const double fourthSectionHeight = 180.0;
// Sum of all sections without itemHeight
}
