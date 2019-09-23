import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/day_view.dart';

import 'utils/all.dart';

@immutable
class Event {
  Event({
    @required this.startMinuteOfDay,
    @required this.duration,
    @required this.title,
  });

  bool visible = true;
  final int startMinuteOfDay;
  final int duration;

  final String title;
}

bool onlyVisible = false;
int visibleIndex = -1;

List<Event> events = <Event>[
  new Event(startMinuteOfDay: 0, duration: 60, title: "Midnight Party"),
  new Event(
      startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Get Dressed well"),
  new Event(
      startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
];

//List<Event> eventsOfDay1 = <Event>[
//  new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
//  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Drive To Work"),
//  new Event(startMinuteOfDay: 8 * 60, duration: 20, title: "A"),
//  new Event(startMinuteOfDay: 8 * 60, duration: 30, title: "B"),
//  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "C"),
//  new Event(startMinuteOfDay: 8 * 60 + 10, duration: 20, title: "D"),
//  new Event(startMinuteOfDay: 8 * 60 + 30, duration: 30, title: "E"),
//  new Event(startMinuteOfDay: 23 * 60, duration: 60, title: "Midnight Snack"),
//];

class DayViewExample extends StatefulWidget {
  @override
  State createState() => new _DayViewExampleState();
}

class _DayViewExampleState extends State<DayViewExample> {
  DateTime _day0;
  //DateTime _day1;

  @override
  void initState() {
    super.initState();

    _day0 = new DateTime.now();
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    if (onlyVisible) {
      List<StartDurationItem> list = [];
      Event event = events[visibleIndex];
      list.add(StartDurationItem(
          startMinuteOfDay: event.startMinuteOfDay,
          duration: event.duration,
          builder: (context, itemPosition, itemSize) => _eventBuilder(
                context,
                itemPosition,
                itemSize,
                event,
                events.indexOf(event),
              )));
      return list;
    } else {
      return events
          .map(
            (event) => new StartDurationItem(
                  startMinuteOfDay: event.startMinuteOfDay,
                  duration: event.duration,
                  builder: (context, itemPosition, itemSize) => _eventBuilder(
                        context,
                        itemPosition,
                        itemSize,
                        event,
                        events.indexOf(event),
                      ),
                ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DayView Example"),
      ),
      body: new DayViewEssentials(
        properties: new DayViewProperties(
          days: <DateTime>[
            _day0,
          ],
        ),
        child: new Column(
          children: <Widget>[
            new Container(
              color: Colors.grey[200],
              child: new DayViewDaysHeader(
                headerItemBuilder: _headerItemBuilder,
              ),
            ),
            new Expanded(
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new SingleChildScrollView(
                        child: new DayViewSchedule(
                          heightPerMinute: 1.0,
                          components: <ScheduleComponent>[
                            new TimeIndicationComponent.intervalGenerated(
                              generatedTimeIndicatorBuilder:
                              _generatedTimeIndicatorBuilder,
                            ),
                            new SupportLineComponent.intervalGenerated(
                              generatedSupportLineBuilder:
                              _generatedSupportLineBuilder,
                            ),
                            new DaySeparationComponent(
                              generatedDaySeparatorBuilder:
                              _generatedDaySeparatorBuilder,
                            ),
                            new EventViewComponent(
                              getEventsOfDay: _getEventsOfDay,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 80,
                    color: Color.fromARGB(155, 255, 255, 255),
                    child: Stack(
                      children: <Widget>[
                        _timeCircle(events[visibleIndex],true),
                        _timeCircle(events[visibleIndex],false)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "${weekdayToAbbreviatedString(day.weekday)}",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          new Text("${day.day}"),
        ],
      ),
    );
  }

  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        child: new Center(
          child: new Text(_minuteOfDayToHourMinuteString(minuteOfDay)),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemWidth,
      child: new Container(
        height: 0.7,
        color: Color.fromARGB((255 * 0.4).floor(), 228, 231, 240),
      ),
    );
  }

  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
        child: new Container(
          width: 0.7,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned _eventBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    Event event,
    int index,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
//      child: Column(
//        children: <Widget>[
//          onlyVisible?GestureDetector(
//            onPanUpdate: (DragUpdateDetails e){
//              print("move");
//              _moveLine(index,e,itemSize.height);
//            },
//            child: Container(
//              height: 3,
//              color: Colors.blue,
//            ),
//          ):Container(),
      child: GestureDetector(
        child: new Container(
          margin: new EdgeInsets.only(left: 1.0, right: 1.0, bottom: 1.0),
          padding: new EdgeInsets.all(3.0),
          color: Color.fromARGB(55, 165, 214, 167),
          child: new Text("${event.title}"),
        ),
        onTap: () {
          setState(() {
            if (onlyVisible) {
              _changeOnlyVisible(index, false);
            } else {
              _changeOnlyVisible(index, true);
            }
          });
        },
      ),
//          onlyVisible?GestureDetector(
//            onPanDown: (DragDownDetails e){
//              print("用户手按下");
//            },
//            onPanUpdate: (DragUpdateDetails e){
//              print("move");
//              _moveLine(index,e,itemSize.height);
//            },
//            onPanEnd: (DragEndDetails e){
//              print("抬起");
//            },
//            child: Container(
//              height: 3,
//              color: Colors.blue,
//            ),
//          ):Container(),
//        ],
//      ),
    );
  }

  void _moveLine(int index, DragUpdateDetails e, double height) {
    setState(() {
      Event newEvent = new Event(
          startMinuteOfDay: events[index].startMinuteOfDay,
          duration:
              (events[index].duration + (e.delta.dy / height) * 60).floor(),
          title: events[index].title);
      events[index] = newEvent;
    });
  }

  _timeCircle(Event event,bool start) {
    double timeShow = (start ? event.startMinuteOfDay  : event.startMinuteOfDay + event.duration) as double;
    String time =
    return Positioned(
      top: timeShow,
      left: 0,
      child: CircleAvatar(
        child: Text("01.00"),
      ),
    )
  }
}

void _changeOnlyVisible(int index, bool only) {
  if (only) {
    onlyVisible = true;
    visibleIndex = index;
  } else {
    onlyVisible = false;
    visibleIndex = -1;
  }
}
