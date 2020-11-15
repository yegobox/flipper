import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:stacked/stacked.dart';
import './calenderViewModel.dart';

//TODO:{Telesphore} work on  selecting multiple date -> set colors on them

class CalendarView extends StatelessWidget {
  const CalendarView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, CalendarViewModel model, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Customize Report',
                style: TextStyle(color: Colors.black, fontSize: 12.0),
              ),
              backgroundColor: Colors.grey[300],
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                Container(
                  child: RaisedButton(
                    onPressed: null,
                    elevation: 0.0,
                    child: Text('Save',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white)),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                       const Text('Time ranges:'),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 80,
                  right: 0,
                  bottom: 0,
                  // give me a minute to read doc
                  child: SfDateRangePicker(
                    // based on https://pub.dev/packages/syncfusion_flutter_datepicker/example
                    onSelectionChanged: model.onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  ),
                )
              ],
            ),
          );
        },
        onModelReady: (CalendarViewModel model) {
          //initialization here
        },
        viewModelBuilder: () => CalendarViewModel());
  }
}
