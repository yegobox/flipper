import 'package:flipper/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/unit.dart';

class SectionSelectUnit extends StatelessWidget {
  const SectionSelectUnit({Key? key, required this.units}) : super(key: key);
  final List<Unit> units;
  Text unitSelector(List<Unit> units) {
    late Text text = Text('Select Unit');
    for (Unit unit in units) {
      if (unit.focused) {
        text = Text(unit.name);
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            ProxyService.nav.navigateTo(
              Routes.listUnits,
            );
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.4),
            dense: true,
            leading: const Text('Unit Type'),
            trailing: units.isNotEmpty
                ? Wrap(
                    children: [
                      unitSelector(units),
                      Theme(
                          data: ThemeData(
                            iconTheme: const IconThemeData(
                              color: Colors.black,
                            ),
                          ),
                          child: const Icon(Icons.arrow_forward_ios))
                    ],
                  )
                : const Text('Select Unit'),
          ),
        ),
      ),
    );
  }
}
