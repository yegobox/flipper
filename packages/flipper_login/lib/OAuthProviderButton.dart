// 1. First, let's define an improved OAuthProviderButton widget
// import 'package:flipper_login/apple_logo_painter.dart';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
// import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OAuthProviderButton extends StatelessWidget {
  final OAuthButtonVariant variant;
  final VoidCallback onPressed;
  final String iconPath;
  final Widget? customIcon;
  final String? text;
  final bool isLoading;

  const OAuthProviderButton({
    Key? key,
    required this.variant,
    required this.onPressed,
    this.iconPath = '',
    this.customIcon,
    this.text,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 368,
      height: 68,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.withOpacity(0.1)),
            ),
          ),
          child: isLoading
              ? LoadingAnimationWidget.fallingDot(
                  color: Colors.blueGrey,
                  size: 24,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (variant == OAuthButtonVariant.icon ||
                        variant == OAuthButtonVariant.iconAndText)
                      customIcon ??
                          (iconPath.isNotEmpty
                              ? SvgPicture.asset(
                                  iconPath,
                                  package: 'flipper_login',
                                  width: 24,
                                  height: 24,
                                )
                              : SizedBox()),
                    if (variant == OAuthButtonVariant.iconAndText &&
                        text != null)
                      SizedBox(width: 12),
                    if (variant == OAuthButtonVariant.text ||
                        variant == OAuthButtonVariant.iconAndText)
                      Text(
                        text ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

enum OAuthButtonVariant {
  icon,
  text,
  iconAndText,
}

