import 'package:calendy_x_project/common/auth/backends/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, String>> insertGoogleCalendar({
  required String title,
  required String description,
  required DateTime startDate,
  required TimeOfDay startTime,
  required List<EventAttendee> attendeesEmails,
  // required String link,
  required bool shouldNotifyAttendees,
  required bool hasConferenceSupport,
}) async {
  final authenticator = Authenticator();
  String calendarId = 'primary';
  Event event = Event();
  Map<String, String>? eventData;

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

  if (hasConferenceSupport) {
    ConferenceData conferenceData = ConferenceData();
    CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
    conferenceRequest.requestId =
        "${startDate.millisecondsSinceEpoch}-${startDate.millisecondsSinceEpoch}";
    conferenceData.createRequest = conferenceRequest;

    event.conferenceData = conferenceData;
  }

  try {
    if (authenticator.isAlreadyLoggedIn) {
      final CalendarApi calendarAPI = await authenticator.googleHttpClient();

      try {
        await calendarAPI.events
            .insert(
          event,
          calendarId,
          conferenceDataVersion: hasConferenceSupport ? 1 : 0,
          sendUpdates: shouldNotifyAttendees ? 'all' : 'none',
        )
            .then((se) {
          if (se.status == 'confirmed') {
            String? link;
            String? eventId;

            eventId = se.id;

            if (hasConferenceSupport) {
              link =
                  "https://meet.google.com/${se.conferenceData?.conferenceId}";
            }
            eventData = {
              'id': eventId!,
              'link': link!,
            };
          } else {
            print('yellow');
          }
        });
      } catch (e) {
        print('inner services: $e');
      }
    }
  } catch (e) {
    print('services: $e');
  }
  return eventData!;
}
