import 'package:flutter/material.dart';

class ItemRow extends StatefulWidget {
  const ItemRow({super.key});

  @override
  State<ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        height: 72,
        // color: Colors.red,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 3, bottom: 5),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 387,
                      height: 57,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 81.89,
                            top: 0,
                            child: SizedBox(
                              width: 84.13,
                              child: Text(
                                '4500 RWF',
                                style: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.5600000023841858),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 345.50,
                            top: 0,
                            child: SizedBox(
                              width: 41.50,
                              child: Text(
                                '05:12',
                                style: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.23999999463558197),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 87.50,
                    top: 27,
                    child: SizedBox(
                      width: 86.37,
                      child: Text(
                        '1 item sold',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.38999998569488525),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
