import 'package:googleapis/calendar/v3.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GoogleCalendarClient extends CalendarDataSource {
  final List<Event>? events;
  GoogleCalendarClient({this.events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final Event event = appointments![index];
    return (event.start!.date ?? event.start!.dateTime!.toLocal());
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrence == null
        ? ""
        : appointments![index].recurrence[0];
  }

  @override
  DateTime getEndTime(int index) {
    final Event event = appointments![index];
    if (event.endTimeUnspecified != null) {
      return (event.start!.date ?? event.start!.dateTime!.toLocal());
    } else {
      return (event.end?.date != null
          ? event.end!.date!.add(const Duration(days: -1))
          : event.end!.dateTime!.toLocal());
    }
  }

  @override
  String getLocation(int index) {
    return appointments![index].location.toString();
  }

  @override
  String getNotes(int index) {
    return appointments![index].description.toString();
  }

  @override
  String getSubject(int index) {
    final Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoogleCalendarClient &&
          runtimeType == other.runtimeType &&
          events == other.events;

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        events,
      ]);
}
