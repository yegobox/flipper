import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper/locator.dart';

class CategorySection extends StatefulWidget {
  CategorySection({Key key}) : super(key: key);

  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final NavigationService _navigationService = locator<NavigationService>();
  
  Text categorySelector(List<CategoryTableData> categories) {
    Text text;
    for (var i = 0; i < categories.length; i++) {
      if (categories[i].focused) {
        text = Text(categories[i].name);
        StoreProvider.of<AppState>(context).dispatch(
          CategoryAction(
            category: Category((c) => c
              ..branchId = categories[i].branchId
              ..id = categories[i].id
              ..focused = categories[i].focused
              ..name = categories[i].name),
          ),
        );
        return text;
      } else {
        text = Text('Select Category');
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Center(
          child: Container(
            width: 300,
            child: GestureDetector(
              onTap: () {
                _navigationService.navigateTo(Routing.addCategoryScreen);
              },
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.3),
                leading: Text('Category'),
                trailing: Wrap(
                  children: <Widget>[
                    StreamBuilder(
                      stream: vm.database.categoryDao.getCategoriesStream(),
                      builder: (context,
                          AsyncSnapshot<List<CategoryTableData>> snapshot) {
                        if (snapshot.data == null) {
                          return Text('Select Category');
                        }
                        return snapshot.data == null
                            ? Text('Select Category')
                            : categorySelector(snapshot.data);
                      },
                    ),
                    Icon(Icons.arrow_forward_ios)
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
