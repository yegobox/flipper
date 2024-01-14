import 'package:flipper_ui/src/shared/app_colors.dart';
import 'package:flipper_ui/src/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flipper_loading/indicator/ball_pulse_indicator.dart';
import 'package:flipper_loading/loading.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final double borderRadius;
  final Key? key;

  const BoxButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.busy = false,
    this.borderRadius = 8,
    this.onTap,
    this.leading,
  })  : outline = false,
        key = key,
        super(key: key);

  const BoxButton.outline({
    required this.title,
    this.onTap,
    this.leading,
    this.borderRadius = 8,
    Key? key,
  })  : disabled = false,
        busy = false,
        outline = true,
        key = key,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        key: key, // Use the provided key
        duration: Duration(milliseconds: 350),
        width: double.infinity,
        height: 60,
        alignment: Alignment.center,
        decoration: !outline
            ? BoxDecoration(
                color: !disabled ? kcPrimaryColor : kcMediumGreyColor,
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : BoxDecoration(
                color: const Color(0xff006AFE),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: const Color(0xff006AFE),
                  width: 1,
                ),
              ),
        child: !busy
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) leading!,
                  if (leading != null) SizedBox(width: 5),
                  Text(
                    title,
                    style: bodyStyle.copyWith(
                      color: !outline ? Colors.white : kcPrimaryColor,
                    ),
                  ),
                ],
              )
            : Loading(
                indicator: BallPulseIndicator(),
                size: 50.0,
                color: Colors.white,
              ),
      ),
    );
  }
}
