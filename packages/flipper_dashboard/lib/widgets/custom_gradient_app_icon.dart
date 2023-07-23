import 'package:flutter/material.dart';

class CustomGradientAppIcon extends StatelessWidget {
  const CustomGradientAppIcon(
      {super.key,
      required this.icon,
      required this.gradientColorOne,
      required this.gradientColorTwo,
      this.sideSize = 59.0});

  final IconData icon;
  final Color gradientColorOne;
  final Color gradientColorTwo;
  final double sideSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          width: sideSize,
          height: sideSize,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: sideSize,
                  height: sideSize,
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.00009999999747378752),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: sideSize,
                  height: sideSize,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                        colors: [gradientColorOne, gradientColorTwo],
                        stops: [0.25, 0.9],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.12,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: sideSize,
                          height: sideSize,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.12,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: sideSize,
                                  height: sideSize,
                                  child: SizedBox(
                                    child: Icon(
                                      icon,
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          gradientColorOne,
                                          gradientColorTwo
                                        ],
                                        stops: [
                                          0.25,
                                          0.9
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(width: sideSize, height: sideSize),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
