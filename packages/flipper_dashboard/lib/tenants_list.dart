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
                    return ListTile(
                      title: Text(tenants[index].name),
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
