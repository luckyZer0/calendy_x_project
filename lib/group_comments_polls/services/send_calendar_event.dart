import 'package:calendy_x_project/common/auth/backends/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:uuid/uuid.dart';

Future<void> insertGoogleCalendar({
  required String title,
  required String description,
  required DateTime startDate,
  required TimeOfDay startTime,
  required List<EventAttendee> attendeesEmails,
  // required String link,
  // required bool shouldNotifyAttendees,
  // required bool hasConferencingSupport,
}) async {
  final authenticator = Authenticator();
  String calendarId = 'primary';
  Event event = Event();

  event.summary = title;
  event.description = description;
  event.attendees = attendeesEmails;

  EventDateTime start = EventDateTime();
  start.dateTime = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
    startTime.hour,
    startTime.minute,
  );
  start.timeZone = "GMT+08:00";
  event.start = start;

  EventDateTime end = EventDateTime();
  end.dateTime = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
    startTime.hour,
    startTime.minute,
  ).add(const Duration(hours: 2));

  end.timeZone = "GMT+08:00";
  event.end = end;

  String scheduleId = const Uuid().v1().replaceAll("-", "");

  event.id = scheduleId;
  try {
    if (authenticator.isAlreadyLoggedIn) {
      final CalendarApi calendarAPI = await authenticator.googleHttpClient();

      try {
        await calendarAPI.events.insert(event, calendarId);
      } catch (e) {
        print('inner services: $e');
      }
    }
  } catch (e) {
    print('services: $e');
  }
}
