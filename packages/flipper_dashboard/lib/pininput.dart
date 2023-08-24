import 'package:flipper_models/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OnlyBottomCursor extends StatefulWidget {
  const OnlyBottomCursor({Key? key, required this.model}) : super(key: key);

  final HomeViewModel model;

  @override
  _OnlyBottomCursorState createState() => _OnlyBottomCursorState();

  @override
  String toStringShort() => 'With Bottom Cursor';
}

class _OnlyBottomCursorState extends State<OnlyBottomCursor> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(30, 60, 87, 1);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: const BoxDecoration(),
    );

    final cursor = Container(
      width: 56,
      height: 3,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final preFilledWidget = Container(
      width: 56,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Pinput(
      length: 5,
      pinAnimationType: PinAnimationType.slide,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      showCursor: true,
      obscureText: true,
      cursor: cursor,
      preFilledWidget: preFilledWidget,
      onCompleted: (value) => widget.model.weakUp(pin: value),
    );
  }
}
