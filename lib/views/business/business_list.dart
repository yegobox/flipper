import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/viewmodels/drawer_viewmodel.dart';

import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';
import 'package:stacked/stacked.dart';

// import 'package:stacked/stacked.dart';
class BusinessList extends StatelessWidget {
  const BusinessList({Key key}) : super(key: key);

  Container _buildFirstSectionFlipperLogo(
      {@required DrawerViewModel model, BuildContext context}) {
    return Container(
      height: _Style.firstSectionHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(children: <Widget>[
              ..._buildSelectionHighlight(false, Colors.white),
              _selectableListItem(
                  userIcon: Text(model.user.name.length > 2
                      ? model.user.name.substring(0, 3).toUpperCase()
                      : model.user.name.toUpperCase()),
                  isSquareShape: false,
                  action: () {
                    // setState(() {
                    //   _businessSelected = false;
                    // });
                  }),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: _Style.padding,
            ),
          ),
          Container(
            color: Theme.of(context)
                .copyWith(canvasColor: const Color.fromRGBO(33, 127, 125, 1.0))
                .canvasColor,
            height: _Style.separatorHeight,
            width: _Style.separatorWidth,
          ),
        ],
      ),
    );
  }

  Container _buildThirdSection({@required DrawerViewModel model}) {
    return Container(
        height: _Style.thirdSectionHeight,
        child: Column(
          children: <Widget>[
            _Style.defaultPadding,
            _GroupSettingsButton(
                Image.asset('assets/graphics/drawer/create_topic.png'), () {
              // TODO(richard): fix overflow when loading more than 7 businesses for now we are not alloing user to create more than2 business
              if (model.businesses.length >= 3) {
                // TODO(richard): show a toast here that we can not create additional business...
                return;
              }
              // TODO: implement adding a business and more than 5 business should show ... dots for expand also load business in viewmodel instead.
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

              final bool loggedOut = await ProxyService.sharedPref.logout();
              if (loggedOut) {
                ProxyService.database.logout(context: context);
              }
            },
          ),
          _Style.defaultPadding,
        ],
      ),
    );
  }

  Container _buildSecondSectionBusinessList(
      {@required DrawerViewModel model,
      BuildContext context,
      Business business}) {
    return Container(
      height: _Style.itemHeight,
      child: Padding(
        padding:
            const EdgeInsets.only(top: _Style.padding, right: _Style.padding),
        child: _GroupButton(
          business: model.business,
          onPressedCircle: (Business business) {
            model.switchBusiness(from: model.business, to: business);
          },
          isActive: true,
          hasUpdates: true,
        ),
      ),
    );
  }

  Widget getRenderableBusinessList(
      {List<Business> businesses,
      BuildContext context,
      DrawerViewModel model}) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < businesses.length; i++) {
      list.add(_buildSecondSectionBusinessList(
          context: context, model: model, business: businesses[i]));
    }
    return Expanded(
      child: Column(children: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, DrawerViewModel model, Widget child) {
          return Container(
            color: HexColor('#130f1f'),
            child: Column(
              children: <Widget>[
                _buildFirstSectionFlipperLogo(context: context, model: model),

                getRenderableBusinessList(
                    businesses: model.businesses,
                    context: context,
                    model: model),
                //setting on click set highlight on side.
                _buildThirdSection(model: model),
                _buildFourthSection(context)
              ],
            ),
          );
        },
        onModelReady: (DrawerViewModel model) {
          model.getBusiness();
          model.getBranches();
        },
        viewModelBuilder: () => DrawerViewModel());
  }
}

class _GroupSettingsButton extends StatelessWidget {
  const _GroupSettingsButton(
    this.image,
    this.onPressed, {
    Key key,
  }) : super(key: key);

  final Image image;
  final Function onPressed;

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
        ),
      ),
    );
  }
}

class _GroupButton extends StatelessWidget {
  const _GroupButton({
    @required this.business,
    @required this.onPressedCircle,
    this.isActive,
    this.hasUpdates,
    Key key,
  })  : assert(onPressedCircle != null),
        super(key: key);

  final Business business;
  final bool hasUpdates;
  final bool isActive;

  final Function(Business) onPressedCircle;

  @override
  Widget build(BuildContext context) {
    final HexColor _circleColor = Theme.of(context)
        .copyWith(canvasColor: HexColor('#f5a623'))
        .canvasColor;
    final String _groupText = business?.name?.substring(0, 1)?.toUpperCase();

    return Container(
      child: Row(
        children: <Widget>[
          ..._buildSelectionHighlight(business?.active, Colors.green),
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
  static const double circleHighlightBorderRadius = 10.0;
  static const double circleHighlightWidth = 4.0;
  static const double circleUnreadIndicatorWidth = 14.0;
  static const Padding defaultPadding =
      Padding(padding: EdgeInsets.only(top: padding));

  static const double firstSectionHeight = 100.0;
  static const double flipperButtonWidth = 44.0;
  static const double fourthSectionHeight = 180.0;
  static const double itemHeight = 52.0;
  static const double padding = 8.0;
  static const double separatorHeight = 2.0;
  static const double separatorWidth = 48.0;
  static const double thirdSectionHeight = 60.0;
}
