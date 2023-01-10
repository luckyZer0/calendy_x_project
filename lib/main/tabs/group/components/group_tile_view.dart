// import 'package:calendy_project_flutter/view/components/group_comments/group_comment_and_poll.dart';
// import 'package:flutter/material.dart';

// import 'package:calendy_project_flutter/state/groups/models/group.dart';

// class GroupCardView extends StatelessWidget {
//   final Iterable<Group> groups;

//   const GroupCardView({
//     Key? key,
//     required this.groups,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.only(top: 8.0),
//       itemCount: groups.length,
//       itemBuilder: (context, index) {
//         final group = groups.elementAt(index);

//         return InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => GroupCommentAndPoll(
//                 groupId: group.groupId,
//                 group: group,
//               ),
//             ),
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8.0,
//                   vertical: 4.0,
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 25,
//                       backgroundImage: NetworkImage(
//                         group.thumbnailUrl,
//                       ),
//                     ),
//                     const SizedBox(width: 16.0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           group.title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4.0),
//                         const Text(
//                           'last comment',
//                           softWrap: true,
//                         ),
//                         //TODO: add more stuff
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
