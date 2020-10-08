library customappbar;

import 'package:flipper_ui/flipper_ui.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:google_fonts/google_fonts.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  // @Deprecated("_action will be removed soon")
  final Widget _additionalText;
  final bool _showActionButton;

  final String _title;
  final String _actionButtonName;

  final IconData _icon;
  final double _headerMultiplier;
  final double _bottomSpacer;
  final Function _onPressedCallback;
  final Function _onPop;
  final bool _disableButton;
  const CommonAppBar({
    Widget action,
    bool showActionButton,
    @required String title,
    IconData icon,
    double multi,
    double bottomSpacer,
    bool disableButton,
    Function onPressedCallback,
    Function onPop,
    String actionButtonName,
    Key key,
  })  : _additionalText = action,
        _showActionButton = showActionButton,
        _title = title,
        _icon = icon,
        _headerMultiplier = multi,
        _bottomSpacer = bottomSpacer,
        _disableButton = disableButton,
        _onPressedCallback = onPressedCallback,
        _onPop = onPop,
        _actionButtonName = actionButtonName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
          height: _bottomSpacer,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.5),
                leading: IconButton(
                  icon: Icon(
                    _icon ?? Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: _onPop,
                ),
                title: _title == null
                    ? Text("")
                    : Text(
                        _title,
                        overflow: TextOverflow.ellipsis,
                        // style: AppTheme.appBarTitleTextStyle,
                        style: GoogleFonts.lato(
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(0, 0, 0, 1.0),
                          fontSize: 20,
                        ),
                      ),
                trailing: _showActionButton == null || !_showActionButton
                    ? Text("")
                    : Button(
                        disableButton: _disableButton,
                        onPressedCallback: _onPressedCallback,
                        buttonName: _actionButtonName ?? "",
                      ),
                dense: true,
              ),
              Container(
                child: _additionalText,
              ),
              Expanded(
                child: Divider(
                  color: Colors
                      .black, //TODO(richard): tweak this divider so it can be visible
                ),
              )
            ],
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(
      64.0 * (_headerMultiplier == null ? 0.8 : _headerMultiplier));
}
