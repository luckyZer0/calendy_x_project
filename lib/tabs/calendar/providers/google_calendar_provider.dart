import 'package:calendy_x_project/tabs/calendar/backend/google_calendar_client.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleCalendarDataProvider = FutureProvider<List<Event>>(
  (ref) => getGoogleEventsData(),
);
