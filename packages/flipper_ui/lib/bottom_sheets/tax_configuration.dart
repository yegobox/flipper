import 'package:flutter/material.dart';

taxConfiguration({
  required BuildContext context,
  required Widget header,
  required List<Widget> body,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              child: AnimatedContainer(
                alignment: AlignmentDirectional.topCenter,
                duration: const Duration(seconds: 2),
                curve: Curves.elasticOut,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: [header, ...body]),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
