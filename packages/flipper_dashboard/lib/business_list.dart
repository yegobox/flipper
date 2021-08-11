import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flipper_models/business.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessList extends StatelessWidget {
  const BusinessList({Key? key, required this.businesses}) : super(key: key);
  final List<Business> businesses;

  Widget _buildFirstSectionFlipperLogo({required BuildContext context}) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              // ..._buildSelectionHighlight(
              //     isSelected: false, circleColor: Colors.white),
              const SizedBox(height: 70),
              Container(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/fliper-logo.png'))
              // _selectableListItem(
              //   userIcon: Image.asset('assets/fliper-logo.png'),
              //   // userIcon: Text(
              //   //   "Hello World".length > 2
              //   //       ? "Hello World".substring(0, 3).toUpperCase()
              //   //       : "Hello World".toUpperCase(),
              //   // ),
              //   isSquareShape: false,
              //   action: () {},
              // ),
            ]),
          ),
          // const SizedBox(height: 3),
          // Container(
          //   color: Theme.of(context)
          //       .copyWith(
          //         canvasColor: const Color.fromRGBO(33, 127, 125, 1.0),
          //       )
          //       .canvasColor,
          //   height: _Style.separatorHeight,
          //   width: _Style.separatorWidth,
          // ),
        ],
      ),
    );
  }

  Container _buildThirdSection() {
    return Container(
        height: _Style.thirdSectionHeight,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            _Style.defaultPadding,
            // TODO: future feature
            // _GroupSettingsButton(
            //     image: Image.asset('assets/graphics/drawer/create_topic.png'),
            //     onPressed: () {
            //       // TODO(richard): fix overflow when loading more than 7 businesses for now we are not alloing user to create more than2 business
            //       if (model.businesses.length >= 3) {
            //         // TODO(richard): show a toast here that we can not create additional business...
            //         return;
            //       }
            //       // TODO: implement adding a business and more than 5 business should show ... dots for expand also load business in viewmodel instead.
            //       // TODO(richard): will suport creation of business within app in 2 years
            //       // _navigationService.navigateTo(Routing.createBusiness);
            //     }),
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
            onPressed: () async {
              // _openUserAccount(context);
              // TODO(richard): change the icon should be icon of logout.

              // final bool loggedOut = ProxyService.sharedPref.logout();
              // if (loggedOut) {
              // ProxyService.database.logout(context: context);
              // }
            },
          ),
          _Style.defaultPadding,
        ],
      ),
    );
  }

  Container _buildSecondSectionBusinessList(
      {required BuildContext context, required Business business}) {
    return Container(
      height: _Style.itemHeight,
      child: Padding(
        padding: EdgeInsets.only(right: _Style.padding),
        child: _GroupButton(
          business: business,
          onPressedCircle: (Business business) {
            // model.switchBusiness(from: model.business, to: business);
          },
          isActive: true,
          hasUpdates: true,
        ),
      ),
    );
  }

  Widget getRenderableBusinessList({
    required List<Business> businesses,
    required BuildContext context,
  }) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < businesses.length; i++) {
      list.add(_buildSecondSectionBusinessList(
          context: context, business: businesses[i]));
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: HexColor('#130f1f'),
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                // _buildFirstSectionFlipperLogo(context: context),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: getRenderableBusinessList(
                    businesses: businesses,
                    context: context,
                  ),
                ),
                _buildThirdSection(),
              ],
            ),
            // Positioned(bottom: 0.0, child: _buildFourthSection(context))
          ],
        ),
      ),
    );
  }
}

class _GroupSettingsButton extends StatelessWidget {
  const _GroupSettingsButton({Key? key, this.image, required this.onPressed})
      : super(key: key);
  final Image? image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // print(businesses);

    return Container(
      width: _Style.flipperButtonWidth,
      height: _Style.flipperButtonWidth,
      child: FittedBox(
        fit: BoxFit.cover,
        child: image == null
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.signOutAlt),
                onPressed: onPressed,
              )
            : FlatButton(
                shape: const CircleBorder(),
                child: image!,
                onPressed: onPressed,
              ),
      ),
    );
  }
}

class _GroupButton extends StatelessWidget {
  const _GroupButton({
    required this.business,
    required this.onPressedCircle,
    this.isActive = false,
    this.hasUpdates = false,
    Key? key,
  }) : super(key: key);

  final Business business;
  final bool hasUpdates;
  final bool isActive;

  final Function(Business) onPressedCircle;

  @override
  Widget build(BuildContext context) {
    final Color _circleColor = Theme.of(context)
        .copyWith(canvasColor: HexColor('#f5a623'))
        .canvasColor;
    final String? _groupText = business.name.substring(0, 1).toUpperCase();

    return Container(
      child: Row(
        children: <Widget>[
          ..._buildSelectionHighlight(
              isSelected: false, circleColor: Colors.green),
          _selectableListItem(
            color: _circleColor,
            text: _groupText,
            action: () {
              onPressedCircle(business);
            },
            updateIndicatorVisible: hasUpdates,
            isSquareShape: true, userIcon: null, //set to true by default
          ),
        ],
      ),
    );
  }
}

AnimatedContainer _selectableListItem({
  Color color = Colors.white,
  String? text = '',
  Widget? userIcon,
  required VoidCallback action,
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
      clipBehavior: Clip.none,
      children: <Widget>[
        InkWell(
          child: Container(
            alignment: const Alignment(0, 0),
            width: _Style.flipperButtonWidth,
            height: _Style.flipperButtonWidth,
            child: userIcon == null ? Text(text!) : userIcon,
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
List<Widget> _buildSelectionHighlight(
    {required bool isSelected, required Color circleColor}) {
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
      ),
    );
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
  static Padding defaultPadding =
      Padding(padding: EdgeInsets.only(top: padding));

  // ignore: unused_field
  static const double firstSectionHeight = 100.0;
  static const double flipperButtonWidth = 44.0;
  static const double fourthSectionHeight = 180.0;
  static const double itemHeight = 52.0;
  static double padding = 8.w;
  static const double separatorHeight = 2.0;
  static const double separatorWidth = 48.0;
  static const double thirdSectionHeight = 60.0;
}
