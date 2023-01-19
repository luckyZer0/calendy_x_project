import 'package:calendy_x_project/common/auth/services/google_calendar_event.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleCalendarDataProvider = FutureProvider<List<Event>>(
  (ref) => getGoogleEventsData(),
);
