import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class SelectedCalendarPayload extends MapView<String, dynamic> {
  SelectedCalendarPayload({
    required String groupId,
    required String meetingId,
    required String title,
    required String description,
    required String date,
    required String time,
  }) : super({
          'title': title,
          'group_id': groupId,
          'meeting_id': meetingId,
          'description': description,
          'date': date,
          'time': time,
          'created_at': FieldValue.serverTimestamp(),
        });
}
