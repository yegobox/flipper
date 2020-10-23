import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/ui/widget/atoms/build_unit_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionSelectUnit extends StatefulWidget {
  const SectionSelectUnit({Key key}) : super(key: key);

  @override
  _SectionSelectUnitState createState() => _SectionSelectUnitState();
}

class _SectionSelectUnitState extends State<SectionSelectUnit> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Padding(
          padding: const EdgeInsets.only(left:18,right:18),
          child: Container(
            width: double.infinity,
            // margin: ,
            child: GestureDetector(
              onTap: () {
                // FIXME(richard):
                print(vm.tmpItem.id);
                // _navigationService.navigateTo(Routing.addUnitType,
                //     arguments: AddUnitTypeScreenArguments(
                //         productId: vm.tmpItem.id));
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0.4),
                dense:true,
                leading:const Text(
                  'Unit Type',
                ),
                trailing: Wrap(
                  children: [
                    const BuildUnitBody(),
                    Theme(data:ThemeData(iconTheme: const IconThemeData(color: Colors.black,)) ,child: const Icon(Icons.arrow_forward_ios))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
