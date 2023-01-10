import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const groupSettings = 'group_settings';
  static const thumbnailUrl = 'thumbnail_url';
  static const title = 'title';
  static const userId = 'uid';
  static const photoURL = 'photo_url';
  static const comment = 'comment';
  static const createdAt = 'created_at';
  static const displayName = 'display_name';
  static const email = 'email';
  static const groupId = 'group_id';
  static const date = 'date';
  static const time = 'time';
  static const pollId = 'poll_id';
  static const voteId = 'vote_id';
  static const voters = 'voters';
  static const meetingPolls = 'meeting_poll';
  static const calendarId = 'calendar_id';
  static const description = 'description';
  static const location = 'location';
  static const link = 'link';
  static const attendeeEmails = 'attendee_emails';
  static const shouldNotifyAttendees = 'should_notify';
  static const hasConferencingSupport = 'has_conferencing';
  static const startTimeInEpoch = 'start';
  static const endTimeInEpoch = 'end';

  const FirebaseFieldName._();
}
