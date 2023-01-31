import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';

class ListTenants extends StatelessWidget {
  ListTenants({required this.tenants});
  final List<ITenant> tenants;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Bind the product to bellow tenant for easy sell"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tenants.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(tenants[index].name),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused))
                                return Colors.red;
                              if (states.contains(MaterialState.hovered))
                                return Colors.green;
                              if (states.contains(MaterialState.pressed))
                                return Colors.blue;
                              return null; // Defer to the widget's default.
                            }),
                          ),
                          onPressed: () {
                            // Add button press logic here
                          },
                          child: Text('Bind'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
