import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AddProductButtons extends StatefulWidget {
  const AddProductButtons({Key? key}) : super(key: key);

  @override
  State<AddProductButtons> createState() => _AddProductButtonsState();
}

class _AddProductButtonsState extends State<AddProductButtons> {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 62, left: 58, right: 58),
                child: Container(
                    color: Colors.white70,
                    width: double.infinity,
                    height: 64,
                    child: FlipperButton(
                      text: "Add Product",
                      onPressed: () {
                        _routerService.navigateTo(AddProductViewRoute());
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 31, left: 58, right: 58, bottom: 20),
                child: Container(
                  width: double.infinity,
                  height: 64,
                  child: FlipperButtonFlat(
                    text: 'Dismiss',
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
