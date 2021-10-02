import 'package:flipper_dashboard/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_models/business.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FlipperDrawer extends StatefulWidget {
  FlipperDrawer(
      {Key? key,
      required this.preferenceController,
      required this.businesses,
      required this.addWorkSpace})
      : super(key: key);

  Function preferenceController;
  Function addWorkSpace;
  List<Business> businesses;

  @override
  State<FlipperDrawer> createState() => _FlipperDrawerState();
}

class _FlipperDrawerState extends State<FlipperDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _getLowerLayer(),
    );
  }

  Widget _getLowerLayer() {
    final Color _circleColor =
        Theme.of(context).copyWith(canvasColor: Colors.cyan).canvasColor;
    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const SizedBox(
              height: 60,
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text('Workspaces'),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            ...widget.businesses
                .map(
                  (business) => ListTile(
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
                    title: Text(business.name),
                    subtitle: Text(business.businessUrl ?? ''),
                    leading: CachedNetworkImage(
                      imageUrl: business.businessUrl ??
                          'http://via.placeholder.com/350x150',
                      placeholder: (context, url) => avatar(
                        color: _circleColor,
                        text: business.name.substring(0, 2),
                        action: () {
                          // onPressedCircle(business);
                        },
                        updateIndicatorVisible: true,
                        isSquareShape: true,
                        userIcon: null, //set to true by default
                      ),
                      errorWidget: (context, url, error) => avatar(
                        color: _circleColor,
                        text: business.name.substring(0, 2),
                        action: () {
                          // onPressedCircle(business);
                        },
                        updateIndicatorVisible: true,
                        isSquareShape: true,
                        userIcon: null, //set to true by default
                      ),
                    ),
                    trailing: const Icon(
                      Ionicons.people_outline,
                    ),
                    onTap: () {},
                  ),
                )
                .toList(),
          ],
        ),
        Positioned(
          bottom: 0.0,
          left: 20.0,
          right: 0.0,
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                title: const Text('Add a Workspace'),
                leading: const Icon(Icons.add),
                onTap: () {
                  widget.addWorkSpace();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                title: const Text('Preferences'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  widget.preferenceController();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                title: const Text('help'),
                leading: Icon(
                  Icons.help,
                ),
                onTap: () async {
                  const url = 'https://yegobox.com/terms';
                  if (await canLaunch(url)) {
                    await launch(url, forceSafariVC: false, forceWebView: true);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
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
