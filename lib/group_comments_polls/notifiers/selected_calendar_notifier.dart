import 'package:calendy_x_project/common/typedef/is_loading.dart';
import 'package:calendy_x_project/group_comments_polls/models/selected_calendar_payload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectedCalendarNotifier extends StateNotifier<IsLoading> {
  SelectedCalendarNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> selectedCalendar({
    required String title,
    required String description,
    required String date,
    required String time,
    required String groupId,
    required String meetingId,
  }) async {
    isLoading = true;
    final selectedCalendarPayload = SelectedCalendarPayload(
      title: title,
      description: description,
      date: date,
      time: time,
      groupId: groupId,
      meetingId: meetingId,
    );

    await FirebaseFirestore.instance
        .collection('selected_calendar')
        .add(selectedCalendarPayload);
    try {
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
