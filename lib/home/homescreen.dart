import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/flipper_drawer.dart';
import 'package:flipper/home/home_app_bar.dart';
import 'package:flipper/home/keypad/poswidget.dart';
import 'package:flipper/home/products/product_screen.dart';
import 'package:flipper/home/widget/bottom_menu_bar.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/presentation/widgets/payable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
      final TabsTableData b = TabsTableData(id: 1, tab: _tabController.index);
      StoreProvider.of<AppState>(context).state.database.tabsDao.updateTab(b);
    });
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) {
      return;
    }

    _tabController.animateTo(newIndex);
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        child: _getPage(StoreProvider.of<AppState>(context).state.tab),
      ),
    );
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
    _nextPage(widget.vm.tab);
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
            child: PayableWidget(),
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
