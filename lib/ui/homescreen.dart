

import 'package:flipper/ui/flipper_drawer.dart';
import 'package:flipper/ui/home_app_bar.dart';
import 'package:flipper/ui/keypad/poswidget.dart';
import 'package:flipper/ui/product/product_screen.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/ui/welcome/payable/payable_view.dart';


import 'package:flipper/ui/widget/bottom_menu_bar.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';


class HomeScreen extends StatefulWidget {
  final ValueNotifier<bool> sideOpenController;
  final CommonViewModel vm;
  final bool showAppBar;

  // ignore: sort_constructors_first
  const HomeScreen({
    Key key,
    @required this.sideOpenController,
    this.showAppBar = false,
    this.vm,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      // FIXME(richard): clean sleepy code
      // final TabsTableData b = TabsTableData(id: 1, tab: _tabController.index);
      // StoreProvider.of<AppState>(context).state.database.tabsDao.updateTab(b);
    });
  }

  Widget _body() {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,HomeViewModel model,Widget child){
      return SafeArea(
      child: Container(
        child: _getPage(model.tab),
      ),
    );
    }, 
    onModelReady: (HomeViewModel model){
      model.initTab();
    },
    viewModelBuilder: ()=>HomeViewModel());
  }

  // ignore: missing_return
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Poswidget();
        break;
      case 1:
      
        return const ProductScreen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // _nextPage(1);//default to 1
    return Scaffold(
      extendBody: true,
      key: _scaffoldKey,
      appBar: HomeAppBar(
        scaffoldKey: _scaffoldKey,
        sideOpenController: widget.sideOpenController,
      ),
      bottomNavigationBar: const BottomMenubar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:5.0,right: 5.0),
            child: PayableView(),
          ),
          Expanded(child: Container(child:_body())),
        ],
      ),
      drawer: FlipperDrawer(
        vm: widget.vm,
      ),
    );
  }
}
