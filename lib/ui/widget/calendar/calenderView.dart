import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';
import './calenderViewModel.dart';

//TODO:{Telesphore} work on  selecting multiple date -> set colors on them

class CalendarView extends StatelessWidget {
  CalendarView({Key key, this.title}) : super(key: key);
  final String title;

  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2019, 2, 10): [
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );
  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, CalendarViewModel model, Widget child) {
          _calendarCarouselNoHeader = CalendarCarousel<Event>(
            todayBorderColor: Colors.green,
            onDayPressed: (DateTime date, List<Event> events) {
              model.todayDate(date: date);
              // ignore: avoid_function_literals_in_foreach_calls
              events.forEach((event) => print(event.title));
            },
            daysHaveCircularBorder: true,
            showOnlyCurrentMonthDate: false,
            weekendTextStyle: const TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
            weekFormat: false,
            firstDayOfWeek: 4,
            markedDatesMap: _markedDateMap,
            height: 420.0,
            selectedDateTime: model.currentDate2,
            targetDateTime: model.targetDateTime,
            customGridViewPhysics: const NeverScrollableScrollPhysics(),
            markedDateCustomShapeBorder:
                const CircleBorder(side: BorderSide(color: Colors.yellow)),
            markedDateCustomTextStyle: const TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
            showHeader: false,
            todayTextStyle: const TextStyle(
              color: Colors.blue,
            ),
            markedDateShowIcon: true,
            markedDateIconMaxShown: 2,
            markedDateIconBuilder: (event) {
              return event.icon;
            },
            markedDateMoreShowTotal: true,
            todayButtonColor: Colors.yellow,
            selectedDayTextStyle: const TextStyle(
              color: Colors.yellow,
            ),
            minSelectedDate:
                model.currentDate.subtract(const Duration(days: 360)),
            maxSelectedDate: model.currentDate.add(const Duration(days: 360)),
            prevDaysTextStyle: const TextStyle(
              fontSize: 16,
              color: Colors.pinkAccent,
            ),
            inactiveDaysTextStyle: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 16,
            ),
            onCalendarChanged: (DateTime date) {
              model.calendarChange(date: date);
            },
            onDayLongPressed: (DateTime date) {
              print('long pressed date $date');
            },
          );
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
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //custom icon
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _calendarCarousel,
                    ), // This trailing comma makes auto-formatting nicer for build methods.
                    //custom icon without header
                    Container(
                      margin: const EdgeInsets.only(
                        top: 30.0,
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            '${model.currentMonth}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          )),
                          FlatButton(
                            child: const Icon(Entypo.chevron_left),
                            onPressed: () {
                              model.previousMonth();
                            },
                          ),
                          FlatButton(
                            child: const Icon(Entypo.chevron_right),
                            onPressed: () {
                              model.nextMonth();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _calendarCarouselNoHeader,
                    ), //
                  ],
                ),
              ));
        },
        onModelReady: (CalendarViewModel model) {
          //initialization here
        },
        viewModelBuilder: () => CalendarViewModel());
  }
}
