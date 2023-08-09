import 'dart:developer';

import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';

class ListTenants extends StatelessWidget {
  ListTenants(
      {required this.tenants, required this.product, required this.model});
  final List<ITenant> tenants;
  final Product product;
  final ProductViewModel model;
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
                          onPressed: () async {
                            log(tenants[index].id.toString());
                            await model.bindTenant(
                                tenantId: tenants[index].id,
                                productId: product.id);
                            showToast(
                                context, 'Binded to ${tenants[index].name}');
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
