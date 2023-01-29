import 'package:calendy_x_project/tabs/profile/models/profile_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileCalendarProvider = StreamProvider((ref) async* {
  final firestore = FirebaseFirestore.instance;
  yield* firestore
      .collection('selected_calendar')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ProfileCalendar(
                doc.data(),
                pcId: doc.id,
              ))
          .toList());
});