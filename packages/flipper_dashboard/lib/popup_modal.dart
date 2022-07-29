import 'package:flutter/material.dart';
import 'custom_rect_tween.dart';

const String addProductHero = 'addProductHero';

/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [OptionModal].

class OptionModal extends StatefulWidget {
  const OptionModal({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<OptionModal> createState() => _OptionModalState();
}

class _OptionModalState extends State<OptionModal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Hero(
          tag: addProductHero,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: SingleChildScrollView(
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
