import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTitleText(String title, {required BuildContext context}) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.black87,
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
  );
}

Widget heading(String heading,
    {double horizontalPadding = 10, required BuildContext context}) {
  double fontSize = 16;
  fontSize = getDimention(context, 16);
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Text(
      heading,
      style: Theme.of(context)
          .typography
          .dense
          .bodyMedium!
          .copyWith(fontSize: fontSize),
    ),
  );
}

Widget userImage(String path, {double height = 100}) {
  return Container(
    child: Container(
      width: height,
      height: height,
      alignment: FractionalOffset.topCenter,
      decoration: BoxDecoration(
        // boxShadow: shadow,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(height / 2),
        image: DecorationImage(image: NetworkImage(path)),
      ),
    ),
  );
}

Widget customIcon(
  BuildContext context, {
  int? icon,
  bool isEnable = false,
  double size = 18,
  bool istwitterIcon = true,
  bool isFontAwesomeRegular = false,
  bool isFontAwesomeSolid = false,
  Color? iconColor,
  double paddingIcon = 0,
  String text = '',
  Function? onPressed,
}) {
  iconColor = iconColor ?? Theme.of(context).textTheme.bodyMedium!.color;

  return GestureDetector(
    onTap: () {
      if (onPressed != null) {
        onPressed();
      }
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
      child: Column(
        children: [
          Container(
            height: 10,
            child: Icon(
              IconData(
                icon!,
                fontFamily: istwitterIcon
                    ? 'TwitterIcon'
                    : isFontAwesomeRegular
                        ? 'AwesomeRegular'
                        : isFontAwesomeSolid
                            ? 'AwesomeSolid'
                            : 'Fontello',
              ),
              size: size,
              color: isEnable ? Theme.of(context).primaryColor : iconColor,
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.only(top: 10),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget customBottomIcon(BuildContext context,
    {Image? icon,
    bool isEnable = false,
    double size = 18,
    bool istwitterIcon = true,
    bool isFontAwesomeRegular = false,
    bool isFontAwesomeSolid = false,
    Color? iconColor,
    double paddingIcon = 0,
    String text = ''}) {
  iconColor = iconColor ?? Theme.of(context).textTheme.bodyMedium!.color;
  return Padding(
    padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
    child: Column(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Container(
            child: icon,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.only(top: 5),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget customTappbleIcon(BuildContext context, int icon,
    {double size = 16,
    bool isEnable = false,
    required Function(bool, int) onPressed1,
    bool? isBoolValue,
    int? id,
    Function? onPressed2,
    bool isFontAwesomeRegular = false,
    bool istwitterIcon = false,
    bool isFontAwesomeSolid = false,
    Color? iconColor,
    EdgeInsetsGeometry? padding}) {
  padding ??= EdgeInsets.all(10);
  return MaterialButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minWidth: 10,
    height: 10,
    padding: padding,
    shape: const CircleBorder(),
    color: Colors.transparent,
    elevation: 0,
    onPressed: () {
      onPressed1(isBoolValue!, id!);
    },
    child: customIcon(context,
        icon: icon,
        size: size,
        isEnable: isEnable,
        istwitterIcon: istwitterIcon,
        isFontAwesomeRegular: isFontAwesomeRegular,
        isFontAwesomeSolid: isFontAwesomeSolid,
        iconColor: iconColor),
  );
}

Widget customText(String? msg,
    {required TextStyle style,
    TextAlign textAlign = TextAlign.justify,
    TextOverflow overflow = TextOverflow.visible,
    required BuildContext context,
    bool softwrap = true}) {
  if (msg == null) {
    return SizedBox(
      height: 0,
      width: 0,
    );
  } else {
    final double? fontSize =
        style.fontSize ?? Theme.of(context).textTheme.bodySmall!.fontSize;
    style = style.copyWith(
      fontSize: fontSize! - (fullWidth(context) <= 375 ? 2 : 0),
    );
    return Text(
      msg,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softwrap,
      // key: key,
    );
  }
}

Widget customImage(
  BuildContext context,
  String path, {
  double height = 50,
  bool isBorder = false,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey.shade100, width: isBorder ? 2 : 0),
    ),
    child: CircleAvatar(
      maxRadius: height / 2,
      backgroundColor: Theme.of(context).cardColor,
      backgroundImage: customAdvanceNetworkImage(path),
    ),
  );
}

double fullWidth(BuildContext context) {
  // cprint(MediaQuery.of(context).size.width.toString());
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget customInkWell(
    {required Widget child,
    required BuildContext context,
    Function(bool, int)? function1,
    Function? onPressed,
    bool isEnable = false,
    int no = 0,
    Color color = Colors.transparent,
    Color? splashColor,
    BorderRadius? radius}) {
  splashColor ??= Theme.of(context).primaryColorLight;
  radius ??= BorderRadius.circular(0);
  return Material(
    color: color,
    child: InkWell(
      borderRadius: radius,
      onTap: () {
        if (function1 != null) {
          function1(isEnable, no);
        } else if (onPressed != null) {
          onPressed();
        }
      },
      splashColor: splashColor,
      child: child,
    ),
  );
}

SizedBox sizedBox({double height = 5, String? title}) {
  return SizedBox(
    height: title == null || title.isEmpty ? 0 : height,
  );
}

Widget customNetworkImage(String path, {BoxFit fit = BoxFit.contain}) {
  return CachedNetworkImage(
    fit: fit,
    imageUrl: path,
    imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) =>
        Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    ),
    placeholderFadeInDuration: const Duration(milliseconds: 500),
    placeholder: (BuildContext context, String url) => Container(
      color: const Color(0xffeeeeee),
    ),
    // ignore: always_specify_types
    errorWidget: (BuildContext context, String url, error) =>
        const Icon(Icons.error),
  );
}

dynamic customAdvanceNetworkImage(String path) {
  return CachedNetworkImageProvider(
    path,
  );
}

void showAlert(BuildContext context,
    {required Function onPressedOk,
    required String title,
    String okText = 'OK',
    String cancelText = 'Cancel'}) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return customAlert(context,
            onPressedOk: onPressedOk,
            title: title,
            okText: okText,
            cancelText: cancelText);
      });
}

Widget customAlert(BuildContext context,
    {required Function onPressedOk,
    required String title,
    String okText = 'OK',
    String cancelText = 'Cancel'}) {
  return AlertDialog(
    title: Text('Alert',
        style: TextStyle(
            fontSize: getDimention(context, 25), color: Colors.black54)),
    content: Text(title, style: const TextStyle(color: Colors.black45)),
    actions: <Widget>[
      TextButton(
        style: primaryButtonStyle,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          cancelText,
          style: TextStyle(color: Colors.white),
        ),
      ),
      TextButton(
        style: secondaryButtonStyle,
        onPressed: () {
          Navigator.pop(context);
          onPressedOk();
        },
        child: Text(okText),
      )
    ],
  );
}

void customSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String msg,
    {double height = 30, Color backgroundColor = Colors.black}) {
  if (_scaffoldKey.currentState == null) {
    return;
  }
  SnackBar(
    backgroundColor: backgroundColor,
    content: Text(
      msg,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

Widget emptyListWidget(BuildContext context, String title,
    {required String subTitle, String image = 'emptyImage.png'}) {
  return Container(
    color: const Color(0xfffafafa),
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: fullWidth(context) * .95,
            height: fullWidth(context) * .95,
            decoration: const BoxDecoration(
              // color: Color(0xfff1f3f6),
              boxShadow: <BoxShadow>[
                // BoxShadow(blurRadius: 50,offset: Offset(0, 0),color: Color(0xffe2e5ed),spreadRadius:20),
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Color(0xffe2e5ed),
                ),
                BoxShadow(
                    blurRadius: 50,
                    offset: Offset(10, 0),
                    color: Color(0xffffffff),
                    spreadRadius: -5),
              ],
              shape: BoxShape.circle,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/$image', height: 170),
              const SizedBox(
                height: 20,
              ),
              customText(
                title,
                context: context,
                style: Theme.of(context)
                    .typography
                    .dense
                    .bodyMedium!
                    .copyWith(color: const Color(0xff9da9c7)),
              ),
              customText(
                subTitle,
                context: context,
                style: Theme.of(context)
                    .typography
                    .dense
                    .bodyMedium!
                    .copyWith(color: const Color(0xffabb8d6)),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget loader() {
  if (Platform.isIOS) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  } else {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}

Widget customSwitcherWidget(
    {@required child, Duration duraton = const Duration(milliseconds: 500)}) {
  return AnimatedSwitcher(
    duration: duraton,
    transitionBuilder: (Widget child, Animation<double> animation) {
      return ScaleTransition(child: child, scale: animation);
    },
    child: child,
  );
}

double getDimention(context, double unit) {
  if (fullWidth(context) <= 360.0) {
    return unit / 1.3;
  } else {
    return unit;
  }
}

openImagePicker(BuildContext context, Function onImageSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            const Text(
              'Pick an image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused))
                          return Theme.of(context).primaryColor;
                        return Theme.of(context)
                            .primaryColor; // Defer to the widget's default.
                      }),
                    ),
                    child: Text(
                      'Use Camera',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused))
                          return Theme.of(context).primaryColor;
                        return Theme.of(context)
                            .primaryColor; // Defer to the widget's default.
                      }),
                    ),
                    child: Text(
                      'Use Gallery',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
  );
}
