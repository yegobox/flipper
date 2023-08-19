import 'package:flipper_ui/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flipper_models/isar_models.dart';

class BusinessSettingButton extends StatelessWidget {
  const BusinessSettingButton({Key? key, this.image, required this.onPressed})
      : super(key: key);
  final Image? image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // print(businesses);

    return SizedBox(
      width: _Style.flipperButtonWidth,
      height: _Style.flipperButtonWidth,
      child: FittedBox(
        fit: BoxFit.cover,
        child: image == null
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.signOutAlt),
                onPressed: onPressed,
              )
            : TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused))
                      return Colors.red;
                    return null; // Defer to the widget's default.
                  }),
                ),
                // shape: const CircleBorder(),
                child: image!,
                onPressed: onPressed,
              ),
      ),
    );
  }
}

class BusinessButton extends StatelessWidget {
  const BusinessButton({
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
    final String? _groupText = business.name!.substring(0, 3).toUpperCase();

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ..._buildSelectionHighlight(
              isSelected: true, circleColor: Colors.green),
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

// ignore: always_specify_types
List<Widget> _buildSelectionHighlight(
    {required bool isSelected, required Color circleColor}) {
  final List<Widget> widgets = [];
  if (isSelected) {
    final ClipRRect highlight = ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(
          _Style.circleHighlightBorderRadius,
        ),
        bottomRight: Radius.circular(
          _Style.circleHighlightBorderRadius,
        ),
      ),
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
  static double padding = 8;
  static const double separatorHeight = 2.0;
  static const double separatorWidth = 48.0;
  static const double thirdSectionHeight = 60.0;
}
