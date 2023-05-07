// ignoreforfile: constantidentifiernames

library customappbar;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flipper_ui.dart';

enum CLOSEBUTTON { ICON, BUTTON }

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.showActionButton,
    this.title,
    this.icon,
    this.additionalText,
    this.disableButton,
    this.onActionButtonClicked,
    this.onPop,
    this.rightActionButtonName = "Save",
    this.leftActionButtonName = "Save",
    this.closeButton = CLOSEBUTTON.ICON,
    this.useTransparentButton = false,
    this.multi,
    this.bottomSpacer,
  });

  final String? rightActionButtonName;
  final String? leftActionButtonName;
  final CLOSEBUTTON closeButton;
  final double? bottomSpacer;
  final bool? disableButton;
  final double? multi;
  final IconData? icon;
  final VoidCallback? onPop;
  final VoidCallback? onActionButtonClicked;
  final bool? showActionButton;
  final String? title;
  final bool useTransparentButton;

  final Widget? additionalText;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(64.0 * (multi == null ? 0.8 : multi!));
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: SizedBox(
        height: widget.bottomSpacer,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: widget.closeButton == CLOSEBUTTON.ICON
                  ? IconButton(
                      icon: Icon(
                        widget.icon ?? Icons.close,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: widget.onPop,
                    )
                  : FLipperButton(
                      transparent: widget.useTransparentButton,
                      disableButton: widget.disableButton ?? false,
                      onPressedCallback: widget.onPop ?? () {},
                      buttonName: widget.leftActionButtonName ?? '',
                    ),
              title: widget.title == null
                  ? const SizedBox.shrink()
                  : Text(
                      widget.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
              trailing: widget.showActionButton == null ||
                      !widget.showActionButton!
                  ? const SizedBox.shrink()
                  : FLipperButton(
                      transparent: widget.useTransparentButton,
                      disableButton: widget.disableButton ?? false,
                      onPressedCallback: widget.onActionButtonClicked ?? () {},
                      buttonName: widget.rightActionButtonName ?? "Save",
                    ),
              dense: true,
            ),
            Container(
              child: widget.additionalText,
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
