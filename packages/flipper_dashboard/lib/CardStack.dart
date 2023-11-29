import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

class CardStack extends StatefulWidget {
  const CardStack({
    Key? key,
    required this.products,
    required this.colors,
  })  : assert(products.length == colors.length),
        super(key: key);

  final List<Variant> products;
  final List<Color> colors;

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  int topIndex = 0;
  int displayIndex = 0;

  void onTap(int index) {
    setState(() {
      // Move the tapped color to the top of the list
      widget.colors.insert(0, widget.colors.removeAt(index));
      // Reset the topIndex to always tap the new top card
      topIndex = 0;

      // Calculate the correct displayIndex after rotation
      displayIndex = (displayIndex + 1) % widget.products.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 100,
            child: Text(
              "500 RWF",
              style: TextStyle(fontSize: 40),
            ),
          ),
          ...List.generate(
            widget.colors.length,
            (index) {
              double rotation = (index - topIndex) * 0.2;

              return Positioned(
                top: 250,
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Transform.rotate(
                    angle: rotation,
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: widget.colors[index],
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          widget.products[displayIndex].name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
