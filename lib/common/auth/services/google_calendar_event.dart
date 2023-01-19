import 'package:calendy_x_project/common/auth/backends/authenticator.dart';
import 'package:googleapis/calendar/v3.dart';

Future<List<Event>> getGoogleEventsData() async {
  final authenticator = Authenticator();

  final List<Event> appointments = <Event>[];

  if (authenticator.isAlreadyLoggedIn) {
    final CalendarApi calendarAPI = await authenticator.googleHttpClient();
    final Events primaryEvents = await calendarAPI.events.list('primary');
    final Events holidayEvents = await calendarAPI.events
        .list('en.malaysia#holiday@group.v.calendar.google.com');

    if (primaryEvents.items != null) {
      for (Event event in primaryEvents.items!) {
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }
    if (holidayEvents.items != null) {
      for (Event event in holidayEvents.items!) {
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }
  }
  return appointments;
}