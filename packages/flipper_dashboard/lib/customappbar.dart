// ignoreforfile: constantidentifiernames

library customappbar;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flipper_ui.dart';

enum CLOSEBUTTON { ICON, BUTTON, WIDGET }

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
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
      this.customLeadingWidget,
      this.bottomWidget,
      this.customTrailingWidget,
      this.isDividerVisible});

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
  final StatelessWidget? customLeadingWidget;
  final StatelessWidget? bottomWidget;
  final StatelessWidget? customTrailingWidget;
  final bool? isDividerVisible;

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
        child: Wrap(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: buildLeading(),
              title: widget.title == null
                  ? const SizedBox.shrink()
                  : Text(
                      widget.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
              trailing: buildTrailing(),
              dense: true,
            ),
            Container(
              child: widget.additionalText,
            ),
            Visibility(
                visible: widget.isDividerVisible ?? true,
                child: const Expanded(
                  child: Divider(
                    thickness: 0.5,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildTrailing() {
    if (widget.customTrailingWidget != null) {
      return widget.customTrailingWidget!;
    }

    return widget.showActionButton == null || !widget.showActionButton!
        ? SizedBox.shrink()
        : FLipperButton(
            transparent: widget.useTransparentButton,
            disableButton: widget.disableButton ?? false,
            onPressedCallback: widget.onActionButtonClicked ?? () {},
            buttonName: widget.rightActionButtonName ?? "Save",
          );
  }

  StatelessWidget buildLeading() {
    switch (widget.closeButton) {
      case CLOSEBUTTON.WIDGET:
        return widget.customLeadingWidget!;
      case CLOSEBUTTON.ICON:
        return IconButton(
          icon: Icon(
            widget.icon ?? Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: widget.onPop,
        );
      case CLOSEBUTTON.BUTTON:
        return FLipperButton(
          transparent: widget.useTransparentButton,
          disableButton: widget.disableButton ?? false,
          onPressedCallback: widget.onPop ?? () {},
          buttonName: widget.leftActionButtonName ?? '',
        );
      default:
        return Container(
          width: 0,
          height: 0,
        );
    }
  }
}
