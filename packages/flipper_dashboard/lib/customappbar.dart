library customappbar;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'flipper_ui.dart';

enum CLOSEBUTTON { ICON, BUTTON }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Widget? action,
    bool? showActionButton,
    String? title,
    IconData? icon,
    double? multi,
    double? bottomSpacer,
    bool? disableButton,
    VoidCallback? onPressedCallback,
    VoidCallback? onPop,
    String? rightActionButtonName,
    String? leftActionButtonName,
    CLOSEBUTTON closeButton = CLOSEBUTTON.ICON,
    bool useTransparentButton = false,
    Key? key,
  })  : _additionalText = action,
        _showActionButton = showActionButton,
        _title = title,
        _icon = icon,
        _headerMultiplier = multi,
        _bottomSpacer = bottomSpacer,
        _disableButton = disableButton,
        _onPressedCallback = onPressedCallback,
        _onPop = onPop,
        _rightActionButtonName = rightActionButtonName,
        _leftActionButtonName = leftActionButtonName,
        _closeButton = closeButton,
        _useTransparentButton = useTransparentButton,
        super(key: key);

  final String? _rightActionButtonName;
  final String? _leftActionButtonName;
  final CLOSEBUTTON _closeButton;
  final double? _bottomSpacer;
  final bool? _disableButton;
  final double? _headerMultiplier;
  final IconData? _icon;
  final VoidCallback? _onPop;
  final VoidCallback? _onPressedCallback;
  final bool? _showActionButton;
  final String? _title;
  final bool _useTransparentButton;

  @override
  Size get preferredSize => Size.fromHeight(
      64.0 * (_headerMultiplier == null ? 0.8 : _headerMultiplier!));

  // @Deprecated("_action will be removed soon")
  final Widget? _additionalText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        height: _bottomSpacer,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.5),
              leading: _closeButton == CLOSEBUTTON.ICON
                  ? IconButton(
                      icon: Icon(
                        _icon ?? Icons.close,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: _onPop,
                    )
                  : FLipperButton(
                      transparent: _useTransparentButton,
                      disableButton: _disableButton ?? false,
                      onPressedCallback: _onPop ?? () {},
                      buttonName: _leftActionButtonName ?? '',
                    ),
              title: _title == null
                  ? const SizedBox.shrink()
                  : Text(
                      _title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontStyle: FontStyle.normal,
                        color: const Color.fromRGBO(0, 0, 0, 1.0),
                        fontSize: 20,
                      ),
                    ),
              trailing: _showActionButton == null || !_showActionButton!
                  ? const SizedBox.shrink()
                  : FLipperButton(
                      transparent: _useTransparentButton,
                      disableButton: _disableButton ?? false,
                      onPressedCallback: _onPressedCallback ?? () {},
                      buttonName: _rightActionButtonName ?? '',
                    ),
              dense: true,
            ),
            Container(
              child: _additionalText,
            ),
            const Expanded(
              child: Divider(),
            )
          ],
        ),
      ),
    );
  }
}
