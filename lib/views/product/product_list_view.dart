
import 'package:flipper/widget/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'products_viewmodel.dart';
class ProductListView extends StatelessWidget {
  const ProductListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ProductsViewModel model, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'List Items', // title
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.grey[800]),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [],
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                    child: Column(
                      children: [
                        // Add navabr
                        const SearchView(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600])),
                          child: RaisedButton(
                            child: const Text(' CREATE ITEM '),
                            onPressed: () {},
                            color: Colors.grey[200],
                            textColor: Colors.blue[600],
                            splashColor: Colors.grey,
                            padding: const EdgeInsets.all(15.0),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _listItems(
                            name: 'Kiw', pricing: '2 Pieces', context: context),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _listItems(
                            name: 'Kiw', pricing: '2 Pieces', context: context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => ProductsViewModel());
  }

  //list of activities

  Widget _listItems(
      {@required String name, @required String pricing, BuildContext context}) {
    return SingleChildScrollView(
        child: Container(
      height: 50.0,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).hintColor),
              top: BorderSide(color: Theme.of(context).hintColor),
              left: BorderSide(color: Theme.of(context).hintColor))),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50.0,
              color: Colors.grey[600],
              child: const Center(
                  child: Text(
                'KI',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(2.0), child: Text(name)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(6.0), child: Text(pricing)),
            ),
          )
        ],
      ),
    ));
  }
}
