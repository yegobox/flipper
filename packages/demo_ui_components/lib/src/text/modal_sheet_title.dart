import 'package:flutter/material.dart';

class ModalSheetTitle extends StatelessWidget {
  const ModalSheetTitle(this.text,
      {this.textAlign = TextAlign.start, super.key});

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        textAlign: textAlign,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
