import 'package:flipper_models/states/productListProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipe_to_complete/view/swiper_widget.dart';

import 'CardStack.dart';

class Comfirm extends StatefulHookConsumerWidget {
  const Comfirm({super.key});
  @override
  _ComfirmState createState() => _ComfirmState();
}

class _ComfirmState extends ConsumerState<Comfirm>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(productColorsProvider);
    final products = ref.watch(cartListProvider);
    return Scaffold(
      body: Stack(
        children: [
          CardStack(
            colors: colors,
            products: products,
          ),
          Align(
            alignment: const Alignment(0.0, 0.9),
            child: Builder(
              builder: (context) {
                return NewSwiper(
                  type: SwiperType.horizontal,
                  callback: () {
                    ///TODO: complete this order ready for send to supplier
                    /// take current Transaction update it with supplier Id from whom
                    /// we are ordering from
                    /// when approving order, the approver change TransactionType to
                    /// orderOnline so that it is a cash in for him and cash out for retailer
                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return Text("hello bottom");
                      },
                    );
                  },
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
