import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to_complete/view/swiper_widget.dart';

import 'CardStack.dart';

class Confirm extends StatefulWidget {
  const Confirm({super.key, required this.colors, required this.products});
  final List<Color> colors;
  final List<Variant> products;
  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CardStack(
            colors: widget.colors,
            products: widget.products,
          ),
          Align(
            alignment: const Alignment(0.0, 0.9),
            child: Builder(
              builder: (context) {
                return NewSwiper(
                  type: SwiperType.horizontal,
                  callback: () => showBottomSheet(
                    context: context,
                    builder: (context) {
                      return Text("hello bottom");
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
