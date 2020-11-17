import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_button/slider_button.dart';
import './calenderViewModel.dart';

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
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: SfDateRangePicker(
                      // based on https://pub.dev/packages/syncfusion_flutter_datepicker/example
                      onSelectionChanged: model.onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3))),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),

                  //FIXME: is it needed to add that line of all day?? I commented this code 
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: Text('All Day',
                  //           style: GoogleFonts.lato(
                  //               textStyle: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 11.0,
                  //                   color: Colors.grey[800]))),
                  //     ),
                  //     Expanded(
                  //         flex: 1,
                  //         child: Center(
                  //             child: SliderButton(
                  //           dismissible: false,
                  //           height: 30.0,
                  //           width: 100,
                  //           action: () {
                  //             ///Do something here
                  //             // Navigator.of(context).pop();
                  //           },
                  //           label: const Text(
                  //             '',
                  //             style: TextStyle(
                  //                 color: Color(0xff4a4a4a),
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 17),
                  //           ),
                  //           icon: const Text(
                  //             'x',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 44,
                  //             ),
                  //           ),
                  //         ))),
                  //   ],
                  // ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                ],
              ),
            ),
          );
        },
        onModelReady: (CalendarViewModel model) {
          //initialization here
        },
        viewModelBuilder: () => CalendarViewModel());
  }
}
