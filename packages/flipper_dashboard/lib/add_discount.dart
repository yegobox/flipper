import 'package:flipper_dashboard/create/build_image_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';

class AddDiscount extends StatelessWidget {
  AddDiscount({Key? key}) : super(key: key);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: 'Back',
          trailing: Text('Save'),
        ),
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  ColorAndImagePlaceHolder(
                    currentColor: '#ee5253',
                    product: null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BoxInputField(
                      enabled: false,
                      controller: controller,
                      trailing: Icon(
                        Icons.center_focus_weak,
                        color: primary,
                      ),
                      placeholder: 'Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BoxInputField(
                      enabled: false,
                      controller: controller,
                      trailing:
                          CupertinoSwitch(value: true, onChanged: (newVal) {}),
                      placeholder: 'Name',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
