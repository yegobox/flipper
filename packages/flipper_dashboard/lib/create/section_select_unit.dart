import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:go_router/go_router.dart';

class SectionSelectUnit extends StatelessWidget {
  const SectionSelectUnit({Key? key, required this.product, required this.type})
      : super(key: key);
  final ProductSync product;
  final String type;
  Text unitSelector(ProductSync units) {
    late Text text = const Text('Select Unit');

    if (product.unit != '') {
      text = Text(product.unit);
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).go(Routes.units + "/$type");
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.4),
            dense: true,
            leading: const Text('Unit Type'),
            trailing: Wrap(
              children: [
                unitSelector(product),
                Theme(
                  data: ThemeData(
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
