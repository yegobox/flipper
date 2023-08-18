import 'package:cached_network_image/cached_network_image.dart';
import 'package:flipper_ui/helpers/hex.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';

class _Style {
  static const double circleUnreadIndicatorWidth = 14.0;
  // ignore: unused_field
  static const double firstSectionHeight = 100.0;
  static const double flipperButtonWidth = 44.0;
}

AnimatedContainer avatar({
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
          BorderRadius.all(Radius.circular(isSquareShape ? 2.0 : 22.0)),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        InkWell(
          child: Container(
            alignment: const Alignment(0, 0),
            width: _Style.flipperButtonWidth,
            height: _Style.flipperButtonWidth,
            child: userIcon ?? Text(text!),
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

Widget avatarBuilder(Business business, Color _circleColor) {
  return business.businessUrl == null
      ? avatar(
          color: _circleColor,
          text: business.name!.length >= 2
              ? business.name!.toUpperCase().substring(0, 2)
              : business.name!.toUpperCase(),
          action: () {
            // onPressedCircle(business);
          },
          updateIndicatorVisible: true,
          isSquareShape: true,
          userIcon: null, //set to true by default
        )
      : CachedNetworkImage(
          /// if business.businessUrl then pass fake url to fallback to default.
          imageUrl: business.businessUrl!,
          placeholder: (context, url) => avatar(
            color: _circleColor,
            text: business.name!.length >= 2
                ? business.name!.toUpperCase().substring(0, 2)
                : business.name!.toUpperCase(),
            action: () {
              // onPressedCircle(business);
            },
            updateIndicatorVisible: true,
            isSquareShape: true,
            userIcon: null, //set to true by default
          ),
          errorWidget: (context, url, error) => avatar(
            color: _circleColor,
            text: business.name!.length >= 2
                ? business.name!.toUpperCase().substring(0, 2)
                : business.name!.toUpperCase(),
            action: () {
              // onPressedCircle(business);
            },
            updateIndicatorVisible: true,
            isSquareShape: true,
            userIcon: null, //set to true by default
          ),
        );
}
