import 'package:flipper/ui/widget/custom_widgets.dart';
import 'package:flutter/material.dart';

const double ICON_OFF = -3;
const double ICON_ON = 0;
const double TEXT_OFF = 5;
const double TEXT_ON = 1;
const double ALPHA_OFF = 0;
const double ALPHA_ON = 1;
const int ANIM_DURATION = 300;

class TabItem extends StatelessWidget {
  const TabItem(
      {@required this.uniqueKey,
        @required this.selected,
        @required this.iconData,
        @required this.title,
        @required this.callbackFunction,
        @required this.textColor,
        @required this.iconColor,
        this.isCustomIcon,
        this.customIconCode});

  final UniqueKey uniqueKey;
  final String title;
  final IconData iconData;
  final bool selected;
  final Function(UniqueKey uniqueKey) callbackFunction;
  final Color textColor;
  final Color iconColor;
  final bool isCustomIcon;
  final int customIconCode;

  // ignore: avoid_field_initializers_in_const_classes
  final double iconYAlign = ICON_ON;
  // ignore: avoid_field_initializers_in_const_classes
  final double textYAlign = TEXT_OFF;
  // ignore: avoid_field_initializers_in_const_classes
  final double iconAlpha = ALPHA_ON;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedAlign(
                duration: const Duration(milliseconds: ANIM_DURATION),
                // ignore: unnecessary_parenthesis
                alignment: Alignment(0, (selected) ? TEXT_ON : TEXT_OFF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontSize: getDimention(context, 12)),
                  ),
                )),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedAlign(
              duration:const Duration(milliseconds: ANIM_DURATION),
              curve: Curves.easeIn,
              // ignore: unnecessary_parenthesis
              alignment: Alignment(0, (selected) ? ICON_OFF : ICON_ON),
              child: AnimatedOpacity(
                duration:const Duration(milliseconds: ANIM_DURATION),
                // ignore: unnecessary_parenthesis
                opacity: (selected) ? ALPHA_OFF : ALPHA_ON,
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding:const EdgeInsets.all(0),
                  alignment:const Alignment(0, 0),
                  icon: isCustomIcon
                      ? customIcon(context, icon: customIconCode)
                      : Icon(
                    iconData,
                    color: iconColor,
                  ),
                  onPressed: () {
                    callbackFunction(uniqueKey);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
