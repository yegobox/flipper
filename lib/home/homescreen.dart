import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/flipper_drawer.dart';
import 'package:flipper/home/home_app_bar.dart';
import 'package:flipper/home/keypad/poswidget.dart';
import 'package:flipper/home/product_screen.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/presentation/widgets/payable_widget.dart';
import 'package:flipper/util/HexColor.dart';
import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<bool> sideOpenController;
  final CommonViewModel vm;
  final bool showAppBar;

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      key: _scaffoldKey,
      appBar: HomeAppBar(
        scaffoldKey: _scaffoldKey,
        sideOpenController: widget.sideOpenController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard),
            title: Text('POS'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('ITEMS'),
          ),
        ],
        selectedItemColor: Colors.amber[800],
        currentIndex: widget.vm.tab,
        onTap: (num) {

          _nextPage(num == 0 ? -1 : 1);
          StoreProvider.of<AppState>(context).dispatch(CurrentTab(tab: num));
          StoreProvider.of<AppState>(context).dispatch(OnSetTab());
        },
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: PayableWidget(),
          ),
          Expanded(
            child: Container(
              color: HexColor("#95cbe8"),
              // child: ProductScreen(),
              child: DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[Poswidget(), ProductScreen()],
                ),
              ),
            ),
          )
        ],
      ),
      drawer: FlipperDrawer(
        vm: widget.vm,
      ),
    );
  }
}
