import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/flipper_color.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditItemTitle extends StatefulWidget {
  EditItemTitle({Key key}) : super(key: key);

  @override
  _EditItemTitleState createState() => _EditItemTitleState();
}

class _EditItemTitleState extends State<EditItemTitle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Router.navigator.pop();
            },
            title: "Edit item Tile",
            icon: Icons.keyboard_backspace,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Wrap(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextField(
                                maxLines: 4,
                                autofocus: false,
                                style: TextStyle(
                                    fontSize: 22.0, color: Color(0xFFbdc6cf)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: HexColor(vm.currentColor == null
                                      ? "#0984e3"
                                      : vm.currentColor.hexCode),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text("New Item")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("CHOOSE LABEL COLOR"),
                ),
              ),
              StreamBuilder(
                stream: vm.database.colorDao.getColors(),
                builder:
                    (context, AsyncSnapshot<List<ColorTableData>> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 32.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: buildStack(context, snapshot.data, vm),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("PHOTO LABEL"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 0, 28.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: OutlineButton(
                          color: HexColor("#ecf0f1"),
                          child: Text("Choose Photo"),
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: S.of(context).commingSoon,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: OutlineButton(
                          color: HexColor("#ecf0f1"),
                          child: Text("Take Photo"),
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: S.of(context).commingSoon,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            // Router.navigator
                            //     .pushNamed(Router.takePictureScreen);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildStack(
      BuildContext context, List<ColorTableData> colors, CommonViewModel vm) {
    List<Widget> stacks = new List<Widget>();
    if (colors != null) {
      for (var i = 0; i < colors.length; i++) {
        //register a store for each and handle them later.
        stacks.add(
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 80,
                width: 120,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: HexColor(colors[i].name),
                    ),
                  ),
                  color: HexColor(colors[i].name),
                  child: null,
                  onPressed: () {
                    //reset all other color to not selected
                    for (var y = 0; y < colors.length; y++) {
                      vm.database.colorDao
                          .updateColor(colors[y].copyWith(isActive: false));
                    }
                    vm.database.colorDao.updateColor(
                        colors[i].copyWith(isActive: !colors[i].isActive));
                    StoreProvider.of<AppState>(context).dispatch(
                      CurrentColor(
                        color: FlipperColor((c) => c..hexCode = colors[i].name),
                      ),
                    );
                  },
                ),
              ),
              colors[i].isActive
                  ? IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        //reset all other color to not selected
                        for (var y = 0; y < colors.length; y++) {
                          vm.database.colorDao
                              .updateColor(colors[y].copyWith(isActive: false));
                        }
                        vm.database.colorDao.updateColor(
                            colors[i].copyWith(isActive: !colors[i].isActive));
                        StoreProvider.of<AppState>(context).dispatch(
                          CurrentColor(
                            color: FlipperColor(
                                (c) => c..hexCode = colors[i].name),
                          ),
                        );
                      },
                    )
                  : Visibility(
                      visible: false,
                      child: Text(""),
                    )
            ],
          ),
        );
      }
    }

    return stacks;
  }
}
